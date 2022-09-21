%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256, uint256_eq
from starkware.cairo.common.bool import FALSE, TRUE
from contracts.protocol.libraries.math.safe_uint256_cmp import SafeUint256Cmp
from openzeppelin.security.safemath.library import SafeUint256

const RANGE_CHECK_BOUND = 2 ** 128 - 1;

// @title PercentageMath library
// @author Aave
// @notice Provides functions to perform percentage calculations
// @dev Percentages are defined by default with 2 decimals of precision (100.00). The precision is indicated by PERCENTAGE_FACTOR
// @dev Operations are rounded. If a value is >=.5, will be rounded up, otherwise rounded down.
namespace PercentageMath {
    // Maximum percentage factor (100.00%)
    const PERCENTAGE_FACTOR = 1 * 10 ** 4;  // 1e4

    // Half percentage factor (50.00%)
    const HALF_PERCENTAGE_FACTOR = 5 * 10 ** 3;  // 0.5e4

    // @notice Executes a percentage multiplication
    // @param value The value of which the percentage needs to be calculated
    // @param percentage The percentage of the value to be calculated
    // @return result value percentmul percentage
    func percent_mul{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        value: Uint256, percentage: Uint256
    ) -> (result: Uint256) {
        alloc_locals;
        // to avoid overflow, value <= (type(uint256).max - HALF_PERCENTAGE_FACTOR) / percentage
        let (is_percentage_zero) = uint256_eq(percentage, Uint256(0, 0));
        with_attr error_message("percentage cannot be zero") {
            assert is_percentage_zero = FALSE;
        }

        tempvar max_uint_256 = Uint256(RANGE_CHECK_BOUND, RANGE_CHECK_BOUND);

        let (overflow_numerator) = SafeUint256.sub_le(
            max_uint_256, Uint256(HALF_PERCENTAGE_FACTOR, 0)
        );
        let (overflow_limit, _) = SafeUint256.div_rem(overflow_numerator, percentage);
        let (is_value_not_overflowing) = SafeUint256Cmp.le(value, overflow_limit);
        with_attr error_message("value overflow") {
            assert is_value_not_overflowing = TRUE;
        }

        let (value_mul_percentage) = SafeUint256.mul(value, percentage);

        let (intermediate_res_1) = SafeUint256.add(
            value_mul_percentage, Uint256(HALF_PERCENTAGE_FACTOR, 0)
        );

        let (result, _) = SafeUint256.div_rem(intermediate_res_1, Uint256(PERCENTAGE_FACTOR, 0));

        return (result,);
    }

    // @notice Executes a percentage division
    // @param value The value of which the percentage needs to be calculated
    // @param percentage The percentage of the value to be calculated
    // @return result value percentdiv percentage
    func percent_div{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        value: Uint256, percentage: Uint256
    ) -> (result: Uint256) {
        alloc_locals;
        // to avoid overflow, value <= (type(uint256).max - half_percentage) / PERCENTAGE_FACTOR
        let (is_percentage_zero) = uint256_eq(percentage, Uint256(0, 0));
        with_attr error_message("percentage cannot be zero") {
            assert is_percentage_zero = FALSE;
        }

        let (half_percentage, _) = SafeUint256.div_rem(percentage, Uint256(2, 0));
        tempvar max_uint_256 = Uint256(RANGE_CHECK_BOUND, RANGE_CHECK_BOUND);
        let (overflow_numerator) = SafeUint256.sub_le(max_uint_256, half_percentage);
        let (overflow_limit, _) = SafeUint256.div_rem(
            overflow_numerator, Uint256(PERCENTAGE_FACTOR, 0)
        );
        let (is_value_not_overflowing) = SafeUint256Cmp.le(value, overflow_limit);
        with_attr error_message("value overflow") {
            assert is_value_not_overflowing = TRUE;
        }

        let (value_mul_percentage_factor) = SafeUint256.mul(value, Uint256(PERCENTAGE_FACTOR, 0));
        let (intermediate_res_1) = SafeUint256.add(value_mul_percentage_factor, half_percentage);

        let (result, _) = SafeUint256.div_rem(intermediate_res_1, percentage);

        return (result,);
    }
}
