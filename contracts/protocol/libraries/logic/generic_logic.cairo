%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math_cmp import is_not_zero, is_le
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.math import unsigned_div_rem
from starkware.cairo.common.uint256 import Uint256, uint256_eq

from openzeppelin.token.erc20.IERC20 import IERC20

from contracts.protocol.pool.pool_storage import PoolStorage
from contracts.interfaces.i_price_oracle_getter import IPriceOracleGetter
from contracts.interfaces.i_a_token import IAToken
from contracts.interfaces.i_variable_debt_token import IVariableDebtToken
from contracts.protocol.libraries.helpers.helpers import is_zero
from contracts.protocol.libraries.helpers.constants import MAX_UNSIGNED_FELT
from contracts.protocol.libraries.helpers.bool_cmp import BoolCmp
from contracts.protocol.libraries.logic.e_mode_logic import EModeLogic
from contracts.protocol.libraries.logic.reserve_logic import ReserveLogic
from contracts.protocol.libraries.configuration.user_configuration import UserConfiguration
from contracts.protocol.libraries.configuration.reserve_configuration import ReserveConfiguration
from contracts.protocol.libraries.math.felt_math import FeltMath, to_felt, to_uint256
from contracts.protocol.libraries.math.percentage_math import PercentageMath
from contracts.protocol.libraries.math.wad_ray_math import WadRayMath
from contracts.protocol.libraries.types.data_types import DataTypes

namespace GenericLogic {
    //
    //    @notice Calculates the user data across the reserves.
    //    @dev It includes the total liquidity/collateral/borrow balances in the base currency used by the price feed,
    //    the average Loan To Value, the average Liquidation Ratio, and the Health factor.
    //    The values are average by total collateral accross the reserves. They also are weighted according to the mode and context of borrowing
    //    @param params Additional parameters needed for the calculation
    //    @return The total collateral of the user in the base currency used by the price feed
    //    @return The total debt of the user in the base currency used by the price feed
    //    @return The average ltv of the user
    //    @return The average liquidation threshold of the user
    //    @return The health factor of the user
    //    @return True if the ltv is zero, false otherwise
    func calculate_user_account_data{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }(params: DataTypes.CalculateUserAccountDataParams) -> (
        total_collateral_in_base_currency: felt,
        total_debt_in_base_currency: felt,
        avg_ltv: felt,
        avg_liquidation_threshold: felt,
        health_factor: felt,
        is_ltv_zero: felt,
    ) {
        alloc_locals;
        let (is_params_empty) = UserConfiguration.is_empty(params.user);
        if (is_params_empty == TRUE) {
            return (0, 0, 0, 0, MAX_UNSIGNED_FELT, FALSE);
        }

        // Compute intermediate date : e_mode_ltv, e_mode_liq_th and e_mode_asset_price
        let (e_mode_ltv, e_mode_liq_th, e_mode_asset_price) = _calculate_e_mode_account_data(
            params.user_e_mode_category, params.oracle
        );

        // Compute the sums needed for user parameters :
        let (
            total_collateral_in_base_currency,
            total_debt_in_base_currency,
            sum_of_ltv,
            sum_of_liq_th,
            is_ltv_zero,
        ) = _calculate_sum_of_user_account_data(
            params, e_mode_ltv, e_mode_liq_th, e_mode_asset_price, params.reserves_count
        );

        local avg_ltv;
        local avg_liquidation_threshold;
        local health_factor;

        // Compute average ltv and average liquidation threshold
        if (total_collateral_in_base_currency == 0) {
            avg_ltv = 0;
            avg_liquidation_threshold = 0;
        } else {
            (avg_ltv, _) = unsigned_div_rem(sum_of_ltv, total_collateral_in_base_currency);
            (avg_liquidation_threshold, _) = unsigned_div_rem(sum_of_liq_th, total_collateral_in_base_currency);
        }

        // Compute health Factor
        if (total_debt_in_base_currency == 0) {
            health_factor = MAX_UNSIGNED_FELT;
        } else {
            // cast to uint_256
            let total_collateral_in_base_currency_256 = to_uint256(
                total_collateral_in_base_currency
            );
            let avg_liquidation_threshold_256 = to_uint256(avg_liquidation_threshold);
            let numerator = PercentageMath.percent_mul(
                total_collateral_in_base_currency_256, avg_liquidation_threshold_256
            );
            let quotient = WadRayMath.wad_div(numerator, total_debt_in_base_currency);

            health_factor = to_felt(quotient);
        }

        return (
            total_debt_in_base_currency,
            total_debt_in_base_currency,
            avg_ltv,
            avg_liquidation_threshold,
            health_factor,
            is_ltv_zero,
        );
    }

    // @notice calculates the e_mode data needed in the function
    func _calculate_e_mode_account_data{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }(user_e_mode_category: felt, oracle: felt) -> (
        e_mode_ltv: felt, e_mode_liq_th: felt, e_mode_asset_price: felt
    ) {
        let is_e_mode_category_not_zero = is_not_zero(user_e_mode_category);
        if (is_e_mode_category_not_zero == TRUE) {
            let (e_mode_category) = PoolStorage.e_mode_categories_read(user_e_mode_category);
            let (
                e_mode_ltv, e_mode_liq_th, e_mode_asset_price
            ) = EModeLogic.get_e_mode_configuration(e_mode_category, oracle);
            return (e_mode_ltv, e_mode_liq_th, e_mode_asset_price);
        } else {
            return (0, 0, 0);
        }
    }

    // @notice compute sum collateral, sum debt, weighted sum of liquidationTh, weighted sum of ltv, hasZeroLTV at least one time
    //    @param e_mode_ltv ltv when e_mode is activated
    //    @param e_mode_liq_th liquidity threshold when e_mode is activated
    //    @param e_mode_asset_price asset price when e_mode is activated
    //    @param reserve_index reserve index
    //    @param reserve_count reserve total count
    //    @return The sum of collateral of the user in the base currency used by the price feed
    //    @return The sum of debt of the user in the base currency used by the price feed
    //    @return The sum of  ltv of the user
    //    @return The sum of  liquidation threshold of the user
    //    @return True if the ltv is zero, false otherwise
    func _calculate_sum_of_user_account_data{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }(
        params: DataTypes.CalculateUserAccountDataParams,
        e_mode_ltv: felt,
        e_mode_liq_th: felt,
        e_mode_asset_price: felt,
        reserves_count: felt,
    ) -> (
        sum_of_collateral: felt,
        sum_of_debt: felt,
        sum_of_ltv: felt,
        sum_of_liq_th: felt,
        has_zero_ltv: felt,
    ) {
        return _calculate_sum_of_user_account_data_inner(
            params, e_mode_ltv, e_mode_liq_th, e_mode_asset_price, 0, reserves_count
        );
    }

    func _calculate_sum_of_user_account_data_inner{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }(
        params: DataTypes.CalculateUserAccountDataParams,
        e_mode_ltv: felt,
        e_mode_liq_th: felt,
        e_mode_asset_price: felt,
        reserve_index: felt,
        reserves_count: felt,
    ) -> (
        sum_of_collateral: felt,
        sum_of_debt: felt,
        sum_of_ltv: felt,
        sum_of_liq_th: felt,
        has_zero_ltv: felt,
    ) {
        alloc_locals;

        // End of recursion
        let is_outbound_index = is_le(reserves_count, reserve_index);
        if (is_outbound_index == TRUE) {
            return (0, 0, 0, 0, FALSE);
        }

        let (
            sum_of_collateral, sum_of_debt, sum_of_ltv, sum_of_liq_th, has_zero_ltv
        ) = _calculate_sum_of_user_account_data_inner(
            params, e_mode_ltv, e_mode_liq_th, e_mode_asset_price, reserve_index + 1, reserves_count
        );

        let (
            delta_collateral, delta_debt, delta_ltv, delta_liq_th, delta_has_zero_ltv
        ) = _calculate_reserve_user_account_data(
            params, e_mode_ltv, e_mode_liq_th, e_mode_asset_price, reserve_index
        );

        let has_zero_ltv = BoolCmp.either(has_zero_ltv, delta_has_zero_ltv);

        return (
            sum_of_collateral + delta_collateral,
            sum_of_debt + delta_debt,
            sum_of_ltv + delta_ltv,
            sum_of_liq_th + delta_liq_th,
            has_zero_ltv,
        );
    }

    func _calculate_reserve_user_account_data{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }(
        params: DataTypes.CalculateUserAccountDataParams,
        e_mode_ltv: felt,
        e_mode_liq_th: felt,
        e_mode_asset_price: felt,
        reserve_index: felt,
    ) -> (
        delta_collateral: felt,
        delta_debt: felt,
        delta_ltv: felt,
        delta_liq_th: felt,
        delta_has_zero_ltv: felt,
    ) {
        alloc_locals;
        local delta_collateral;
        local delta_debt;
        local delta_ltv;
        local delta_liq_th;
        local delta_has_zero_ltv;

        // Check if the user is using as collateral or borrowing the reserve at index (reserve_index: felt)
        let (is_using_as_col_or_bor) = UserConfiguration.is_using_as_collateral_or_borrowing(
            params.user, reserve_index
        );
        if (is_using_as_col_or_bor == FALSE) {
            return (0, 0, 0, 0, FALSE);
        }

        // check that the reserve address is not zero
        let (underlying_address) = PoolStorage.reserves_list_read(reserve_index);
        if (underlying_address == 0) {
            return (0, 0, 0, 0, FALSE);
        }

        // read reserve
        let (current_reserve) = PoolStorage.reserves_read(underlying_address);
        // recover ltv, liq_th, decimals,e_mode_asset_category
        let (ltv, liq_th, _, decimals, _, e_mode_asset_category) = ReserveConfiguration.get_params(
            underlying_address
        );

        // computer asset_units
        let (asset_unit, overflow) = FeltMath.pow_unsigned(10, decimals);
        with_attr error_message("overflow generated while computing asset_unit") {
            assert overflow = FALSE;
        }
        // compute asset price
        local asset_price;
        let is_e_mode_asset_price_not_zero = is_not_zero(e_mode_asset_price);
        let (is_user_and_asset_same_e_mode_category) = is_zero(
            params.user_e_mode_category - e_mode_asset_category
        );
        let asset_price_condition = BoolCmp.both(
            is_e_mode_asset_price_not_zero, is_user_and_asset_same_e_mode_category
        );
        if (asset_price_condition == TRUE) {
            asset_price = e_mode_asset_price;
            tempvar syscall_ptr = syscall_ptr;
            tempvar pedersen_ptr = pedersen_ptr;
            tempvar range_check_ptr = range_check_ptr;
        } else {
            let (oracle_asset_price) = IPriceOracleGetter.get_asset_price(
                params.oracle, underlying_address
            );
            asset_price = oracle_asset_price;
            tempvar syscall_ptr = syscall_ptr;
            tempvar pedersen_ptr = pedersen_ptr;
            tempvar range_check_ptr = range_check_ptr;
        }

        // compute deltas
        let is_liq_th_not_zero = is_not_zero(liq_th);
        let (is_using_as_col) = UserConfiguration.is_using_as_collateral(
            params.user, reserve_index
        );
        let user_balance_in_base_currency_condition = BoolCmp.both(
            is_liq_th_not_zero, is_using_as_col
        );
        if (user_balance_in_base_currency_condition == TRUE) {
            let (user_balance_in_base_currency) = _get_user_balance_in_base_currency(
                params.user, current_reserve, asset_price, asset_unit
            );
            delta_collateral = user_balance_in_base_currency;
            let (is_in_e_mode_cat) = EModeLogic.is_in_e_mode_category(
                params.user_e_mode_category, e_mode_asset_category
            );
            let is_ltv_not_zero = is_not_zero(ltv);
            if (is_ltv_not_zero == TRUE) {
                if (is_in_e_mode_cat == TRUE) {
                    let (delta, _) = FeltMath.mul_unsigned(
                        user_balance_in_base_currency, e_mode_ltv
                    );
                    delta_ltv = delta;
                    tempvar range_check_ptr = range_check_ptr;
                } else {
                    let (delta, _) = FeltMath.mul_unsigned(user_balance_in_base_currency, ltv);
                    delta_ltv = delta;
                    tempvar range_check_ptr = range_check_ptr;
                }
                delta_has_zero_ltv = FALSE;
                tempvar range_check_ptr = range_check_ptr;
            } else {
                delta_ltv = 0;
                delta_has_zero_ltv = TRUE;
                tempvar range_check_ptr = range_check_ptr;
            }

            if (is_in_e_mode_cat == TRUE) {
                let (delta, _) = FeltMath.mul_unsigned(
                    user_balance_in_base_currency, e_mode_liq_th
                );
                delta_liq_th = delta;
                tempvar range_check_ptr = range_check_ptr;
            } else {
                let (delta, _) = FeltMath.mul_unsigned(user_balance_in_base_currency, liq_th);
                delta_liq_th = delta;
                tempvar range_check_ptr = range_check_ptr;
            }
            tempvar syscall_ptr = syscall_ptr;
            tempvar pedersen_ptr = pedersen_ptr;
            tempvar range_check_ptr = range_check_ptr;
        } else {
            delta_collateral = 0;
            delta_liq_th = 0;
            delta_ltv = 0;
            delta_has_zero_ltv = FALSE;
            tempvar syscall_ptr = syscall_ptr;
            tempvar pedersen_ptr = pedersen_ptr;
            tempvar range_check_ptr = range_check_ptr;
        }

        // compute delta_sum_of_debt
        let (is_user_bor) = UserConfiguration.is_borrowing(params.user, reserve_index);

        if (is_user_bor == TRUE) {
            let (delta) = _get_user_debt_in_base_currency(
                params.user, current_reserve, asset_price, asset_unit
            );
            delta_debt = delta;
            tempvar syscall_ptr = syscall_ptr;
            tempvar pedersen_ptr = pedersen_ptr;
            tempvar range_check_ptr = range_check_ptr;
        } else {
            delta_debt = 0;
            tempvar syscall_ptr = syscall_ptr;
            tempvar pedersen_ptr = pedersen_ptr;
            tempvar range_check_ptr = range_check_ptr;
        }

        return (delta_collateral, delta_debt, delta_ltv, delta_liq_th, delta_has_zero_ltv,);
    }

    func _get_user_debt_in_base_currency{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }(user: felt, current_reserve: DataTypes.ReserveData, asset_price: felt, asset_unit: felt) -> (
        user_debt_in_base_currency: felt
    ) {
        alloc_locals;
        local user_total_variable_debt;
        let (user_scaled_balanced_variable_debt_u256) = IVariableDebtToken.scaled_balance_of(
            current_reserve.variable_debt_token_address, user
        );

        let (is_user_debt_zero) = uint256_eq(
            user_scaled_balanced_variable_debt_u256, Uint256(0, 0)
        );
        if (is_user_debt_zero == FALSE) {
            let (normalized_debt) = ReserveLogic.get_normalized_debt(
                current_reserve.variable_debt_token_address
            );
            let normalized_debt_256 = to_uint256(normalized_debt);
            let mul_256 = WadRayMath.ray_mul(
                user_scaled_balanced_variable_debt_u256, normalized_debt_256
            );
            let mul_felt = to_felt(mul_256);
            user_total_variable_debt = mul_felt;
            tempvar syscall_ptr = syscall_ptr;
            tempvar pedersen_ptr = pedersen_ptr;
            tempvar range_check_ptr = range_check_ptr;
        } else {
            user_total_variable_debt = 0;
            tempvar syscall_ptr = syscall_ptr;
            tempvar pedersen_ptr = pedersen_ptr;
            tempvar range_check_ptr = range_check_ptr;
        }
        tempvar pedersen_ptr = pedersen_ptr;

        let (user_total_stable_debt_256) = IERC20.balanceOf(
            current_reserve.stable_debt_token_address, user
        );

        let user_total_stable_debt = to_felt(user_total_stable_debt_256);

        let (user_total_debt_base, overflow) = FeltMath.add_unsigned(
            user_total_variable_debt, user_total_stable_debt
        );
        with_attr error_message("overflow generated while summing variable and stable debts") {
            assert overflow = FALSE;
        }

        let (weighted_user_total_debt_base, overflow) = FeltMath.mul_unsigned(
            user_total_debt_base, asset_price
        );
        with_attr error_message("overflow in multiplication between total debt and asset price") {
            assert overflow = FALSE;
        }

        let (user_total_debt, overflow) = unsigned_div_rem(
            weighted_user_total_debt_base, asset_unit
        );
        with_attr error_message("overflow in division of  total debt by asset_unit") {
            assert overflow = FALSE;
        }

        return (user_total_debt,);
    }

    func _get_user_balance_in_base_currency{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }(user: felt, current_reserve: DataTypes.ReserveData, asset_price: felt, asset_unit: felt) -> (
        user_balance_in_base_currency: felt
    ) {
        alloc_locals;
        // uint256
        let (normalized_income) = ReserveLogic.get_normalized_income(
            current_reserve.a_token_address
        );
        let normalized_income_256 = to_uint256(normalized_income);
        let (scaled_balance_256) = IAToken.scaled_balance_of(current_reserve.a_token_address, user);
        let normalized_balance_256 = WadRayMath.ray_mul(scaled_balance_256, normalized_income_256);
        let normalized_balance = to_felt(normalized_balance_256);

        // felt
        let (balance, _) = FeltMath.mul_unsigned(normalized_balance, asset_price);
        let (user_balance_in_base_currency, _) = unsigned_div_rem(balance, asset_unit);
        return (user_balance_in_base_currency,);
    }
}
