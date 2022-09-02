%lang starknet

from starkware.cairo.common.bool import FALSE, TRUE

from contracts.protocol.libraries.math.feltmath import FeltMath
from contracts.protocol.libraries.helpers.constants import P, half_P, signed_MIN
from contracts.protocol.libraries.helpers.bool_cmp import BoolCompare

@view
func test_add_unsigned{range_check_ptr}():
    let (sum, is_overflow) = FeltMath.add_unsigned(0, 1)
    assert sum = 1
    assert is_overflow = FALSE

    let (sum, is_overflow) = FeltMath.add_unsigned(half_P, half_P)
    assert sum = (half_P * 2)
    assert is_overflow = FALSE

    let (sum, is_overflow) = FeltMath.add_unsigned(half_P, half_P + 1)
    assert sum = 0
    assert is_overflow = TRUE

    return ()
end

@view
func test_sub_unsigned{range_check_ptr}():
    let (sub, is_underflow) = FeltMath.sub_unsigned(2, 2)
    assert sub = 0
    assert is_underflow = FALSE

    let (sub, is_underflow) = FeltMath.sub_unsigned(half_P, 0)
    assert sub = half_P
    assert is_underflow = FALSE

    let (sub, is_underflow) = FeltMath.sub_unsigned(P - 1, half_P)
    assert sub = half_P
    assert is_underflow = FALSE

    let (sub, is_underflow) = FeltMath.sub_unsigned(1, 2)
    assert sub = P - 1
    assert is_underflow = TRUE

    return ()
end

@view
func test_mul_unsigned{range_check_ptr}():
    let (mul, is_overflow) = FeltMath.mul_unsigned(3, 2)
    assert mul = 6
    assert is_overflow = FALSE

    let (mul, is_overflow) = FeltMath.mul_unsigned(half_P, 2)
    assert mul = P - 1
    assert is_overflow = FALSE

    let (mul, is_overflow) = FeltMath.mul_unsigned(half_P, 3)
    assert mul = half_P - 1
    assert is_overflow = TRUE

    let (mul, is_overflow) = FeltMath.mul_unsigned(half_P, 4)
    assert mul = P - 2
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
    assert pow = (P - 17 * 2 ** 192 - 1) * 2
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

    let (sum, is_overflow) = FeltMath.add_signed(half_P + 1, half_P + 1)
    assert sum = 1
    assert is_overflow = TRUE

    let (sum, is_overflow) = FeltMath.add_signed(half_P, half_P)
    assert sum = P - 1
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

    let (sum, is_overflow) = FeltMath.sub_signed(half_P, half_P + 1)
    assert sum = -1
    assert is_overflow = TRUE

    let (sum, is_overflow) = FeltMath.sub_signed(-half_P, half_P)
    assert sum = (-P) + 1
    assert is_overflow = TRUE

    return ()
end
