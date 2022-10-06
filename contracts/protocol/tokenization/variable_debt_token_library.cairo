%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256, uint256_eq
from starkware.cairo.common.bool import TRUE, FALSE

from contracts.protocol.libraries.aave_upgradeability.versioned_initializable_library import (
    VersionedInitializable,
)
from contracts.protocol.tokenization.base.incentivized_erc20_library import IncentivizedERC20
from contracts.protocol.tokenization.base.debt_token_base_library import DebtTokenBase
from contracts.protocol.tokenization.base.scaled_balance_token_library import ScaledBalanceToken
from contracts.protocol.libraries.helpers.helpers import is_zero
from contracts.protocol.libraries.math.wad_ray_math import WadRayMath
from contracts.protocol.libraries.math.felt_math import to_uint256
from contracts.interfaces.i_pool import IPool

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

const REVISION = 1;

namespace VariableDebtToken {
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
        IncentivizedERC20._set_incentives_controller(incentives_controller);

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

    func balance_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        user: felt
    ) -> (balance: Uint256) {
        alloc_locals;
        let (scaled_balance) = IncentivizedERC20.balance_of(user);
        let (is_balance_null) = uint256_eq(scaled_balance, Uint256(0, 0));
        if (is_balance_null == TRUE) {
            return (Uint256(0, 0),);
        }
        let (pool) = IncentivizedERC20.get_pool();
        let (underlying) = DebtTokenBase.get_underlying_asset();
        let (normalized_variable_debt) = IPool.get_reserve_normalized_variable_debt(
            pool, underlying
        );
        let (normalized_variable_debt_256) = to_uint256(normalized_variable_debt);
        let (balance) = WadRayMath.ray_mul(scaled_balance, normalized_variable_debt_256);
        return (balance,);
    }

    func mint{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        user: felt, on_behalf_of: felt, amount: Uint256, index: felt
    ) -> (is_scaled_balance_null: felt, total_supply: Uint256) {
        IncentivizedERC20.assert_only_pool();
        let (is_user_on_behalf_of) = is_zero(user - on_behalf_of);
        if (is_user_on_behalf_of == FALSE) {
            DebtTokenBase.decrease_borrow_allowance(on_behalf_of, user, amount);
            tempvar syscall_ptr = syscall_ptr;
            tempvar pedersen_ptr = pedersen_ptr;
            tempvar range_check_ptr = range_check_ptr;
        } else {
            tempvar syscall_ptr = syscall_ptr;
            tempvar pedersen_ptr = pedersen_ptr;
            tempvar range_check_ptr = range_check_ptr;
        }
        let (is_scaled_balance_null) = ScaledBalanceToken.mint_scaled(
            user, on_behalf_of, amount, index
        );
        let (scaled_total_supply) = IncentivizedERC20.total_supply();
        return (is_scaled_balance_null, scaled_total_supply);
    }

    func burn{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        address_from: felt, amount: Uint256, index: felt
    ) -> (total_supply: Uint256) {
        IncentivizedERC20.assert_only_pool();
        ScaledBalanceToken.burn_scaled(address_from, 0, amount, index);
        let (scaled_total_supply) = IncentivizedERC20.total_supply();
        return (scaled_total_supply,);
    }

    func total_supply{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        total_supply: Uint256
    ) {
        alloc_locals;
        let (pool) = IncentivizedERC20.get_pool();
        let (raw_supply) = IncentivizedERC20.total_supply();
        let (underlying) = DebtTokenBase.get_underlying_asset();
        let (normalized_variable_debt) = IPool.get_reserve_normalized_variable_debt(
            pool, underlying
        );
        let (normalized_variable_debt_256) = to_uint256(normalized_variable_debt);
        let (scaled_supply) = WadRayMath.ray_mul(raw_supply, normalized_variable_debt_256);
        return (scaled_supply,);
    }
}
