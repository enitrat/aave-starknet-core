from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math_cmp import is_le_felt
from starkware.cairo.common.math import unsigned_div_rem, split_felt
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.uint256 import (
    Uint256,
    uint256_unsigned_div_rem,
    uint256_eq,
    uint256_check,
)

from contracts.protocol.libraries.helpers.bool_cmp import BoolCmp
from contracts.protocol.libraries.math.safe_cmp import SafeCmp
from contracts.protocol.libraries.helpers.constants import MAX_SIGNED_FELT, MAX_UNSIGNED_FELT
from contracts.protocol.libraries.math.safe_uint256_cmp import SafeUint256Cmp

// @notice Library to safely compare felts interpreted as unsigned or signed integers.
//
//         Motivation:
//         Library for safe arithmetic that allows for tracking if overflow occured.
//         For arithmetic operations on felts developers can use builtin operators (+ - * /).
//         However those operators do not allow to track if during the operations overflow/underflow happened.
//         This is not safe, and may result in unexpected arithmetic errors.
//         Other challenge is to tract overflows/underflows for signed integers.
//         Therefore functions provided in this library allow for safe arithmetic operations with with signed and unsigned integers.
//
// @author Nethermind
namespace FeltMath {
    //
    //
    // UNSIGNED
    //
    //

    // @notice Adds two integers, and return output and carry. Interprets a, b in range [0, P)
    // @param a Unsigned felt integer
    // @param b Unsigned felt integer
    // @returns res Sum of a and b
    // @returns carry Bool flag indicating if overflow occured
    func add_unsigned{range_check_ptr}(a: felt, b: felt) -> (res: felt, carry: felt) {
        alloc_locals;
        let res = a + b;
        let (carry_a) = SafeCmp.is_lt_unsigned(res, a);
        let (carry_b) = SafeCmp.is_lt_unsigned(res, b);
        let (overflow) = BoolCmp.either(carry_a, carry_b);
        return (res, overflow);
    }

    // @notice Subtracts two integers, and return output and underflow flag. Interprets a, b in range [0, P)
    // @param a Unsigned felt integer
    // @param b Unsigned felt integer
    // @returns res Difference between a and b
    // @returns underflow Bool flag indicating if underflow occured
    func sub_unsigned{range_check_ptr}(a: felt, b: felt) -> (res: felt, underflow: felt) {
        let res = a - b;
        let (underflow) = SafeCmp.is_lt_unsigned(a, b);
        return (res, underflow);
    }
    // @notice Multiplies two integers, and return output and overflow flag. Interprets a, b in range [0, P)
    // @param a Unsigned felt integer
    // @param b Unsigned felt integer
    // @returns res Product of a and b
    // @returns overflow Bool flag indicating if overflow occured
    func mul_unsigned{range_check_ptr}(a: felt, b: felt) -> (res: felt, overflow: felt) {
        alloc_locals;
        if (a == 0) {
            return (0, 0);
        }
        if (b == 0) {
            return (0, 0);
        }
        // minimize steps with checking if overflow occured
        // conversion to Uint256 because of division of MAX_UNSIGNED_FELT
        let (MAX_UNSIGNED_UINT: Uint256) = to_uint256(MAX_UNSIGNED_FELT);
        let (a_uint256: Uint256) = to_uint256(a);
        let (q: Uint256, r: Uint256) = uint256_unsigned_div_rem(MAX_UNSIGNED_UINT, a_uint256);
        let (b_uint256: Uint256) = to_uint256(b);
        let (overflow) = SafeUint256Cmp.lt(q, b_uint256);
        let res = a * b;
        return (res, overflow);
    }

    // @notice Divides two felts, and return the quotient and the remainder. Interprets a, b in range [0, P)
    // @param a Unsigned felt integer
    // @param b Unsigned felt integer
    // @returns q quotient of a divided by b
    // @returns r remainder of a divided by b
    func div_unsigned{range_check_ptr}(a: felt, b: felt) -> (q: felt, r: felt) {
        alloc_locals;
        // conversion to Uint256 because using unsigned_div_rem requires 0 <= q < rc_bound and doesn't
        // allow us to use the full range of a felt for a division.
        let (a_uint256: Uint256) = to_uint256(a);
        let (b_uint256: Uint256) = to_uint256(b);
        let (q: Uint256, r: Uint256) = uint256_unsigned_div_rem(a_uint256, b_uint256);
        let (q_felt) = to_felt(q);
        let (r_felt) = to_felt(r);
        return (q_felt, r_felt);
    }
    // @notice Calculates exponention of an integer, and return output and an overflow flag. Interprets base, power in range [0, P)
    // @dev Utilizes internal recursive function to better track the overflow occurence
    // @param base Unsigned felt integer
    // @param power Unsigned felt integer
    // @returns res Exponention of base to the power
    // @returns overflow Bool flag indicating if overflow occured
    func pow_unsigned{range_check_ptr}(base: felt, power: felt) -> (res: felt, overflow: felt) {
        if (power == 0) {
            return (1, 0);
        }
        return _pow_inner(1, 0, base, power);
    }

    // @notice Inner function to pow_unsigned
    // @dev Tail-recursive function
    // @param acc Accumulated result from the previous recursive calls
    // @param flag_overflow Bool flag indicating if overflow happened
    // @param base Unsigned integer - base of exponantion
    // @param power Unsigned integer - exponent
    // @returns res Product of acc and base
    // @returns overflow Bool flag indicating if overflow happened
    func _pow_inner{range_check_ptr}(acc: felt, flag_overflow: felt, base: felt, counter: felt) -> (
        res: felt, overflow: felt
    ) {
        let (res, overflow) = mul_unsigned(acc, base);
        let new_counter = counter - 1;
        let (new_flag_overflow) = BoolCmp.either(flag_overflow, overflow);
        if (new_counter == 0) {
            return (res, new_flag_overflow);
        }
        return _pow_inner(res, new_flag_overflow, base, new_counter);
    }

    //
    //
    // SIGNED
    //
    //

    // @notice Adds two integers, and return output and carry. Interprets a, b in range [-(P-1)/2, (P-1)/2]
    // @param a Signed felt integer
    // @param b Signed felt integer
    // @returns res Sum of a and b
    // @returns carry Bool flag indicating if overflow occured
    func add_signed{range_check_ptr}(a: felt, b: felt) -> (res: felt, carry: felt) {
        alloc_locals;
        let (is_nn_signed_a) = SafeCmp.is_nn_signed(a);
        let (is_nn_signed_b) = SafeCmp.is_nn_signed(b);

        let res = a + b;
        let (cmp_signs) = BoolCmp.eq(is_nn_signed_a, is_nn_signed_b);
        if (cmp_signs == TRUE) {
            if (is_nn_signed_a == TRUE) {
                let (overflow) = SafeCmp.is_lt_unsigned(MAX_SIGNED_FELT, res);
                return (res, overflow);
            }
            let overflow = is_le_felt(res, MAX_SIGNED_FELT);
            return (res, overflow);
        }

        return (res, FALSE);
    }

    // @notice Subtracts two integers, and return output and underflow flag. Interprets a, b in range [-P/2, P/2]
    // @param a Signed felt integer
    // @param b Signed felt integer
    // @returns res Difference between a and b
    // @returns underflow Bool flag indicating if underflow occured
    func sub_signed{range_check_ptr}(a: felt, b: felt) -> (res: felt, carry: felt) {
        return add_signed(a, -b);
    }
}

func to_uint256{range_check_ptr}(value: felt) -> (res: Uint256) {
    alloc_locals;

    with_attr error_message("to_uint256: invalid uint") {
        let (local high, local low) = split_felt(value);
    }

    let res = Uint256(low, high);
    return (res,);
}

// Takes Uint256 as input and returns a felt
func to_felt{range_check_ptr}(value: Uint256) -> (res: felt) {
    uint256_check(value);

    let (res1, mul_overflow) = FeltMath.mul_unsigned(value.high, 2 ** 128);
    with_attr error_message("to_felt: Value doesn't fit in a felt") {
        assert mul_overflow = FALSE;
    }

    let (res, add_overflow) = FeltMath.add_unsigned(value.low, res1);
    with_attr error_message("to_felt: Value doesn't fit in a felt") {
        assert add_overflow = FALSE;
    }

    return (res,);
}
