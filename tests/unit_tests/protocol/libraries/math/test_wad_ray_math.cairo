%lang starknet
// Starware imports
from starkware.cairo.common.uint256 import (
    Uint256,
    uint256_sub,
    uint256_mul,
    uint256_unsigned_div_rem,
    uint256_add,
)
// Internal imports
from contracts.protocol.libraries.math.wad_ray_math import WadRayMath
from contracts.protocol.libraries.helpers.constants import uint256_max

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
    let wad_ = WadRayMath.wad();
    let ray_ = WadRayMath.ray();
    let _1e9 = Uint256(10 ** 9, 0);

    // wad-wad
    let (two_wad_, _) = uint256_mul(Uint256(2, 0), wad_);
    let (three_wad_, _) = uint256_mul(Uint256(3, 0), wad_);
    let (six_1e9, _) = uint256_mul(Uint256(6, 0), _1e9);
    let res = WadRayMath.ray_mul(two_wad_, three_wad_);
    assert res = six_1e9;

    // wad-ray
    let (three_ray_, _) = uint256_mul(Uint256(3, 0), ray_);
    let (six_wad_, _) = uint256_mul(Uint256(6, 0), wad_);
    let res = WadRayMath.ray_mul(two_wad_, three_ray_);
    assert res = six_wad_;

    // ray-wad
    let res = WadRayMath.ray_mul(three_ray_, two_wad_);
    assert res = six_wad_;

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
    let wad_ = WadRayMath.wad();
    let ray_ = WadRayMath.ray();
    let _1e36 = Uint256(10 ** 36, 0);

    // ray-ray
    let (two_ray_, _) = uint256_mul(Uint256(2, 0), ray_);
    let (three_ray_, _) = uint256_mul(Uint256(3, 0), ray_);
    let (six_1e36, _) = uint256_mul(Uint256(6, 0), _1e36);
    let res = WadRayMath.wad_mul(two_ray_, three_ray_);
    assert res = six_1e36;

    // ray-wad
    let (three_wad_, _) = uint256_mul(Uint256(3, 0), wad_);
    let (six_ray_, _) = uint256_mul(Uint256(6, 0), ray_);
    let res = WadRayMath.wad_mul(two_ray_, three_wad_);
    assert res = six_ray_;

    // wad-ray
    let res = WadRayMath.wad_mul(three_wad_, two_ray_);
    assert res = six_ray_;

    return ();
}

//
// ray_div with various inputs:
// ray_div(a : Ray, b : Ray) -> 1e27
// ray_div(a : Wad, b : Wad) -> 1e27
// ray_div(a : Wad, b : Ray) -> 1e18
// ray_div(a : Ray, b : Wad) -> 1e36
//
@external
func test_unexpected_results_ray_div{range_check_ptr}() {
    alloc_locals;
    let wad_ = WadRayMath.wad();
    let ray_ = WadRayMath.ray();
    let _1e36 = Uint256(10 ** 36, 0);

    // wad-wad
    let (six_wad_, _) = uint256_mul(Uint256(6, 0), wad_);
    let (three_wad_, _) = uint256_mul(Uint256(3, 0), wad_);
    let (two_ray_, _) = uint256_mul(Uint256(2, 0), ray_);
    let res = WadRayMath.ray_div(six_wad_, three_wad_);
    assert res = two_ray_;

    // wad-ray
    let (three_ray_, _) = uint256_mul(Uint256(3, 0), ray_);
    let (two_wad_, _) = uint256_mul(Uint256(2, 0), wad_);
    let res = WadRayMath.ray_div(six_wad_, three_ray_);
    assert res = two_wad_;

    // ray-wad
    let res = WadRayMath.ray_div(six_wad_, three_ray_);
    assert res = two_wad_;

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
    let wad_ = WadRayMath.wad();
    let ray_ = WadRayMath.ray();
    let _1e9 = Uint256(10 ** 9, 0);

    // ray-ray
    let (six_ray_, _) = uint256_mul(Uint256(6, 0), ray_);
    let (three_ray_, _) = uint256_mul(Uint256(3, 0), ray_);
    let (two_wad_, _) = uint256_mul(Uint256(2, 0), wad_);
    let res = WadRayMath.wad_div(six_ray_, three_ray_);
    assert res = two_wad_;

    // wad-ray
    let (six_wad_, _) = uint256_mul(Uint256(6, 0), wad_);
    let (two_1e9, _) = uint256_mul(Uint256(2, 0), _1e9);
    let res = WadRayMath.wad_div(six_wad_, three_ray_);
    assert res = two_1e9;

    // ray-wad
    let (three_wad_, _) = uint256_mul(Uint256(3, 0), wad_);
    let (two_ray_, _) = uint256_mul(Uint256(2, 0), ray_);
    let res = WadRayMath.wad_div(six_ray_, three_wad_);
    assert res = two_ray_;

    return ();
}

// Normal application tests
// Based on https://github.com/aave/aave-v3-core/blob/master/test-suites/wadraymath.spec.ts
// For verifying the results with the Aave's Solidity WadRayMath library, you may refer to https://goerli.etherscan.io/address/0xCC203741E10e4FD08b8FF4cB7AA44003C0fa2938#readContract

@external
func test_wadMul{range_check_ptr}() {
    alloc_locals;
    let uint256_max_ = uint256_max();
    let half_wad_ = WadRayMath.half_wad();

    let a = Uint256(134534543232342353231234, 0);
    let b = Uint256(13265462389132757665657, 0);

    // a = 1.34E23
    // b = 1.32E22
    // wadmul: a*b = 1.78E27
    let res_actual = Uint256(1784662923287792467070443765, 0);
    let res = WadRayMath.wad_mul(a, b);
    assert res_actual = res;

    // expect overflow
    let (temp_1) = uint256_sub(uint256_max_, half_wad_);
    let (temp_2, _) = uint256_unsigned_div_rem(temp_1, b);
    let (temp_3, _) = uint256_add(temp_2, Uint256(1, 0));

    %{ expect_revert() %}
    WadRayMath.wad_mul(temp_3, b);  // expected to revert

    return ();
}

@external
func test_wadDiv{range_check_ptr}() {
    alloc_locals;
    let uint256_max_ = uint256_max();
    let wad_ = WadRayMath.wad();

    let a = Uint256(134534543232342353231234, 0);
    let b = Uint256(13265462389132757665657, 0);

    // a = 1.34E23
    // b = 1.32E22
    // waddiv: a*b = 1.01E19
    let res_actual = Uint256(10141715327055228122, 0);
    let res = WadRayMath.wad_div(a, b);
    assert res_actual = res;

    // expect revert

    let (half_b, _) = uint256_unsigned_div_rem(b, Uint256(2, 0));
    let (temp_1) = uint256_sub(uint256_max_, half_b);
    let (temp_2, _) = uint256_unsigned_div_rem(temp_1, wad_);
    let (temp_3, _) = uint256_add(temp_2, Uint256(1, 0));

    %{ expect_revert() %}
    WadRayMath.wad_div(temp_3, b);  // expected to revert

    %{ expect_revert() %}
    WadRayMath.wad_div(a, Uint256(0, 0));  // expected to revert

    return ();
}

@external
func test_rayMul{range_check_ptr}() {
    alloc_locals;
    let uint256_max_ = uint256_max();
    let half_ray_ = WadRayMath.half_ray();

    let a = Uint256(134534543232342353231234, 0);
    let b = Uint256(13265462389132757665657, 0);

    // a = 1.34E23
    // b = 1.32E22
    // raymul: a*b = 1.78E18
    let res_actual = Uint256(1784662923287792467, 0);
    let res = WadRayMath.ray_mul(a, b);
    assert res_actual = res;

    // expect overflow
    let (temp_1) = uint256_sub(uint256_max_, half_ray_);
    let (temp_2, _) = uint256_unsigned_div_rem(temp_1, b);
    let (temp_3, _) = uint256_add(temp_2, Uint256(1, 0));

    %{ expect_revert() %}
    WadRayMath.ray_mul(temp_3, b);  // expected to revert

    return ();
}

@external
func test_rayDiv{range_check_ptr}() {
    alloc_locals;
    let uint256_max_ = uint256_max();
    let ray_ = WadRayMath.ray();

    let a = Uint256(134534543232342353231234, 0);
    let b = Uint256(13265462389132757665657, 0);

    // a = 1.34E23
    // b = 1.32E22
    // raydiv: a*b = 1.01E28
    let res_actual = Uint256(10141715327055228122033939726, 0);
    let res = WadRayMath.ray_div(a, b);
    assert res_actual = res;

    let (half_b, _) = uint256_unsigned_div_rem(b, Uint256(2, 0));
    let (temp_1) = uint256_sub(uint256_max_, half_b);
    let (temp_2, _) = uint256_unsigned_div_rem(temp_1, ray_);
    let (temp_3, _) = uint256_add(temp_2, Uint256(1, 0));

    %{ expect_revert() %}
    WadRayMath.ray_div(temp_3, b);  // expected to revert

    %{ expect_revert() %}
    WadRayMath.ray_div(a, Uint256(0, 0));  // expected to revert

    return ();
}

// Conversion tests

@external
func test_ray_to_wad{range_check_ptr}() {
    alloc_locals;
    let ray_ = WadRayMath.ray();
    let wad_ = WadRayMath.wad();

    let res = WadRayMath.ray_to_wad(ray_);
    assert res = wad_;

    return ();
}

@external
func test_wad_to_ray{range_check_ptr}() {
    alloc_locals;
    let ray_ = WadRayMath.ray();
    let wad_ = WadRayMath.wad();

    let res = WadRayMath.wad_to_ray(wad_);
    assert res = ray_;

    return ();
}

@external
func test_ray_to_wad_no_rounding{range_check_ptr}() {
    alloc_locals;
    let ray_ = WadRayMath.ray();
    let wad_ = WadRayMath.wad();

    let res = WadRayMath.ray_to_wad_no_rounding(ray_);
    assert res = wad_;

    // check rounding

    let ray_diminished = WadRayMath.ray_sub(ray_, Uint256(1, 0));
    let wad_diminished = WadRayMath.wad_sub(wad_, Uint256(1, 0));
    let res = WadRayMath.ray_to_wad_no_rounding(ray_diminished);
    assert res = wad_diminished;

    return ();
}

// Exceptions tests

@external
func test_exceptions_mul{range_check_ptr}() {
    alloc_locals;
    let wad_ = WadRayMath.wad();
    let ray_ = WadRayMath.ray();
    let uint256_max_ = uint256_max();

    //
    // WAD
    //

    // multiplication with zero
    let res = WadRayMath.wad_mul(Uint256(0, 10000), Uint256(0, 0));
    assert res = Uint256(0, 0);
    let res = WadRayMath.wad_mul(Uint256(0, 0), Uint256(0, 10000));
    assert res = Uint256(0, 0);

    // Multiplication with non-wad integers (<<1e18)
    let res = WadRayMath.wad_mul(Uint256(0, 10000), wad_);
    assert res = Uint256(0, 10000);
    let res = WadRayMath.wad_mul(wad_, Uint256(0, 10000));
    assert res = Uint256(0, 10000);

    // underflow test
    let res = WadRayMath.wad_mul(Uint256(1000, 0), Uint256(1, 0));
    assert res = Uint256(0, 0);
    let res = WadRayMath.wad_mul(Uint256(1, 0), Uint256(10000, 0));
    assert res = Uint256(0, 0);

    // overflow test
    %{ expect_revert() %}
    WadRayMath.wad_mul(uint256_max_, uint256_max_);  // expected to revert

    //
    // RAY
    //

    // multiplication with zero
    let res = WadRayMath.ray_mul(Uint256(0, 10000), Uint256(0, 0));
    assert res = Uint256(0, 0);
    let res = WadRayMath.ray_mul(Uint256(0, 0), Uint256(0, 10000));
    assert res = Uint256(0, 0);

    // Multiplication with non-ray integers (<< 1e27)
    let res = WadRayMath.ray_mul(Uint256(0, 10000), ray_);
    assert res = Uint256(0, 10000);
    let res = WadRayMath.ray_mul(ray_, Uint256(0, 10000));
    assert res = Uint256(0, 10000);

    // underflow test
    let res = WadRayMath.ray_mul(Uint256(1000, 0), Uint256(1, 0));
    assert res = Uint256(0, 0);
    let res = WadRayMath.ray_mul(Uint256(1, 0), Uint256(10000, 0));
    assert res = Uint256(0, 0);

    // overflow test
    %{ expect_revert() %}
    WadRayMath.ray_mul(uint256_max_, uint256_max_);

    return ();
}

@external
func test_exceptions_div{range_check_ptr}() {
    alloc_locals;
    let wad_ = WadRayMath.wad();
    let half_wad_ = WadRayMath.half_wad();
    let one_ray = WadRayMath.ray();
    let half_ray_ = WadRayMath.half_ray();
    let uint256_max_ = uint256_max();

    //
    // WAD
    //

    // division by 1
    let res = WadRayMath.wad_div(Uint256(1000, 0), wad_);
    assert res = Uint256(1000, 0);

    // underflow test
    let res = WadRayMath.wad_div(Uint256(1, 0), Uint256(0, 10 ** 19));
    assert res = Uint256(0, 0);

    // division by 0
    %{ expect_revert() %}
    WadRayMath.wad_div(Uint256(1, 1), Uint256(0, 0));  // expect revert

    // overflow test
    %{ expect_revert() %}
    WadRayMath.wad_div(uint256_max_, Uint256(1, 0));  // expect revert

    //
    // RAY
    //

    // division by 1
    let res = WadRayMath.ray_div(Uint256(1000, 0), one_ray);
    assert res = Uint256(1000, 0);

    // underflow test
    let res = WadRayMath.ray_div(Uint256(1, 0), Uint256(0, 10 ** 19));
    assert res = Uint256(0, 0);

    // division by 0
    %{ expect_revert() %}
    WadRayMath.ray_div(Uint256(1, 1), Uint256(0, 0));  // expect revert

    // overflow test
    %{ expect_revert() %}
    WadRayMath.ray_div(uint256_max_, Uint256(1, 0));  // expect revert

    return ();
}

@external
func test_ray_mul_no_rounding{range_check_ptr}() {
    alloc_locals;
    let ray_ = WadRayMath.ray();
    let uint256_max_ = uint256_max();

    // zero test
    let res = WadRayMath.ray_mul_no_rounding(Uint256(0, 10000), Uint256(0, 0));
    assert res = Uint256(0, 0);
    let res = WadRayMath.ray_mul_no_rounding(Uint256(0, 0), Uint256(0, 10000));
    assert res = Uint256(0, 0);

    // 1 test
    let res = WadRayMath.ray_mul_no_rounding(Uint256(0, 10000), ray_);
    assert res = Uint256(0, 10000);
    let res = WadRayMath.ray_mul_no_rounding(Uint256(10000, 0), ray_);
    assert res = Uint256(10000, 0);

    // underflow test
    let res = WadRayMath.ray_mul_no_rounding(Uint256(1000, 0), Uint256(1, 0));
    assert res = Uint256(0, 0);
    let res = WadRayMath.ray_mul_no_rounding(Uint256(1, 0), Uint256(10000, 0));
    assert res = Uint256(0, 0);

    // overflow test
    %{ expect_revert() %}
    WadRayMath.ray_mul_no_rounding(uint256_max_, uint256_max_);  // expected to revert

    return ();
}
