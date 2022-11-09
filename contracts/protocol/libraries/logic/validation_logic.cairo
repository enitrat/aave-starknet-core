%lang starknet

from starkware.cairo.common.bool import FALSE, TRUE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_not_zero
from starkware.cairo.common.math_cmp import is_not_zero
from starkware.cairo.common.uint256 import Uint256, uint256_check, uint256_eq, uint256_le

from contracts.interfaces.i_a_token import IAToken
from contracts.interfaces.i_stable_debt_token import IStableDebtToken
from contracts.interfaces.i_variable_debt_token import IVariableDebtToken
from contracts.protocol.libraries.configuration.reserve_configuration import ReserveConfiguration
from contracts.protocol.libraries.helpers.bool_cmp import BoolCmp
from contracts.protocol.libraries.helpers.errors import Errors
from contracts.protocol.libraries.helpers.helpers import is_zero
from contracts.protocol.libraries.types.data_types import DataTypes
from contracts.protocol.pool.pool_storage import PoolStorage

namespace ValidationLogic {
    // @notice Validates a supply action.
    // @param reserve The data of the reserve
    // @param amount The amount to be supplied
    func validate_supply{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        reserve: DataTypes.ReserveData, amount: Uint256
    ) {
        uint256_check(amount);
        let error_code = Errors.INVALID_AMOUNT;
        with_attr error_message("{error_code}") {
            let (is_zero) = uint256_eq(amount, Uint256(0, 0));
            assert is_zero = FALSE;
        }

        let (asset) = IAToken.UNDERLYING_ASSET_ADDRESS(reserve.a_token_address);
        let (is_active, is_frozen, _, _, is_paused) = ReserveConfiguration.get_flags(asset);

        let error_code = Errors.RESERVE_INACTIVE;
        with_attr error_message("{error_code}") {
            assert is_active = TRUE;
        }
        let error_code = Errors.RESERVE_PAUSED;
        with_attr error_message("{error_code}") {
            assert is_paused = FALSE;
        }
        let error_code = Errors.RESERVE_FROZEN;
        with_attr error_message("{error_code}") {
            assert is_frozen = FALSE;
        }

        let (supply_cap) = ReserveConfiguration.get_supply_cap(reserve.a_token_address);

        // let (scaled_total_supply) = IAToken.scaled_total_supply(reserve.a_token_address)
        // let (reserve_cache)=ReserveConfiguration.get_cache(reserve.a_token_address)
        // let supply_mul_liq_index=ray_mul(Ray(scaled_total_supply), Ray(reserve_cache.next_liquidity_index))

        return ();
    }

    // @notice Validates a withdraw action.
    // @param reserve the data of the reserve
    // @param amount The amount to be withdrawn
    // @param user_balance The balance of the user
    func validate_withdraw{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        reserve: DataTypes.ReserveData, amount: Uint256, user_balance: Uint256
    ) {
        alloc_locals;
        uint256_check(amount);

        let error_code = Errors.INVALID_AMOUNT;
        with_attr error_message("{error_code}") {
            let (is_zero) = uint256_eq(amount, Uint256(0, 0));
            assert is_zero = FALSE;
        }

        // Revert if withdrawing too much. Verify that amount<=balance
        let error_code = Errors.NOT_ENOUGH_AVAILABLE_USER_BALANCE;
        with_attr error_message("{error_code}") {
            let (is_le: felt) = uint256_le(amount, user_balance);
            assert is_le = TRUE;
        }

        let (asset) = IAToken.UNDERLYING_ASSET_ADDRESS(reserve.a_token_address);
        let (is_active, _, _, _, is_paused) = ReserveConfiguration.get_flags(asset);

        let error_code = Errors.RESERVE_INACTIVE;
        with_attr error_message("{error_code}") {
            assert is_active = TRUE;
        }
        let error_code = Errors.RESERVE_PAUSED;
        with_attr error_message("{error_code}") {
            assert is_paused = FALSE;
        }
        return ();
    }

    // @notice Validates a drop reserve action.
    // @param reserve The reserve object
    // @param asset The address of the reserve's underlying asset
    func validate_drop_reserve{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        reserve: DataTypes.ReserveData, asset: felt
    ) {
        let error_code = Errors.ZERO_ADDRESS_NOT_VALID;
        with_attr error_message("{error_code}") {
            assert_not_zero(asset);
        }

        let error_code = Errors.ASSET_NOT_LISTED;
        with_attr error_message("{error_code}") {
            let is_id_not_zero = is_not_zero(reserve.id);
            let (reserve_list_first) = PoolStorage.reserves_list_read(0);
            let (is_first_asset) = is_zero(reserve_list_first - asset);
            let asset_listed = BoolCmp.either(is_id_not_zero, is_first_asset);
            assert asset_listed = TRUE;
        }

        let (stable_debt_supply) = IStableDebtToken.total_supply(
            contract_address=reserve.stable_debt_token_address
        );
        let error_code = Errors.STABLE_DEBT_NOT_ZERO;
        with_attr error_message("{error_code}") {
            assert stable_debt_supply = Uint256(0, 0);
        }

        let (variable_debt_supply) = IVariableDebtToken.total_supply(
            contract_address=reserve.variable_debt_token_address
        );
        let error_code = Errors.VARIABLE_DEBT_SUPPLY_NOT_ZERO;
        with_attr error_message("{error_code}") {
            assert variable_debt_supply = Uint256(0, 0);
        }

        let (a_token_supply) = IAToken.totalSupply(contract_address=reserve.a_token_address);
        let error_code = Errors.ATOKEN_SUPPLY_NOT_ZERO;
        with_attr error_message("{error_code}") {
            assert a_token_supply = Uint256(0, 0);
        }
        return ();
    }

    // @notice Validates a flashloan action.
    // @param reserves_data The state of all the reserves
    // @param assets The assets being flash-borrowed
    // @param amounts The amounts for each asset being borrowed

    func validate_flashloan{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        reserves_data: DataTypes.ReserveData,
        assets_len: felt,
        assets: felt*,
        amounts_len: felt,
        amounts: felt*,
    ) {
        // TO DO
    }
}
