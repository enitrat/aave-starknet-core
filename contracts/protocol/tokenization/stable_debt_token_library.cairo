%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math_cmp import is_not_zero
from starkware.cairo.common.uint256 import Uint256, uint256_eq
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.starknet.common.syscalls import get_block_timestamp

from openzeppelin.security.safemath.library import SafeUint256
from openzeppelin.token.erc20.library import Transfer

from contracts.protocol.libraries.aave_upgradeability.versioned_initializable_library import (
    VersionedInitializable,
)
from contracts.protocol.tokenization.base.incentivized_erc20_library import IncentivizedERC20
from contracts.protocol.tokenization.base.debt_token_base_library import DebtTokenBase
from contracts.protocol.libraries.types.data_types import DataTypes
from contracts.protocol.libraries.math.math_utils import MathUtils
from contracts.protocol.libraries.math.wad_ray_math import WadRayMath
from contracts.protocol.libraries.math.helpers import to_felt, to_uint256
from contracts.interfaces.i_aave_incentives_controller import IAaveIncentivesController
from contracts.protocol.libraries.math.safe_uint256_cmp import SafeUint256Cmp

@event
func Initialized(
    underlying_asset: felt,
    pool: felt,
    incentives_controller: felt,
    debt_token_decimals: felt,
    debt_token_name: felt,
    debt_token_symbol: felt,
    params: felt,
) {
}

@storage_var
func StableDebtToken_avg_stable_rate() -> (rate: felt) {
}

// Map of users address and the timestamp of their last update (user => last_updated_timestamp)
@storage_var
func StableDebtToken_timestamps(user: felt) -> (last_updated: felt) {
}

@storage_var
func StableDebtToken_user_state(user: felt) -> (user_state: DataTypes.UserState) {
}

// Timestamp of the last update of the total supply
@storage_var
func StableDebtToken_total_supply_timestamp() -> (timestamp: felt) {
}

// @dev Emitted when new stable debt is minted
// @param user The address of the user who triggered the minting
// @param on_behalf_of The recipient of stable debt tokens
// @param amount The amount minted (user entered amount + balance increase from interest)
// @param current_balance The current balance of the user
// @param balance_increase The increase in balance since the last action of the user
// @param new_rate The rate of the debt after the minting
// @param avg_stable_rate The next average stable rate after the minting
// @param new_total_supply The next total supply of the stable debt token after the action
@event
func Mint(
    user: felt,
    on_behalf_of: felt,
    amount: Uint256,
    current_balance: Uint256,
    balance_increase: Uint256,
    new_rate: Uint256,
    avg_stable_rate: Uint256,
    new_total_supply: Uint256,
) {
}

// @dev Emitted when new stable debt is burned
// @param address_from The address from which the debt will be burned
// @param amount The amount being burned (user entered amount - balance increase from interest)
// @param current_balance The current balance of the user
// @param balance_increase The the increase in balance since the last action of the user
// @param avg_stable_rate The next average stable rate after the burning
// @param new_total_supply The next total supply of the stable debt token after the action
@event
func Burn(
    address_from: felt,
    amount: Uint256,
    current_balance: Uint256,
    balance_increase: Uint256,
    avg_stable_rate: Uint256,
    new_total_supply: Uint256,
) {
}

const REVISION = 1;

namespace StableDebtToken {
    func initialize{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        initializing_pool: felt,
        underlying_asset: felt,
        incentives_controller: felt,
        debt_token_decimals: felt,
        debt_token_name: felt,
        debt_token_symbol: felt,
        params: felt,
    ) {
        alloc_locals;
        VersionedInitializable.initializer(REVISION);
        IncentivizedERC20.initialize(
            initializing_pool, debt_token_name, debt_token_symbol, debt_token_decimals
        );
        DebtTokenBase.set_underlying_asset(underlying_asset);

        IncentivizedERC20.set_incentives_controller(incentives_controller);

        Initialized.emit(
            underlying_asset,
            initializing_pool,
            incentives_controller,
            debt_token_decimals,
            debt_token_name,
            debt_token_symbol,
            params,
        );

        return ();
    }

    func get_revision() -> (revision: felt) {
        return (REVISION,);
    }

    // @notice Returns the average rate of all the stable rate loans.
    // @return The average stable rate
    func get_average_stable_rate{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        ) -> (avg_stable_rate: felt) {
        let (avg_stable_rate) = StableDebtToken_avg_stable_rate.read();
        return (avg_stable_rate,);
    }

    // @notice Returns the timestamp of the last update of the user
    // @param user The address of the user
    // @return The timestamp
    func get_user_last_updated{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        user: felt
    ) -> (timestamp: felt) {
        let (timestamp) = StableDebtToken_timestamps.read(user);
        return (timestamp,);
    }

    // @notice Returns the stable rate of the user debt
    // @param user The address of the user
    // @return The stable rate of the user
    func get_user_stable_rate{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        user: felt
    ) -> (stable_rate: felt) {
        let (user_state) = IncentivizedERC20.get_user_state(user);
        let stable_rate = user_state.additional_data;
        return (stable_rate,);
    }

    // IERC20
    func balance_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        account: felt
    ) -> (balance: Uint256) {
        alloc_locals;
        let (local account_balance: Uint256) = IncentivizedERC20.balance_of(account);
        let (stable_rate) = get_user_stable_rate(account);
        let (is_balance_zero) = uint256_eq(account_balance, Uint256(0, 0));
        if (is_balance_zero == TRUE) {
            return (Uint256(0, 0),);
        }

        let (last_updated) = get_user_last_updated(account);
        let (stable_rate_256) = to_uint256(stable_rate);
        let (cumulated_interest) = MathUtils.calculate_compounded_interest(
            stable_rate_256, last_updated
        );
        let (balance) = WadRayMath.ray_mul(account_balance, cumulated_interest);
        return (balance,);
    }

    // @notice Mints debt token to the `onBehalfOf` address.
    // @dev The resulting rate is the weighted average between the rate of the new debt
    // and the rate of the previous debt
    // @param user The address receiving the borrowed underlying, being the delegatee in case
    // of credit delegate, or same as `on_behalf_of` otherwise
    // @param on_behalf_of The address receiving the debt tokens
    // @param amount The amount of debt tokens to mint
    // @param rate The rate of the debt being minted
    // @return True if it is the first borrow, false otherwise
    // @return The total stable debt
    // @return The average stable borrow rate
    func mint{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        user: felt, on_behalf_of: felt, amount: Uint256, rate: felt
    ) -> (is_first_borrow: felt, total_stable_debt: Uint256, avg_stable_borrow_rate: felt) {
        alloc_locals;
        IncentivizedERC20.assert_only_pool();
        let is_user_not_on_behalf_of = is_not_zero(user - on_behalf_of);
        if (is_user_not_on_behalf_of == TRUE) {
            DebtTokenBase.decrease_borrow_allowance(on_behalf_of, user, amount);
            tempvar syscall_ptr = syscall_ptr;
            tempvar pedersen_ptr = pedersen_ptr;
            tempvar range_check_ptr = range_check_ptr;
        } else {
            tempvar syscall_ptr = syscall_ptr;
            tempvar pedersen_ptr = pedersen_ptr;
            tempvar range_check_ptr = range_check_ptr;
        }

        let (_, local current_balance, balance_increase) = _calculate_balance_increase(
            on_behalf_of
        );

        let (previous_supply) = total_supply();
        let (current_avg_stable_rate) = StableDebtToken_avg_stable_rate.read();
        let (current_avg_stable_rate_256) = to_uint256(current_avg_stable_rate);
        let (next_supply) = SafeUint256.add(previous_supply, amount);
        IncentivizedERC20.set_total_supply(next_supply);

        let (delegator_state) = IncentivizedERC20.get_user_state(on_behalf_of);
        let current_stable_rate = delegator_state.additional_data;
        let (current_stable_rate_256) = to_uint256(current_stable_rate);

        // Cast | convert values to Ray
        let (amount_in_ray) = WadRayMath.wad_to_ray(amount);
        let (rate_256) = to_uint256(rate);
        let (previous_supply_ray) = WadRayMath.wad_to_ray(previous_supply);
        let (current_balance_ray) = WadRayMath.wad_to_ray(current_balance);
        let (next_supply_ray) = WadRayMath.wad_to_ray(next_supply);

        // Next stable rate calc
        let (cur_rate_mul_balance_ray) = WadRayMath.ray_mul(
            current_avg_stable_rate_256, current_balance_ray
        );
        let (amount_mul_rate_ray) = WadRayMath.ray_mul(amount_in_ray, rate_256);
        let (numerator, add_overflow) = WadRayMath.ray_add(
            cur_rate_mul_balance_ray, amount_mul_rate_ray
        );
        with_attr error_message("mint: Addition overflow") {
            assert add_overflow = FALSE;
        }

        let (current_balance_plus_amt) = SafeUint256.add(current_balance, amount);
        let (denominator) = WadRayMath.wad_to_ray(current_balance_plus_amt);

        let (next_stable_rate_256) = WadRayMath.ray_div(numerator, denominator);
        let (next_rate_felt) = to_felt(next_stable_rate_256);

        // Update user with the updated rate
        IncentivizedERC20.set_user_state(
            on_behalf_of,
            DataTypes.UserState(delegator_state.balance, additional_data=next_rate_felt),
        );

        // Update timestamps
        let (block_timestamp) = get_block_timestamp();
        StableDebtToken_timestamps.write(on_behalf_of, block_timestamp);
        StableDebtToken_total_supply_timestamp.write(block_timestamp);

        // Calculate updated average stable rate
        let (current_rate_mul_prev_supply_ray) = WadRayMath.ray_mul(
            current_avg_stable_rate_256, previous_supply_ray
        );
        let (rate_mul_amount_ray) = WadRayMath.ray_mul(rate_256, amount_in_ray);
        let (numerator, add_overflow) = WadRayMath.ray_add(
            current_rate_mul_prev_supply_ray, rate_mul_amount_ray
        );
        with_attr error_message("mint: Addition overflow") {
            assert add_overflow = FALSE;
        }
        let (current_avg_stable_rate_256) = WadRayMath.ray_div(numerator, next_supply_ray);
        let (current_avg_stable_rate) = to_felt(current_avg_stable_rate_256);
        StableDebtToken_avg_stable_rate.write(current_avg_stable_rate);

        let (amount_to_mint) = SafeUint256.add(amount, balance_increase);
        _mint(on_behalf_of, amount_to_mint, previous_supply);

        Transfer.emit(0, on_behalf_of, amount_to_mint);
        Mint.emit(
            user,
            on_behalf_of,
            amount_to_mint,
            current_balance,
            balance_increase,
            next_stable_rate_256,
            current_avg_stable_rate_256,
            next_supply,
        );

        let (is_current_balance_zero) = uint256_eq(current_balance, Uint256(0, 0));
        return (is_current_balance_zero, next_supply, current_avg_stable_rate);
    }

    // @notice Burns debt of `user`
    // @dev The resulting rate is the weighted average between the rate of the new debt
    // and the rate of the previous debt
    // @dev In some instances, a burn transaction will emit a mint event
    // if the amount to burn is less than the interest the user earned
    // @param address_from The address from which the debt will be burned
    // @param amount The amount of debt tokens getting burned
    // @return The total stable debt
    // @return The average stable borrow rate
    func burn{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        address_from: felt, amount: Uint256
    ) -> (next_supply: Uint256, next_avg_stable_rate: felt) {
        alloc_locals;
        IncentivizedERC20.assert_only_pool();
        let (_, local current_balance, balance_increase) = _calculate_balance_increase(
            address_from
        );
        let (previous_supply) = total_supply();
        let (user_state) = IncentivizedERC20.get_user_state(address_from);
        let user_stable_rate = user_state.additional_data;
        let (user_stable_rate_256) = to_uint256(user_stable_rate);

        let (next_supply, next_avg_stable_rate) = _calc_and_update_next_values(
            previous_supply, amount, user_stable_rate
        );
        let (next_avg_stable_rate_256) = to_uint256(next_avg_stable_rate);
        let (block_timestamp) = get_block_timestamp();
        let (is_amount_eq_balance) = uint256_eq(amount, current_balance);
        if (is_amount_eq_balance == TRUE) {
            IncentivizedERC20.set_user_state(
                address_from, DataTypes.UserState(user_state.balance, additional_data=0)
            );
            StableDebtToken_timestamps.write(address_from, 0);
        } else {
            StableDebtToken_timestamps.write(address_from, block_timestamp);
        }
        StableDebtToken_total_supply_timestamp.write(block_timestamp);

        let (is_amount_lt_increase) = SafeUint256Cmp.lt(amount, balance_increase);
        if (is_amount_lt_increase == TRUE) {
            let (amount_to_mint) = SafeUint256.sub_le(balance_increase, amount);
            _mint(address_from, amount_to_mint, previous_supply);
            Transfer.emit(0, address_from, amount_to_mint);
            Mint.emit(
                address_from,
                address_from,
                amount_to_mint,
                current_balance,
                balance_increase,
                user_stable_rate_256,
                next_avg_stable_rate_256,
                next_supply,
            );
            return (next_supply, next_avg_stable_rate);
        } else {
            let (amount_to_burn) = SafeUint256.sub_le(amount, balance_increase);
            _burn(address_from, amount_to_burn, previous_supply);
            Transfer.emit(address_from, 0, amount_to_burn);
            Burn.emit(
                address_from,
                amount_to_burn,
                current_balance,
                balance_increase,
                next_avg_stable_rate_256,
                next_supply,
            );
            return (next_supply, next_avg_stable_rate);
        }
    }

    // @notice Returns the principal, the total supply, the average stable rate and the timestamp for the last update
    // @return The principal
    // @return The total supply
    // @return The average stable rate
    // @return The timestamp of the last update
    func get_supply_data{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        principal_supply: Uint256,
        total_supply: Uint256,
        avg_stable_rate: felt,
        total_supply_timestamp: felt,
    ) {
        alloc_locals;
        let (avg_rate) = StableDebtToken_avg_stable_rate.read();
        let (cumulated_total_supply) = _calc_total_supply(avg_rate);
        let (total_supply: Uint256) = IncentivizedERC20.total_supply();
        let (total_supply_timestamp) = StableDebtToken_total_supply_timestamp.read();
        return (total_supply, cumulated_total_supply, avg_rate, total_supply_timestamp);
    }

    // @notice Returns the total supply and the average stable rate
    // @return The total supply
    // @return The average rate
    func get_total_supply_and_avg_rate{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }() -> (total_supply: Uint256, avg_rate: felt) {
        alloc_locals;
        let (local avg_rate) = StableDebtToken_avg_stable_rate.read();
        let (total_supply) = IncentivizedERC20.total_supply();
        let (cumulated_total_supply) = _calc_total_supply(avg_rate);
        return (cumulated_total_supply, avg_rate);
    }

    // @notice Returns the total supply
    // @return The total supply
    func total_supply{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        total_supply: Uint256
    ) {
        let (avg_rate) = StableDebtToken_avg_stable_rate.read();
        let (total_supply) = _calc_total_supply(avg_rate);
        return (total_supply,);
    }

    // @notice Returns the timestamp of the last update of the total supply
    // @return The timestamp
    func get_total_supply_last_updated{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }() -> (timestamp: felt) {
        let (timestamp) = StableDebtToken_total_supply_timestamp.read();
        return (timestamp,);
    }
}

// @notice Calculates the total supply
// @param avg_rate The average rate at which the total supply increases
// @return The debt balance of the user since the last burn/mint action
func _calc_total_supply{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    avg_rate: felt
) -> (cumulated_total_supply: Uint256) {
    alloc_locals;
    let (total_supply) = IncentivizedERC20.total_supply();
    let (is_supply_zero) = uint256_eq(total_supply, Uint256(0, 0));
    if (is_supply_zero == TRUE) {
        return (Uint256(0, 0),);
    }
    let (avg_rate_256) = to_uint256(avg_rate);
    let (total_supply_timestamp) = StableDebtToken_total_supply_timestamp.read();
    let (cumulated_interest) = MathUtils.calculate_compounded_interest(
        avg_rate_256, total_supply_timestamp
    );
    let (cumulated_total_supply) = WadRayMath.ray_mul(total_supply, cumulated_interest);
    return (cumulated_total_supply,);
}

// @notice Calculates the increase in balance since the last user interaction
// @param user The address of the user for which the interest is being accumulated
// @return The previous principal balance
// @return The new principal balance
// @return The balance increase
func _calculate_balance_increase{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    user: felt
) -> (
    previous_principal_balance: Uint256, new_principal_balance: Uint256, balance_increase: Uint256
) {
    alloc_locals;
    let (previous_principal_balance) = IncentivizedERC20.balance_of(user);
    let (is_balance_zero) = uint256_eq(previous_principal_balance, Uint256(0, 0));

    if (is_balance_zero == TRUE) {
        return (Uint256(0, 0), Uint256(0, 0), Uint256(0, 0));
    }

    let (new_principal_balance) = StableDebtToken.balance_of(user);
    let (balance_increase) = SafeUint256.sub_le(new_principal_balance, previous_principal_balance);
    return (previous_principal_balance, new_principal_balance, balance_increase);
}

// @notice Mints stable debt tokens to a user
// @param account The account receiving the debt tokens
// @param amount The amount being minted
// @param old_total_supply The total supply before the minting event
func _mint{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    account: felt, amount: Uint256, old_total_supply: Uint256
) {
    let (amount_felt) = to_felt(amount);
    let (user_state) = IncentivizedERC20.get_user_state(account);
    let old_balance = user_state.balance;
    let (old_balance_256) = to_uint256(old_balance);
    let new_balance = amount_felt + old_balance;
    IncentivizedERC20.set_user_state(
        account, DataTypes.UserState(new_balance, user_state.additional_data)
    );

    let (incentives_controller) = IncentivizedERC20.get_incentives_controller();
    let incentives_controller_not_zero = is_not_zero(incentives_controller);

    if (incentives_controller_not_zero == TRUE) {
        IAaveIncentivesController.handle_action(
            contract_address=incentives_controller,
            account=account,
            user_balance=old_balance_256,
            total_supply=old_total_supply,
        );
        return ();
    }

    return ();
}

// @notice Burns stable debt tokens of a user
// @param account The user getting his debt burned
// @param amount The amount being burned
// @param old_total_supply The total supply before the burning event
func _burn{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    account: felt, amount: Uint256, old_total_supply: Uint256
) {
    let (amount_felt) = to_felt(amount);
    let (user_state) = IncentivizedERC20.get_user_state(account);
    let old_balance = user_state.balance;
    let (old_balance_256) = to_uint256(old_balance);
    let new_balance = old_balance - amount_felt;

    IncentivizedERC20.set_user_state(
        account, DataTypes.UserState(new_balance, user_state.additional_data)
    );

    let (incentives_controller) = IncentivizedERC20.get_incentives_controller();
    let incentives_controller_not_zero = is_not_zero(incentives_controller);

    if (incentives_controller_not_zero == TRUE) {
        IAaveIncentivesController.handle_action(
            contract_address=incentives_controller,
            account=account,
            user_balance=old_balance_256,
            total_supply=old_total_supply,
        );
        return ();
    }
    return ();
}

// @notice Calculates the next values for supply and average stable rate and updates the storage
// variables
// Updates the avg_stable_rate and total_supply storage variables
// @param previous_supply The current total supply of the token
// @param amount The amount being burned
// @param user_stable_rate The stable rate of the user
// @returns The new total supply
// @returns The new average stable rate
func _calc_and_update_next_values{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    previous_supply: Uint256, amount: Uint256, user_stable_rate: felt
) -> (next_supply: Uint256, next_avg_stable_rate: felt) {
    alloc_locals;
    let (is_prev_supply_le_amount) = SafeUint256Cmp.le(previous_supply, amount);
    if (is_prev_supply_le_amount == TRUE) {
        StableDebtToken_avg_stable_rate.write(0);
        IncentivizedERC20.set_total_supply(Uint256(0, 0));
        return (Uint256(0, 0), 0);
    }

    let (next_supply) = SafeUint256.sub_le(previous_supply, amount);
    IncentivizedERC20.set_total_supply(next_supply);

    let (avg_stable_rate) = StableDebtToken_avg_stable_rate.read();
    let (avg_stable_rate_256) = to_uint256(avg_stable_rate);
    let (user_stable_rate_256) = to_uint256(user_stable_rate);
    let (prev_supply_ray) = WadRayMath.wad_to_ray(previous_supply);
    let (amount_in_ray) = WadRayMath.wad_to_ray(amount);
    let (next_supply_ray) = WadRayMath.wad_to_ray(next_supply);

    let (first_term) = WadRayMath.ray_mul(avg_stable_rate_256, prev_supply_ray);
    let (second_term) = WadRayMath.ray_mul(user_stable_rate_256, amount_in_ray);

    let (is_first_le_second) = SafeUint256Cmp.le(first_term, second_term);
    if (is_first_le_second == TRUE) {
        StableDebtToken_avg_stable_rate.write(0);
        IncentivizedERC20.set_total_supply(Uint256(0, 0));
        return (Uint256(0, 0), 0);
    }
    let (first_sub_second) = WadRayMath.ray_sub(first_term, second_term);
    let (next_avg_stable_rate_256) = WadRayMath.ray_div(first_sub_second, next_supply_ray);
    let (next_avg_stable_rate) = to_felt(next_avg_stable_rate_256);
    StableDebtToken_avg_stable_rate.write(next_avg_stable_rate);

    return (next_supply, next_avg_stable_rate);
}
