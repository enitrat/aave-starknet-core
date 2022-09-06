%lang starknet

from starkware.cairo.common.bool import FALSE, TRUE

from contracts.protocol.libraries.math.felt_math import FeltMath
from contracts.protocol.libraries.helpers.constants import (
    CAIRO_FIELD_ORDER,
    MAX_SIGNED_FELT,
    MAX_UNSIGNED_FELT,
)

@view
func test_add_unsigned{range_check_ptr}():
    let (sum, is_overflow) = FeltMath.add_unsigned(0, 1)
    assert sum = 1
    assert is_overflow = FALSE

    let (sum, is_overflow) = FeltMath.add_unsigned(MAX_SIGNED_FELT, MAX_SIGNED_FELT)
    assert sum = (MAX_SIGNED_FELT * 2)
    assert is_overflow = FALSE

    let (sum, is_overflow) = FeltMath.add_unsigned(MAX_SIGNED_FELT, MAX_SIGNED_FELT + 1)
    assert sum = 0
    assert is_overflow = TRUE

    return ()
end

@view
func test_sub_unsigned{range_check_ptr}():
    let (sub, is_underflow) = FeltMath.sub_unsigned(2, 2)
    assert sub = 0
    assert is_underflow = FALSE

    let (sub, is_underflow) = FeltMath.sub_unsigned(MAX_SIGNED_FELT, 0)
    assert sub = MAX_SIGNED_FELT
    assert is_underflow = FALSE

    let (sub, is_underflow) = FeltMath.sub_unsigned(MAX_UNSIGNED_FELT, MAX_SIGNED_FELT)
    assert sub = MAX_SIGNED_FELT
    assert is_underflow = FALSE

    let (sub, is_underflow) = FeltMath.sub_unsigned(1, 2)
    assert sub = MAX_UNSIGNED_FELT
    assert is_underflow = TRUE

    return ()
end

@view
func test_mul_unsigned{range_check_ptr}():
    let (mul, is_overflow) = FeltMath.mul_unsigned(3, 2)
    assert mul = 6
    assert is_overflow = FALSE

    let (mul, is_overflow) = FeltMath.mul_unsigned(MAX_SIGNED_FELT, 2)
    assert mul = MAX_UNSIGNED_FELT
    assert is_overflow = FALSE

    let (mul, is_overflow) = FeltMath.mul_unsigned(MAX_SIGNED_FELT, 3)
    assert mul = MAX_SIGNED_FELT - 1
    assert is_overflow = TRUE

    let (mul, is_overflow) = FeltMath.mul_unsigned(MAX_SIGNED_FELT, 4)
    assert mul = CAIRO_FIELD_ORDER - 2
    assert is_overflow = TRUE

    return ()
end

@view
func test_pow_unsigned{range_check_ptr}():
    let (pow, is_overflow) = FeltMath.pow_unsigned(2, 0)
    assert pow = 1
    assert is_overflow = FALSE

    let (pow, is_overflow) = FeltMath.pow_unsigned(2, 3)
    assert pow = 8
    assert is_overflow = FALSE

    let (pow, is_overflow) = FeltMath.pow_unsigned(2, 251)
    assert pow = 2 ** 251
    assert is_overflow = FALSE

    let (pow, is_overflow) = FeltMath.pow_unsigned(2, 252)
    assert pow = (CAIRO_FIELD_ORDER - 17 * 2 ** 192 - 1) * 2
    assert is_overflow = TRUE

    return ()
end

@view
func test_add_signed{range_check_ptr}():
    let (sum, is_overflow) = FeltMath.add_signed(0, 1)
    assert sum = 1
    assert is_overflow = FALSE

    let (sum, is_overflow) = FeltMath.add_signed(-1, 1)
    assert sum = 0
    assert is_overflow = FALSE

    let (sum, is_overflow) = FeltMath.add_signed(MAX_SIGNED_FELT + 1, MAX_SIGNED_FELT + 1)
    assert sum = 1
    assert is_overflow = TRUE

    let (sum, is_overflow) = FeltMath.add_signed(MAX_SIGNED_FELT, MAX_SIGNED_FELT)
    assert sum = MAX_UNSIGNED_FELT
    assert is_overflow = TRUE

    return ()
end

@view
func test_sub_signed{range_check_ptr}():
    let (sum, is_overflow) = FeltMath.sub_signed(1, 0)
    assert sum = 1
    assert is_overflow = FALSE

    let (sum, is_overflow) = FeltMath.sub_signed(-1, 1)
    assert sum = -2
    assert is_overflow = FALSE

    let (sum, is_overflow) = FeltMath.sub_signed(MAX_SIGNED_FELT, MAX_SIGNED_FELT + 1)
    assert sum = -1
    assert is_overflow = TRUE

    let (sum, is_overflow) = FeltMath.sub_signed(-MAX_SIGNED_FELT, MAX_SIGNED_FELT)
    assert sum = (-CAIRO_FIELD_ORDER) + 1
    assert is_overflow = TRUE

    return ()
end
