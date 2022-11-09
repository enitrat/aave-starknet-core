from starkware.cairo.common.bool import FALSE, TRUE
from starkware.cairo.common.math import assert_not_zero
from starkware.cairo.common.uint256 import (
    Uint256,
    uint256_add,
    uint256_check,
    uint256_le,
    uint256_mul,
    uint256_sub,
    uint256_unsigned_div_rem,
)

from contracts.protocol.libraries.helpers.constants import UINT128_MAX
from contracts.protocol.libraries.math.safe_uint256_cmp import SafeUint256Cmp

using Wad = Uint256;
using Ray = Uint256;

namespace WadRayMath {
    // WAD = 1 * 10 ^ 18
    const WAD = 10 ** 18;
    const HALF_WAD = WAD / 2;

    // RAY = 1 * 10 ^ 27
    const RAY = 10 ** 27;
    const HALF_RAY = RAY / 2;

    // WAD_RAY_RATIO = 1 * 10 ^ 9
    const WAD_RAY_RATIO = 10 ** 9;
    const HALF_WAD_RAY_RATIO = WAD_RAY_RATIO / 2;

    func ray() -> Ray {
        let res = Uint256(RAY, 0);
        return res;
    }

    func wad() -> Wad {
        let res = Uint256(WAD, 0);
        return res;
    }

    func half_ray() -> Ray {
        let res = Uint256(HALF_RAY, 0);
        return res;
    }

    func half_wad() -> Wad {
        let res = Uint256(HALF_WAD, 0);
        return res;
    }

    func wad_ray_ratio() -> Uint256 {
        let res = Uint256(WAD_RAY_RATIO, 0);
        return res;
    }

    func half_wad_ray_ratio() -> Uint256 {
        let res = Uint256(HALF_WAD_RAY_RATIO, 0);
        return res;
    }

    func uint256_max() -> Uint256 {
        let res = Uint256(UINT128_MAX, UINT128_MAX);
        return res;
    }

    func wad_mul{range_check_ptr}(a: Wad, b: Wad) -> Wad {
        alloc_locals;
        if (a.high + a.low == 0) {
            let res = Uint256(0, 0);
            return res;
        }
        if (b.high + b.low == 0) {
            let res = Uint256(0, 0);
            return res;
        }
        uint256_check(a);
        uint256_check(b);

        let UINT256_MAX = uint256_max();
        let HALF_WAD_UINT = half_wad();
        let WAD_UINT = wad();

        with_attr error_message("WAD multiplication overflow") {
            let (bound) = uint256_sub(UINT256_MAX, HALF_WAD_UINT);
            let (quotient, rem) = uint256_unsigned_div_rem(bound, b);
            assert SafeUint256Cmp.le(a, quotient) = TRUE;
        }

        let (ab, mul_overflow) = uint256_mul(a, b);
        with_attr error_message("wad_mul: Multiplication overflow") {
            assert mul_overflow = Uint256(0, 0);
        }
        let (abHW, add_overflow) = uint256_add(ab, HALF_WAD_UINT);
        with_attr error_message("wad_mul: Addition overflow") {
            assert add_overflow = FALSE;
        }
        let (res, _) = uint256_unsigned_div_rem(abHW, WAD_UINT);
        return res;
    }

    func wad_div{range_check_ptr}(a: Wad, b: Wad) -> Wad {
        alloc_locals;
        with_attr error_message("WAD divide by zero") {
            assert_not_zero(b.high + b.low);
        }
        uint256_check(a);
        uint256_check(b);

        let (halfB, _) = uint256_unsigned_div_rem(b, Uint256(2, 0));

        let UINT256_MAX = uint256_max();
        let WAD_UINT = wad();

        with_attr error_message("WAD div overflow") {
            let (bound) = uint256_sub(UINT256_MAX, halfB);
            let (quo, _) = uint256_unsigned_div_rem(bound, WAD_UINT);
            assert SafeUint256Cmp.le(a, quo) = TRUE;
        }

        let (aWAD, mul_overflow) = uint256_mul(a, WAD_UINT);
        with_attr error_message("wad_div: Multiplication overflow") {
            assert mul_overflow = Uint256(0, 0);
        }
        let (aWADHalfB, add_overflow) = uint256_add(aWAD, halfB);
        with_attr error_message("wad_div: Addition overflow") {
            assert add_overflow = FALSE;
        }
        let (res, _) = uint256_unsigned_div_rem(aWADHalfB, b);
        return res;
    }

    func wad_add{range_check_ptr}(a: Wad, b: Wad) -> (res: Wad, overflow: felt) {
        uint256_check(a);
        uint256_check(b);
        let (sum, overflow) = uint256_add(a, b);
        return (sum, overflow);
    }

    func wad_sub{range_check_ptr}(a: Wad, b: Wad) -> Wad {
        uint256_check(a);
        uint256_check(b);
        let (diff) = uint256_sub(a, b);
        return diff;
    }

    func ray_mul{range_check_ptr}(a: Ray, b: Ray) -> Ray {
        alloc_locals;
        if (a.high + a.low == 0) {
            let res = Uint256(0, 0);
            return res;
        }
        if (b.high + b.low == 0) {
            let res = Uint256(0, 0);
            return res;
        }
        uint256_check(a);
        uint256_check(b);

        let UINT256_MAX = uint256_max();
        let HALF_RAY_UINT = half_ray();
        let RAY_UINT = ray();

        with_attr error_message("RAY div overflow") {
            let (bound) = uint256_sub(UINT256_MAX, HALF_RAY_UINT);
            let (quotient, rem) = uint256_unsigned_div_rem(bound, b);
            assert SafeUint256Cmp.le(a, quotient) = TRUE;
        }

        let (ab, mul_overflow) = uint256_mul(a, b);
        with_attr error_message("ray_mul: Multiplication overflow") {
            assert mul_overflow = Uint256(0, 0);
        }
        let (abHR, add_overflow) = uint256_add(ab, HALF_RAY_UINT);
        with_attr error_message("ray_mul: Addition overflow") {
            assert add_overflow = FALSE;
        }
        let (res, _) = uint256_unsigned_div_rem(abHR, RAY_UINT);
        return res;
    }

    func ray_div{range_check_ptr}(a: Ray, b: Ray) -> Ray {
        alloc_locals;
        with_attr error_message("RAY divide by zero") {
            assert_not_zero(b.high + b.low);
        }
        uint256_check(a);
        uint256_check(b);

        let (halfB, _) = uint256_unsigned_div_rem(b, Uint256(2, 0));

        let UINT256_MAX = uint256_max();
        let RAY_UINT = ray();

        with_attr error_message("RAY multiplication overflow") {
            let (bound) = uint256_sub(UINT256_MAX, halfB);
            let (quo, _) = uint256_unsigned_div_rem(bound, RAY_UINT);
            assert SafeUint256Cmp.le(a, quo) = TRUE;
        }

        let (aRAY, mul_overflow) = uint256_mul(a, RAY_UINT);
        with_attr error_message("ray_div: Multiplication overflow") {
            assert mul_overflow = Uint256(0, 0);
        }
        let (aRAYHalfB, add_overflow) = uint256_add(aRAY, halfB);
        with_attr error_message("ray_div: Addition overflow") {
            assert add_overflow = FALSE;
        }
        let (res, _) = uint256_unsigned_div_rem(aRAYHalfB, b);
        return res;
    }

    func ray_to_wad{range_check_ptr}(a: Ray) -> Wad {
        alloc_locals;
        uint256_check(a);
        let HALF_WAD_RAY_RATIO_UINT = half_wad_ray_ratio();
        let WAD_RAY_RATIO_UINT = wad_ray_ratio();

        let (res, add_overflow) = uint256_add(a, HALF_WAD_RAY_RATIO_UINT);
        with_attr error_message("ray_to_wad: Addition overflow") {
            assert add_overflow = FALSE;
        }
        let (res, _) = uint256_unsigned_div_rem(res, WAD_RAY_RATIO_UINT);
        return res;
    }

    func wad_to_ray{range_check_ptr}(a: Wad) -> Ray {
        alloc_locals;
        uint256_check(a);
        let WAD_RAY_RATIO_UINT = wad_ray_ratio();

        let (res, mul_overflow) = uint256_mul(a, WAD_RAY_RATIO_UINT);
        with_attr error_message("wad_to_ray: Multiplication overflow") {
            assert mul_overflow = Uint256(0, 0);
        }
        return res;
    }

    func ray_mul_no_rounding{range_check_ptr}(a: Ray, b: Ray) -> Ray {
        alloc_locals;
        uint256_check(a);
        uint256_check(b);

        if (a.high + a.low == 0) {
            let res = Uint256(0, 0);
            return res;
        }
        if (b.high + b.low == 0) {
            let res = Uint256(0, 0);
            return res;
        }

        let RAY_UINT = ray();

        let (ab, overflow) = uint256_mul(a, b);
        with_attr error_message("ray_mul_no_rounding overflow") {
            assert overflow.high = FALSE;
            assert overflow.low = FALSE;
        }
        let (res, _) = uint256_unsigned_div_rem(ab, RAY_UINT);
        return res;
    }

    func ray_div_no_rounding{range_check_ptr}(a: Ray, b: Ray) -> Ray {
        alloc_locals;
        with_attr error_message("RAY divide by zero") {
            assert_not_zero(b.high + b.low);
        }
        uint256_check(a);
        uint256_check(b);

        let RAY_UINT = ray();

        let (aRAY, overflow) = uint256_mul(a, RAY_UINT);
        with_attr error_message("ray_div_no_rounding overflow") {
            assert overflow.high = FALSE;
            assert overflow.low = FALSE;
        }
        let (res, _) = uint256_unsigned_div_rem(aRAY, b);
        return res;
    }

    func ray_to_wad_no_rounding{range_check_ptr}(a: Ray) -> Wad {
        uint256_check(a);
        let WAD_RAY_RATIO_UINT = wad_ray_ratio();
        let (res, _) = uint256_unsigned_div_rem(a, WAD_RAY_RATIO_UINT);
        return res;
    }

    func ray_add{range_check_ptr}(a: Ray, b: Ray) -> (res: Ray, overflow: felt) {
        uint256_check(a);
        uint256_check(b);
        let (sum, overflow) = uint256_add(a, b);
        return (sum, overflow);
    }

    func ray_sub{range_check_ptr}(a: Ray, b: Ray) -> Ray {
        uint256_check(a);
        uint256_check(b);
        let (diff) = uint256_sub(a, b);
        return diff;
    }

    func wad_le{range_check_ptr}(a: Wad, b: Wad) -> felt {
        let res = SafeUint256Cmp.le(a, b);
        return res;
    }
}
