from starkware.cairo.common.math_cmp import is_le_felt
from starkware.cairo.common.bool import TRUE, FALSE

from contracts.protocol.libraries.helpers.bool_cmp import BoolCmp
from contracts.protocol.libraries.math.safe_cmp import SafeCmp
from contracts.protocol.libraries.helpers.constants import MAX_SIGNED_FELT

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
    // @dev Utilizes internal recursive function to better track the overflow occurence
    // @param a Unsigned felt integer
    // @param b Unsigned felt integer
    // @returns res Product of a and b
    // @returns overflow Bool flag indicating if overflow occured
    func mul_unsigned{range_check_ptr}(a: felt, b: felt) -> (res: felt, overflow: felt) {
        // minimize steps
        let (is_a_smaller) = SafeCmp.is_lt_unsigned(a, b);
        if (is_a_smaller == TRUE) {
            return mul_unsigned(b, a);
        }

        if (b == 0) {
            return (0, 0);
        }

        if (b == 1) {
            return (a, 0);
        }

        return _mul_inner(0, 0, a, b);
    }

    // @notice Inner function to mul_unsigned
    // @dev Tail-recursive function
    // @param acc Accumulated result from the previous recursive calls
    // @param flag_overflow Bool flag indicating if overflow happened
    // @param base Unsigned integer - multiplicant
    // @param counter Unsigned integer - multiplier
    // @returns res Sum of acc and base or end product if overflow happened
    // @returns overflow Bool flag indicating if overflow happened
    func _mul_inner{range_check_ptr}(acc: felt, flag_overflow: felt, base: felt, counter: felt) -> (
        res: felt, overflow: felt
    ) {
        alloc_locals;
        if (flag_overflow == TRUE) {
            return ((base * counter) + acc, TRUE);
        }

        let (res, overflow) = add_unsigned(acc, base);
        let new_counter = counter - 1;
        if (new_counter == 0) {
            return (res, overflow);
        }
        return _mul_inner(res, overflow, base, new_counter);
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
