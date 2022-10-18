%lang starknet

from starkware.cairo.common.bool import FALSE, TRUE
from contracts.protocol.libraries.math.safe_felt_math import SafeFeltMath
from contracts.protocol.libraries.helpers.constants import (
    CAIRO_FIELD_ORDER,
    MAX_SIGNED_FELT,
    MAX_UNSIGNED_FELT,
    MIN_SIGNED_FELT,
)

@view
func test_add_unsigned{range_check_ptr}() {
    let sum = SafeFeltMath.add_unsigned(0, 1);
    assert sum = 1;

    let sum = SafeFeltMath.add_unsigned(MAX_SIGNED_FELT, MAX_SIGNED_FELT);
    assert sum = (MAX_SIGNED_FELT * 2);
    assert sum = MAX_UNSIGNED_FELT;

    return ();
}

@view
func test_fail_add_unsigned{range_check_ptr}() {
    %{ expect_revert() %}
    let sum = SafeFeltMath.add_unsigned(MAX_UNSIGNED_FELT, MAX_UNSIGNED_FELT);
    return ();
}

@view
func test_sub_le_unsigned{range_check_ptr}() {
    let diff = SafeFeltMath.sub_le_unsigned(1, 0);
    assert diff = 1;

    let diff = SafeFeltMath.sub_le_unsigned(MAX_SIGNED_FELT, MAX_SIGNED_FELT);
    assert diff = 0;
    assert diff = CAIRO_FIELD_ORDER;

    let diff = SafeFeltMath.sub_le_unsigned(-1, 1);
    assert diff = MAX_UNSIGNED_FELT - 1;

    return ();
}

@view
func test_fail_sub_le_unsigned{range_check_ptr}() {
    %{ expect_revert() %}
    let sum = SafeFeltMath.sub_le_unsigned(0, 1);
    return ();
}

@view
func test_mul_unsigned{range_check_ptr}() {
    let prod = SafeFeltMath.mul_unsigned(1, 0);
    assert prod = 0;
    assert prod = CAIRO_FIELD_ORDER;

    let prod = SafeFeltMath.mul_unsigned(MAX_SIGNED_FELT, 2);
    assert prod = CAIRO_FIELD_ORDER - 1;

    let prod = SafeFeltMath.mul_unsigned(3, 2);
    assert prod = 6;

    return ();
}

@view
func test_fail_mul_unsigned{range_check_ptr}() {
    %{ expect_revert() %}
    let prod = SafeFeltMath.mul_unsigned(MAX_SIGNED_FELT, 3);
    return ();
}

@view
func test_pow_unsigned{range_check_ptr}() {
    let prod = SafeFeltMath.pow_unsigned(1, 0);
    assert prod = 1;

    let prod = SafeFeltMath.pow_unsigned(100, 1);
    assert prod = 100;

    let prod = SafeFeltMath.pow_unsigned(3, 2);
    assert prod = 9;

    return ();
}

@view
func test_fail_pow_unsigned{range_check_ptr}() {
    %{ expect_revert() %}
    let prod = SafeFeltMath.pow_unsigned(MAX_SIGNED_FELT, 2);
    return ();
}

@view
func test_add_signed{range_check_ptr}() {
    let sum = SafeFeltMath.add_signed(0, 1);
    assert sum = 1;

    let sum = SafeFeltMath.add_signed(-3, -2);
    assert sum = -5;

    let sum = SafeFeltMath.add_signed(-3, 5);
    assert sum = 2;

    return ();
}

@view
func test_fail_add_signed{range_check_ptr}() {
    %{ expect_revert() %}
    let sum = SafeFeltMath.add_signed(MAX_SIGNED_FELT, 1);
    return ();
}

@view
func test_sub_signed{range_check_ptr}() {
    let diff = SafeFeltMath.sub_signed(0, 1);
    assert diff = -1;

    let diff = SafeFeltMath.sub_signed(-3, -2);
    assert diff = -1;

    let diff = SafeFeltMath.sub_signed(-3, 5);
    assert diff = -8;

    let diff = SafeFeltMath.sub_signed(3, -5);
    assert diff = 8;

    return ();
}

@view
func test_fail_sub_signed{range_check_ptr}() {
    %{ expect_revert() %}
    let sum = SafeFeltMath.sub_signed(MIN_SIGNED_FELT, 1);
    return ();
}
