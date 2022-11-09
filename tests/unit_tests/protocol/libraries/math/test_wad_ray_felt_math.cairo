%lang starknet
// Starware imports

from starkware.cairo.common.math import unsigned_div_rem

from contracts.protocol.libraries.helpers.constants import uint256_max
from contracts.protocol.libraries.helpers.constants import MAX_SIGNED_FELT, MAX_UNSIGNED_FELT
from contracts.protocol.libraries.math.felt_math import FeltMath
from contracts.protocol.libraries.math.wad_ray_felt_math import WadRayFelt

// Internal imports

//
// Below are test for expected results when wad/ray inputs are provided to wad/ray functions:
//

//
// ray_mul with different inputs:
// general formula is: power_of_a + power_of_b - 27
// ray_mul(a : Ray, b : Ray) -> 1e27
// ray_mul(a : Wad, b : Wad) -> 1e9
// ray_mul(a : Wad, b : Ray) -> 1e18
// ray_mul(a : Ray, b : Wad) -> 1e18
//
@external
func test_unexpected_results_ray_mul{range_check_ptr}() {
    alloc_locals;
    let wad = WadRayFelt.WAD;
    let ray = WadRayFelt.RAY;
    let _1e9 = 10 ** 9;

    // wad-wad
    let two_wad = 2 * wad;
    let three_wad = 3 * wad;
    let six_1e9 = 6 * _1e9;
    let res = WadRayFelt.ray_mul_unsigned(two_wad, three_wad);
    assert res = six_1e9;

    // wad-ray
    let three_ray = 3 * ray;
    let six_wad = 6 * wad;
    let res = WadRayFelt.ray_mul_unsigned(two_wad, three_ray);
    assert res = six_wad;

    // ray-wad
    let res = WadRayFelt.ray_mul_unsigned(three_ray, two_wad);
    assert res = six_wad;
    let res = WadRayFelt.ray_mul_unsigned(two_wad, three_ray);
    assert res = six_wad;

    return ();
}

//
// wad_mul with non-Wad inputs:
// general formula is: power_of_a + power_of_b - 18
// wad_mul(a : Wad, b : Wad) -> 1e18
// wad_mul(a : Ray, b : Ray) -> 1e36
// wad_mul(a : Wad, b : Ray) -> 1e27
// wad_mul(a : Ray, b : Wad) -> 1e27
//
@external
func test_unexpected_results_wad_mul{range_check_ptr}() {
    alloc_locals;
    let wad = WadRayFelt.WAD;
    let ray = WadRayFelt.RAY;
    let _1e9 = 10 ** 9;

    // wad-wad
    let two_wad = 2 * wad;
    let three_wad = 3 * wad;
    let six_1e9 = 6 * 10 ** 9;
    let _1e36 = 10 ** 36;

    // ray-ray
    let two_ray = 2 * ray;
    let three_ray = 3 * ray;
    let six_1e36 = 6 * _1e36;
    let res = WadRayFelt.wad_mul_unsigned(two_ray, three_ray);
    assert res = six_1e36;

    // ray-wad
    let three_wad = 3 * wad;
    let six_ray = 6 * ray;
    let res = WadRayFelt.wad_mul_unsigned(two_ray, three_wad);
    assert res = six_ray;

    // wad-ray
    let res = WadRayFelt.wad_mul_unsigned(three_wad, two_ray);
    assert res = six_ray;

    return ();
}

// ray_div with various inputs:
// ray_div(a : Ray, b : Ray) -> 1e27
// ray_div(a : Wad, b : Wad) -> 1e27
// ray_div(a : Wad, b : Ray) -> 1e18
// ray_div(a : Ray, b : Wad) -> 1e36
@external
func test_unexpected_results_ray_div{range_check_ptr}() {
    alloc_locals;
    let wad = WadRayFelt.WAD;
    let ray = WadRayFelt.RAY;
    let _1e36 = 10 ** 36;

    // wad-wad
    let six_wad = 6 * wad;
    let three_wad = 3 * wad;
    let two_ray = 2 * ray;
    let res = WadRayFelt.ray_div_unsigned(six_wad, three_wad);
    assert res = two_ray;

    // wad-ray
    let three_ray = 3 * ray;
    let two_wad = 2 * wad;
    let res = WadRayFelt.ray_div_unsigned(six_wad, three_ray);
    assert res = two_wad;

    // ray-wad
    let res = WadRayFelt.ray_div_unsigned(ray, wad);
    assert res = _1e36;

    return ();
}

//
// wad_div with various inputs:
// wad_div(a : Wad, b : Wad) -> 1e18
// wad_div(a : Ray, b : Ray) -> 1e18
// wad_div(a : Wad, b : Ray) -> 1e9
// wad_div(a : Ray, b : Wad) -> 1e27
//
@external
func test_unexpected_results_wad_div{range_check_ptr}() {
    alloc_locals;
    let wad = WadRayFelt.WAD;
    let ray = WadRayFelt.RAY;
    let _1e9 = 10 ** 9;

    // wad-wad
    let two_wad = 2 * wad;
    let three_wad = 3 * wad;

    // ray-ray
    let six_ray = 6 * ray;
    let three_ray = 3 * ray;
    let two_wad = 2 * wad;
    let res = WadRayFelt.wad_div_unsigned(six_ray, three_ray);
    assert res = two_wad;

    // wad-ray
    let six_wad = 6 * wad;
    let two_1e9 = 2 * _1e9;
    let res = WadRayFelt.wad_div_unsigned(six_wad, three_ray);
    assert res = two_1e9;

    // ray-wad
    let three_wad = 3 * wad;
    let two_ray = 2 * ray;
    let res = WadRayFelt.wad_div_unsigned(six_ray, three_wad);
    assert res = two_ray;

    return ();
}

// Normal application tests
// Based on https://github.com/aave/aave-v3-core/blob/master/test-suites/wadraymath.spec.ts
// For verifying the results with the Aave's Solidity WadRayMath library, you may refer to https://goerli.etherscan.io/address/0xCC203741E10e4FD08b8FF4cB7AA44003C0fa2938#readContract

@external
func test_wad_mul{range_check_ptr}() {
    alloc_locals;

    let a = 134534543232342353231234;
    let b = 13265462389132757665657;

    // a = 1.34E23
    // b = 1.32E22
    // wadmul: a*b = 1.78E27
    let res_actual = 1784662923287792467070443765;
    let res = WadRayFelt.wad_mul_unsigned(a, b);
    assert res_actual = res;

    // expect overflow
    let (temp_1, _) = FeltMath.sub_unsigned(MAX_UNSIGNED_FELT, WadRayFelt.HALF_WAD);
    let (temp_2, _) = FeltMath.div_unsigned(temp_1, b);
    let (temp_3, _) = FeltMath.add_unsigned(temp_2, 1);

    %{ expect_revert(error_message="mul_add_unsigned: Overflow") %}
    WadRayFelt.wad_mul_unsigned(temp_3, b);  // expected to revert

    return ();
}

@external
func test_wad_div{range_check_ptr}() {
    alloc_locals;
    let wad = WadRayFelt.WAD;

    let a = 134534543232342353231234;
    let b = 13265462389132757665657;

    // a = 1.34E23
    // b = 1.32E22
    // waddiv: a*b = 1.01E19
    let res_actual = 10141715327055228122;
    let res = WadRayFelt.wad_div_unsigned(a, b);
    assert res_actual = res;

    // expect revert

    let (half_b, _) = unsigned_div_rem(b, 2);
    let (temp_1, _) = FeltMath.sub_unsigned(MAX_UNSIGNED_FELT, half_b);
    let (temp_2, _) = FeltMath.div_unsigned(temp_1, wad);
    let (temp_3, _) = FeltMath.add_unsigned(temp_2, 1);

    %{ expect_revert(error_message="mul_add_unsigned: Overflow") %}
    WadRayFelt.wad_div_unsigned(temp_3, b);  // expected to revert

    return ();
}

@external
func test_wad_div_zero{range_check_ptr}() {
    alloc_locals;

    let a = 134534543232342353231234;

    %{ expect_revert() %}
    WadRayFelt.wad_div_unsigned(a, 0);  // expected to revert

    return ();
}

@external
func test_ray_mul{range_check_ptr}() {
    alloc_locals;
    let a = 134534543232342353231234;
    let b = 13265462389132757665657;

    // a = 1.34E23
    // b = 1.32E22
    // raymul: a*b = 1.78E18
    let res_actual = 1784662923287792467;
    let res = WadRayFelt.ray_mul_unsigned(a, b);
    assert res_actual = res;

    // expect overflow
    let (temp_1, _) = FeltMath.sub_unsigned(MAX_UNSIGNED_FELT, WadRayFelt.HALF_RAY);
    let (temp_2, _) = FeltMath.div_unsigned(temp_1, b);
    let (temp_3, _) = FeltMath.add_unsigned(temp_2, 1);

    %{ expect_revert(error_message="mul_add_unsigned: Overflow") %}
    WadRayFelt.ray_mul_unsigned(temp_3, b);  // expected to revert

    return ();
}

@external
func test_ray_div{range_check_ptr}() {
    alloc_locals;

    let a = 134534543232342353231234;
    let b = 13265462389132757665657;

    // a = 1.34E23
    // b = 1.32E22
    // raydiv: a*b = 1.01E28
    let res_actual = 10141715327055228122033939726;
    let res = WadRayFelt.ray_div_unsigned(a, b);
    assert res_actual = res;

    let (half_b, _) = unsigned_div_rem(b, 2);
    let (temp_1, _) = FeltMath.sub_unsigned(MAX_UNSIGNED_FELT, half_b);
    let (temp_2, _) = FeltMath.div_unsigned(temp_1, WadRayFelt.RAY);
    let (temp_3, _) = FeltMath.add_unsigned(temp_2, 1);

    %{ expect_revert(error_message="mul_add_unsigned: Overflow") %}
    WadRayFelt.ray_div_unsigned(temp_3, b);  // expected to revert

    %{ expect_revert() %}
    WadRayFelt.ray_div_unsigned(a, 0);  // expected to revert

    return ();
}

@external
func test_ray_div_zero{range_check_ptr}() {
    alloc_locals;

    let a = 134534543232342353231234;

    %{ expect_revert() %}
    WadRayFelt.ray_div_unsigned(a, 0);  // expected to revert
    return ();
}

// Conversion tests

@external
func test_ray_to_wad{range_check_ptr}() {
    let res = WadRayFelt.ray_to_wad_unsigned(WadRayFelt.RAY);
    assert res = WadRayFelt.WAD;
    return ();
}

@external
func test_wad_to_ray{range_check_ptr}() {
    let res = WadRayFelt.wad_to_ray_unsigned(WadRayFelt.WAD);
    assert res = WadRayFelt.RAY;
    return ();
}

@external
func test_ray_to_wad_unsigned_no_rounding{range_check_ptr}() {
    alloc_locals;

    let res = WadRayFelt.ray_to_wad_unsigned_no_rounding(WadRayFelt.RAY);
    assert res = WadRayFelt.WAD;

    // check rounding
    let (ray_diminished, _) = FeltMath.sub_unsigned(WadRayFelt.RAY, 1);
    let (wad_diminished, _) = FeltMath.sub_unsigned(WadRayFelt.WAD, 1);
    let res = WadRayFelt.ray_to_wad_unsigned_no_rounding(ray_diminished);
    assert res = wad_diminished;

    return ();
}

// Exceptions tests

@external
func test_exceptions_mul_wad{range_check_ptr}() {
    alloc_locals;
    let wad = WadRayFelt.WAD;
    let ray = WadRayFelt.RAY;

    //
    // WAD
    //

    // multiplication with zero
    let res = WadRayFelt.wad_mul_unsigned(10000, 0);
    assert res = 0;
    let res = WadRayFelt.wad_mul_unsigned(0, 10000);
    assert res = 0;

    // Multiplication with non-wad integers (<<1e18)
    let res = WadRayFelt.wad_mul_unsigned(10000, wad);
    assert res = 10000;
    let res = WadRayFelt.wad_mul_unsigned(wad, 10000);
    assert res = 10000;

    // underflow test
    let res = WadRayFelt.wad_mul_unsigned(1000, 1);
    assert res = 0;
    let res = WadRayFelt.wad_mul_unsigned(1, 10000);
    assert res = 0;

    // overflow test
    %{ expect_revert() %}
    WadRayFelt.wad_mul_unsigned(MAX_UNSIGNED_FELT, MAX_UNSIGNED_FELT);  // expected to revert
    return ();
}

@external
func test_exceptions_mul_ray{range_check_ptr}() {
    alloc_locals;
    let wad = WadRayFelt.WAD;
    let ray = WadRayFelt.RAY;
    //
    // RAY
    //

    // multiplication with zero
    let res = WadRayFelt.ray_mul_unsigned(10000, 0);
    assert res = 0;
    let res = WadRayFelt.ray_mul_unsigned(0, 10000);
    assert res = 0;

    // Multiplication with non-ray integers (<<1e27)
    let res = WadRayFelt.ray_mul_unsigned(10000, ray);
    assert res = 10000;
    let res = WadRayFelt.ray_mul_unsigned(ray, 10000);
    assert res = 10000;

    // underflow test
    let res = WadRayFelt.ray_mul_unsigned(1000, 1);
    assert res = 0;
    let res = WadRayFelt.ray_mul_unsigned(1, 10000);
    assert res = 0;

    // overflow test
    %{ expect_revert() %}
    WadRayFelt.ray_mul_unsigned(MAX_UNSIGNED_FELT, MAX_UNSIGNED_FELT);  // expected to revert

    return ();
}

@external
func test_exceptions_div{range_check_ptr}() {
    alloc_locals;
    let wad = WadRayFelt.WAD;
    let ray = WadRayFelt.RAY;
    let half_wad = WadRayFelt.HALF_WAD;
    let half_ray = WadRayFelt.HALF_RAY;

    //
    // WAD
    //

    // division by 1
    let res = WadRayFelt.wad_div_unsigned(1000, wad);
    assert res = 1000;

    // underflow test
    let res = WadRayFelt.wad_div_unsigned(1, 2 ** 128);
    assert res = 0;

    //
    // RAY
    //

    // division by 1
    let res = WadRayFelt.ray_div_unsigned(1000, ray);
    assert res = 1000;

    // underflow test
    let res = WadRayFelt.ray_div_unsigned(1, 2 ** 128);
    assert res = 0;
    return ();
}

@external
func test_exceptions_div_wad_zero{range_check_ptr}() {
    // division by 0
    %{ expect_revert() %}
    WadRayFelt.wad_div_unsigned(1, 0);  // expect revert
    return ();
}

@external
func test_exceptions_div_ray_zero{range_check_ptr}() {
    // division by 0
    %{ expect_revert() %}
    WadRayFelt.ray_div_unsigned(1, 0);  // expect revert
    return ();
}

@external
func test_exceptions_wad_div_overflow{range_check_ptr}() {
    // overflow test
    %{ expect_revert() %}
    WadRayFelt.wad_div_unsigned(MAX_UNSIGNED_FELT, 1);  // expect revert
    return ();
}
@external
func test_exceptions_ray_div_overflow{range_check_ptr}() {
    // overflow test
    %{ expect_revert() %}
    WadRayFelt.ray_div_unsigned(MAX_UNSIGNED_FELT, 1);  // expect revert
    return ();
}

@external
func test_ray_mul_no_rounding{range_check_ptr}() {
    alloc_locals;
    let ray = WadRayFelt.RAY;
    let high_number = 2 ** 128 * 10000;

    // zero test
    let res = WadRayFelt.ray_mul_unsigned_no_rounding(high_number, 0);
    assert res = 0;
    let res = WadRayFelt.ray_mul_unsigned_no_rounding(0, high_number);
    assert res = 0;

    // 1 test
    let res = WadRayFelt.ray_mul_unsigned_no_rounding(high_number, ray);
    assert res = high_number;
    let res = WadRayFelt.ray_mul_unsigned_no_rounding(10000, ray);
    assert res = 10000;

    // underflow test
    let res = WadRayFelt.ray_mul_unsigned_no_rounding(1000, 1);
    assert res = 0;
    let res = WadRayFelt.ray_mul_unsigned_no_rounding(1, 10000);
    assert res = 0;

    // overflow test
    %{ expect_revert() %}
    WadRayFelt.ray_mul_unsigned_no_rounding(MAX_UNSIGNED_FELT, MAX_UNSIGNED_FELT);  // expected to revert

    return ();
}
