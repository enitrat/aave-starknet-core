from starkware.cairo.common.bool import FALSE, TRUE
from starkware.cairo.common.math import assert_le, assert_le_felt, assert_not_equal

from contracts.protocol.libraries.helpers.constants import MAX_UNSIGNED_FELT
from contracts.protocol.libraries.math.felt_math import FeltMath
from contracts.protocol.libraries.math.felt_math import to_felt
from contracts.protocol.libraries.math.safe_felt_math import SafeFeltMath

using Wad = felt;
using Ray = felt;

namespace WadRayFelt {
    // WAD = 1 * 10 ^ 18
    const WAD = 10 ** 18;
    const HALF_WAD = WAD / 2;

    // RAY = 1 * 10 ^ 27
    const RAY = 10 ** 27;
    const HALF_RAY = RAY / 2;

    // WAD_RAY_RATIO = 1 * 10 ^ 9
    const WAD_RAY_RATIO = 10 ** 9;
    const HALF_WAD_RAY_RATIO = WAD_RAY_RATIO / 2;

    // @notice multiplies two unsigned wad felts
    // @param a unsigned wad felt
    // @param b unsigned wad felt
    // @returns a multiplied by b, unsigned wad felt
    func wad_mul_unsigned{range_check_ptr}(a: Wad, b: Wad) -> Wad {
        alloc_locals;
        if (a == 0) {
            return 0;
        }
        if (b == 0) {
            return 0;
        }
        let rounding = SafeFeltMath.mul_add_unsigned(a, b, HALF_WAD);
        let (scaled_prod, _) = FeltMath.div_unsigned(rounding, WAD);
        return scaled_prod;
    }

    // @notice multiplies two unsigned wad felts without rounding the result to the upper number
    // @param a unsigned wad felt
    // @param b unsigned wad felt
    // @returns a multiplied by b, unsigned wad felt
    func wad_mul_unsigned_no_rounding{range_check_ptr}(a: Wad, b: Wad) -> Wad {
        alloc_locals;
        if (a == 0) {
            return 0;
        }
        if (b == 0) {
            return 0;
        }
        let prod = SafeFeltMath.mul_unsigned(a, b);
        let (scaled_prod, _) = FeltMath.div_unsigned(prod, WAD);
        return scaled_prod;
    }

    // @notice divides two unsigned wad felts
    // @param a unsigned wad felt
    // @param b unsigned wad felt
    // @returns a divided by b, unsigned wad felt
    func wad_div_unsigned{range_check_ptr}(a: Wad, b: Wad) -> Wad {
        alloc_locals;
        assert_not_equal(b, 0);

        let (half_b, _) = FeltMath.div_unsigned(b, 2);
        let rounding = SafeFeltMath.mul_add_unsigned(a, WAD, half_b);
        let (q, _) = FeltMath.div_unsigned(rounding, b);
        return q;
    }

    // @notice divides two unsigned wad felts without rounding to the upper number
    // @param a unsigned wad felt
    // @param b unsigned wad felt
    // @returns a divided by b, unsigned wad felt
    func wad_div_unsigned_no_rounding{range_check_ptr}(a: Wad, b: Wad) -> Wad {
        alloc_locals;
        assert_not_equal(b, 0);

        let prod = SafeFeltMath.mul_unsigned(a, WAD);
        let (q, _) = FeltMath.div_unsigned(prod, b);
        return q;
    }

    // @notice multiplies two unsigned ray felts
    // @param a unsigned ray felt
    // @param b unsigned ray felt
    // @returns a*b, unsigned ray felt
    func ray_mul_unsigned{range_check_ptr}(a: Ray, b: Ray) -> Ray {
        alloc_locals;
        if (a == 0) {
            return 0;
        }
        if (b == 0) {
            return 0;
        }
        let rounding = SafeFeltMath.mul_add_unsigned(a, b, HALF_RAY);
        let (scaled_prod, _) = FeltMath.div_unsigned(rounding, RAY);
        return scaled_prod;
    }

    // @notice multiplies two unsigned ray felts without rounding the result to the upper number
    // @param a unsigned ray felt
    // @param b unsigned ray felt
    // @returns a*b, unsigned ray felt
    func ray_mul_unsigned_no_rounding{range_check_ptr}(a: Ray, b: Ray) -> Ray {
        alloc_locals;
        if (a == 0) {
            return 0;
        }
        if (b == 0) {
            return 0;
        }
        let prod = SafeFeltMath.mul_unsigned(a, b);
        let (scaled_prod, _) = FeltMath.div_unsigned(prod, RAY);
        return scaled_prod;
    }

    // @notice divides two unsigned ray felts
    // @param a unsigned ray felt
    // @param b unsigned ray felt
    // @returns a/b, unsigned ray felt
    func ray_div_unsigned{range_check_ptr}(a: Ray, b: Ray) -> Ray {
        alloc_locals;
        assert_not_equal(b, 0);

        let (half_b, _) = FeltMath.div_unsigned(b, 2);
        let rounding = SafeFeltMath.mul_add_unsigned(a, RAY, half_b);
        let (q, _) = FeltMath.div_unsigned(rounding, b);
        return q;
    }

    // @notice divides two unsigned ray felts
    // @param a unsigned ray felt
    // @param b unsigned ray felt
    // @returns a/b, unsigned ray felt
    func ray_div_unsigned_no_rounding{range_check_ptr}(a: Ray, b: Ray) -> Ray {
        alloc_locals;
        assert_not_equal(b, 0);

        let prod = SafeFeltMath.mul_unsigned(a, RAY);
        let (q, _) = FeltMath.div_unsigned(prod, b);
        return q;
    }

    //
    // Conversions
    //

    // @notice converts an unsigned felt to a wad
    // @param n felt
    // @returns unsigned wad felt
    func felt_to_wad_unsigned{range_check_ptr}(n: felt) -> Wad {
        return SafeFeltMath.mul_unsigned(n, WAD);
    }

    // @notice converts a wad to an unsigned felt
    // @dev Truncates fractional component
    // @param n wad felt
    // @returns unsigned felt
    func wad_to_felt_unsigned_no_rounding{range_check_ptr}(n: Wad) -> felt {
        let (res, _) = FeltMath.div_unsigned(n, WAD);
        return res;
    }

    // @notice converts a wad to an unsigned felt
    // @dev Rounds up to the upper number
    // @param n wad number
    // @returns unsigned felt
    func wad_to_felt_unsigned{range_check_ptr}(n: Wad) -> felt {
        let n_rounded = SafeFeltMath.add_unsigned(n, HALF_WAD);
        let (res, _) = FeltMath.div_unsigned(n_rounded, WAD);
        return res;
    }

    // @notice converts a wad to an unsigned ray
    // @param n unsigned wad felt
    // @returns unsigned ray
    func wad_to_ray_unsigned{range_check_ptr}(n: Wad) -> Ray {
        return SafeFeltMath.mul_unsigned(n, WAD_RAY_RATIO);
    }

    // @notice converts a ray to an unsigned felt
    // @dev Truncates the fractional component
    // @param n unsigned ray
    // @returns unsigned felt
    func ray_to_felt_unsigned_no_rounding{range_check_ptr}(n: Ray) -> felt {
        let (res, _) = FeltMath.div_unsigned(n, RAY);
        return res;
    }

    // @notice converts an unsigned ray to an unsigned felt without rounding to the upper number
    // @dev Truncates a ray to return a felt
    // @param n unsigned ray felt
    // @returns unsigned felt
    func ray_to_felt_unsigned{range_check_ptr}(n: Ray) -> felt {
        let n_rounded = SafeFeltMath.add_unsigned(n, HALF_RAY);
        let (res, _) = FeltMath.div_unsigned(n_rounded, RAY);
        return res;
    }

    // @notice converts an unsigned ray to an unsigned wad without rounding to the upper number
    // @dev Truncates the fractional component
    // @param n unsigned ray felt
    // @returns unsigned wad
    func ray_to_wad_unsigned_no_rounding{range_check_ptr}(n: Ray) -> Wad {
        let (wad, _) = FeltMath.div_unsigned(n, WAD_RAY_RATIO);
        return wad;
    }

    // @notice converts a ray to an unsigned wad
    // @dev Rounds up to the upper number
    // @param n unsigned ray
    // @returns unsigned wad
    func ray_to_wad_unsigned{range_check_ptr}(a: Ray) -> Wad {
        alloc_locals;

        let rounding = SafeFeltMath.add_unsigned(a, HALF_WAD_RAY_RATIO);
        let (res, _) = FeltMath.div_unsigned(rounding, WAD_RAY_RATIO);
        return res;
    }
}
