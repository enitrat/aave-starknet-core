%lang starknet

from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math_cmp import is_not_zero
from starkware.cairo.common.uint256 import Uint256

from openzeppelin.security.safemath.library import SafeUint256
from openzeppelin.token.erc20.library import Transfer

from contracts.interfaces.i_aave_incentives_controller import IAaveIncentivesController
from contracts.protocol.libraries.math.helpers import (
    to_uint256,
    assert_nonnegative_uint256,
    assert_not_zero_uint256,
)
from contracts.protocol.libraries.math.helpers import to_felt
from contracts.protocol.libraries.math.wad_ray_math import WadRayMath
from contracts.protocol.libraries.types.data_types import DataTypes
from contracts.protocol.tokenization.base.incentivized_erc20_library import IncentivizedERC20
from contracts.protocol.libraries.helpers.errors import Errors
from contracts.protocol.libraries.math.safe_uint256_cmp import SafeUint256Cmp

//
// The original contracts have an abstract one to handle the internal _mint
// and _burn functions, they are not inherited by anyone else other than
// by ScaledBalanceToken abstract contract, hence we're leaving these
// functions as internal in this namespace, if reuse is needed, one can
// declare a new namespace containing them and use them as such.
//

//
// Events
//

@event
func Mint(
    caller: felt,
    on_behalf_of: felt,
    amount_to_mint: Uint256,
    balance_increase: Uint256,
    index: felt,
) {
}

@event
func Burn(
    user: felt, target: felt, amount_to_burn: Uint256, balance_decrease: Uint256, index: felt
) {
}

//
// Internal
//

func _handle_action{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    account: felt, old_account_balance: Uint256, old_total_supply: Uint256
) {
    let (incentives_controller) = IncentivizedERC20.get_incentives_controller();
    let incentives_controller_not_zero = is_not_zero(incentives_controller);
    if (incentives_controller_not_zero == TRUE) {
        IAaveIncentivesController.handle_action(
            contract_address=incentives_controller,
            account=account,
            user_balance=old_account_balance,
            total_supply=old_total_supply,
        );
        return ();
    }
    return ();
}

//
// @notice Mints tokens to an account and apply incentives if defined
// @param account The address receiving tokens
// @param amount The amount of tokens to mint
//
func _mint{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    account: felt, amount: Uint256
) {
    alloc_locals;
    // Assert valid amount
    assert_nonnegative_uint256(amount);

    // Set new total_supply
    let (local old_total_supply) = IncentivizedERC20.total_supply();
    let (local total_supply) = SafeUint256.add(old_total_supply, amount);
    IncentivizedERC20.set_total_supply(total_supply);

    let (local old_user_state: DataTypes.UserState) = IncentivizedERC20.get_user_state(account);
    tempvar old_user_balance = old_user_state.balance;

    // Set new user balance
    let (local old_user_balance_uint256) = to_uint256(old_user_balance);
    let (local new_user_balance) = SafeUint256.add(old_user_balance_uint256, amount);
    let (local new_user_balance_felt) = to_felt(new_user_balance);

    IncentivizedERC20.set_balance(account, new_user_balance_felt);

    _handle_action(account, old_user_balance_uint256, old_total_supply);

    return ();
}

//
// @notice Burns tokens from an account and apply incentives if defined
// @param account The account whose tokens are burnt
// @param amount The amount of tokens to burn
//
func _burn{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    account: felt, amount: Uint256
) {
    alloc_locals;
    // Assert valid amount
    assert_nonnegative_uint256(amount);

    // Set new total_supply
    let (local old_total_supply) = IncentivizedERC20.total_supply();
    with_attr error_message("Amount larger than total supply") {
        let (local total_supply) = SafeUint256.sub_le(old_total_supply, amount);
    }
    IncentivizedERC20.set_total_supply(total_supply);

    let (local old_user_state: DataTypes.UserState) = IncentivizedERC20.get_user_state(account);
    tempvar old_user_balance = old_user_state.balance;

    // Set new user balance
    let (local old_user_balance_uint256) = to_uint256(old_user_balance);
    with_attr error_message("Amount larger than balance") {
        let (local new_user_balance) = SafeUint256.sub_le(old_user_balance_uint256, amount);
    }
    let (local new_user_balance_felt) = to_felt(new_user_balance);
    IncentivizedERC20.set_balance(account, new_user_balance_felt);

    _handle_action(account, old_user_balance_uint256, old_total_supply);

    return ();
}

func _handle_state_change{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    user: felt, amount: Uint256, index: felt
) -> (
    amount_ray: Uint256, amount_scaled: Uint256, balance_increase: Uint256, old_user_index: felt
) {
    alloc_locals;

    tempvar amount_ray = amount;
    let (local index_uint256) = to_uint256(index);
    tempvar index_ray = index_uint256;
    let (local amount_scaled) = WadRayMath.ray_div(amount_ray, index_ray);

    // TODO: This error originally identifies whether it is mint or burn
    // There is no easy way to pass that as argument. Should we remove
    // this from this logic?
    let error_code = Errors.INVALID_AMOUNT;
    with_attr error_message("{error_code}") {
        assert_not_zero_uint256(amount_scaled);
    }

    let (local old_user_state: DataTypes.UserState) = IncentivizedERC20.get_user_state(user);
    tempvar old_user_balance = old_user_state.balance;
    let (local old_user_balance_256) = to_uint256(old_user_balance);
    let old_user_balance_ray = old_user_balance_256;

    tempvar old_user_index = old_user_state.additional_data;
    let (local old_user_index_256) = to_uint256(old_user_index);
    tempvar old_user_index_ray = old_user_index_256;

    let (local new_scaled_balance) = WadRayMath.ray_mul(old_user_balance_ray, index_ray);
    let (local old_scaled_balance) = WadRayMath.ray_mul(old_user_balance_ray, old_user_index_ray);
    let (local balance_increase) = WadRayMath.ray_sub(new_scaled_balance, old_scaled_balance);

    IncentivizedERC20.set_additional_data(user, index);

    return (amount_ray, amount_scaled, balance_increase, old_user_index);
}

namespace ScaledBalanceToken {
    //
    // @notice Implements the basic logic to mint a scaled balance token.
    // @param caller The address performing the mint
    // @param on_behalf_of The address of the user that will receive the scaled tokens
    // @param amount The amount of tokens getting minted
    // @param index The next liquidity index of the reserve
    // @return `true` if the the previous balance of the user was 0
    //
    func mint_scaled{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        caller: felt, on_behalf_of: felt, amount: Uint256, index: felt
    ) -> (success: felt) {
        alloc_locals;

        let (
            local amount_ray, local amount_scaled, local balance_increase, local old_user_index
        ) = _handle_state_change(on_behalf_of, amount, index);

        _mint(on_behalf_of, amount_scaled);

        // TODO Should revert on overflow?
        let (local amount_to_mint: Uint256, _) = WadRayMath.ray_add(amount_ray, balance_increase);

        Transfer.emit(0, on_behalf_of, amount_to_mint);
        Mint.emit(caller, on_behalf_of, amount_to_mint, balance_increase, index);

        if (old_user_index == 0) {
            return (TRUE,);
        }

        return (FALSE,);
    }

    //
    // @notice Implements the basic logic to burn a scaled balance token.
    // @dev In some instances, a burn transaction will emit a mint event
    //      if the amount to burn is less than the interest that the user accrued
    // @param user The user which tokens are burnt
    // @param target The address that will receive the underlying, if any
    // @param amount The amount getting burned
    // @param index The variable debt index of the reserve
    //
    func burn_scaled{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        user: felt, target: felt, amount: Uint256, index: felt
    ) {
        alloc_locals;

        let (
            local amount_ray, local amount_scaled, local balance_increase, _
        ) = _handle_state_change(user, amount, index);

        _burn(user, amount_scaled);

        let (is_balance_increase_le_than_amount) = SafeUint256Cmp.le(balance_increase, amount);

        if (is_balance_increase_le_than_amount == TRUE) {
            let (local amount_to_burn) = WadRayMath.ray_sub(amount_ray, balance_increase);
            Transfer.emit(user, 0, amount_to_burn);
            Burn.emit(user, target, amount_to_burn, balance_increase, index);
            return ();
        } else {
            let (local amount_to_mint) = WadRayMath.ray_sub(balance_increase, amount_ray);
            Transfer.emit(0, user, amount_to_mint);
            Mint.emit(user, user, amount_to_mint, balance_increase, index);
            return ();
        }
    }

    func get_scaled_user_balance_and_supply{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }(user: felt) -> (balance: Uint256, supply: Uint256) {
        let (balance) = IncentivizedERC20.balance_of(user);
        let (supply) = IncentivizedERC20.total_supply();
        return (balance, supply);
    }

    func get_previous_index{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        user: felt
    ) -> (index: felt) {
        let (state) = IncentivizedERC20.get_user_state(user);
        let index = state.additional_data;
        return (index,);
    }
}
