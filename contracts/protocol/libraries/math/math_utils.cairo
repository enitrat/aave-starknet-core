%lang starknet

from starkware.cairo.common.bool import FALSE, TRUE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256, uint256_eq
from starkware.starknet.common.syscalls import get_block_timestamp

from openzeppelin.security.safemath.library import SafeUint256

from contracts.protocol.libraries.helpers.helpers import uint256_checked_sub_return_zero_when_lt
from contracts.protocol.libraries.math.wad_ray_math import WadRayMath

namespace MathUtils {
    const SECONDS_PER_YEAR = 365 * 24 * 3600;

    // @dev Function to calculate the interest accumulated using a linear interest rate formula
    // @param rate The interest rate, in ray
    // @param last_update_timestamp The timestamp of the last update of the interest
    // @return The interest rate linearly accumulated during the time_delta, in ray
    func calculate_linear_interest{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        rate: Uint256, last_update_timestamp: felt
    ) -> Uint256 {
        alloc_locals;
        let (current_timestamp) = get_block_timestamp();
        let (time_delta) = SafeUint256.sub_le(
            Uint256(current_timestamp, 0), Uint256(last_update_timestamp, 0)
        );
        let (temp_result) = SafeUint256.mul(rate, time_delta);

        let (result, _) = SafeUint256.div_rem(temp_result, Uint256(SECONDS_PER_YEAR, 0));

        let (interest) = SafeUint256.add(Uint256(WadRayMath.RAY, 0), result);

        return interest;
    }

    // @dev Calculates the compounded interest between the timestamp of the last update and the current block timestamp
    // @param rate The interest rate (in ray)
    // @param last_update_timestamp The timestamp from which the interest accumulation needs to be calculated
    // @return The interest rate compounded between last_update_timestamp and current block timestamp
    func calculate_compounded_interest{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }(rate: Uint256, last_update_timestamp: felt) -> Uint256 {
        let (current_timestamp) = get_block_timestamp();
        return _calculate_compounded_interest(rate, last_update_timestamp, current_timestamp);
    }

    // @dev Function to calculate the interest using a compounded interest rate formula
    // To avoid expensive exponentiation, the calculation is performed using a binomial approximation:
    //
    //  (1+x)^n = 1+n*x+[n/2*(n-1)]*x^2+[n/6*(n-1)*(n-2)*x^3...
    //
    // The approximation slightly underpays liquidity providers and undercharges borrowers, with the advantage of great
    // gas cost reductions. The whitepaper contains reference to the approximation and a table showing the margin of
    // error per different time periods
    //
    // @param rate The interest rate, in ray
    // @param last_update_timestamp The timestamp of the last update of the interest
    // @return The interest rate compounded during the time_delta, in ray
    func _calculate_compounded_interest{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }(rate: Uint256, last_update_timestamp: felt, current_timestamp: felt) -> Uint256 {
        alloc_locals;
        let (exp) = SafeUint256.sub_le(
            Uint256(current_timestamp, 0), Uint256(last_update_timestamp, 0)
        );

        let (is_exp_zero) = uint256_eq(exp, Uint256(0, 0));
        if (is_exp_zero == TRUE) {
            let res = Uint256(WadRayMath.RAY, 0);
            return res;
        }

        let (exp_minus_one) = SafeUint256.sub_le(exp, Uint256(1, 0));

        let (exp_minus_two) = uint256_checked_sub_return_zero_when_lt(exp, Uint256(2, 0));

        let rate_square = WadRayMath.ray_mul(rate, rate);

        let (period_square) = SafeUint256.mul(
            Uint256(SECONDS_PER_YEAR, 0), Uint256(SECONDS_PER_YEAR, 0)
        );

        let (base_power_two, _) = SafeUint256.div_rem(rate_square, period_square);

        let base_power_two_multiplied_by_rate = WadRayMath.ray_mul(base_power_two, rate);

        let (base_power_three, _) = SafeUint256.div_rem(
            base_power_two_multiplied_by_rate, Uint256(SECONDS_PER_YEAR, 0)
        );

        let (temp_second_term) = SafeUint256.mul(exp, exp_minus_one);

        let (second_term) = SafeUint256.mul(temp_second_term, base_power_two);

        let (second_term, _) = SafeUint256.div_rem(second_term, Uint256(2, 0));

        let (first_part_third_term) = SafeUint256.mul(exp, exp_minus_one);

        let (second_part_third_term) = SafeUint256.mul(exp_minus_two, base_power_three);

        let (third_term_) = SafeUint256.mul(first_part_third_term, second_part_third_term);

        let (third_term, _) = SafeUint256.div_rem(third_term_, Uint256(6, 0));

        let (rate_mul_exp) = SafeUint256.mul(rate, exp);

        let (rate_mul_exp_div_period, _) = SafeUint256.div_rem(
            rate_mul_exp, Uint256(SECONDS_PER_YEAR, 0)
        );
        let (first_part_rate) = SafeUint256.add(
            Uint256(WadRayMath.RAY, 0), rate_mul_exp_div_period
        );
        let (second_plus_third_term) = SafeUint256.add(second_term, third_term);

        let (compounded_interest) = SafeUint256.add(first_part_rate, second_plus_third_term);

        return compounded_interest;
    }
}
