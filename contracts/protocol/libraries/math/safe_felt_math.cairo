from starkware.cairo.common.bool import TRUE, FALSE
from contracts.protocol.libraries.math.safe_cmp import SafeCmp
from contracts.protocol.libraries.math.felt_math import FeltMath
from contracts.protocol.libraries.helpers.bool_cmp import BoolCmp

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
namespace SafeFeltMath {
    //
    //
    // UNSIGNED
    //
    //

    // @notice Adds two integers, and returns output. Interprets a, b in range [0, P)
    // @dev Throws an error is overflow occured
    // @param a Unsigned felt integer
    // @param b Unsigned felt integer
    // @returns res Sum of a and b
    func add_unsigned{range_check_ptr}(a: felt, b: felt) -> (res: felt) {
        alloc_locals;
        let (res, overflow) = FeltMath.add_unsigned(a, b);
        with_attr error_message("add_unsigned: Overflow") {
            assert overflow = FALSE;
        }
        return (res,);
    }

    // @notice Subtracts two integers, and return output and underflow flag. Interprets a, b in range [0, P)
    // @dev Throws an error is underflow occured
    // @param a Unsigned felt integer
    // @param b Unsigned felt integer
    // @returns res Difference between a and b
    func sub_le_unsigned{range_check_ptr}(a: felt, b: felt) -> (res: felt) {
        alloc_locals;
        let (res, underflow) = FeltMath.sub_unsigned(a, b);
        with_attr error_message("sub_lt_unsigned: Underflow") {
            assert underflow = FALSE;
        }
        return (res,);
    }
    // @notice Multiplies two integers, and return output and overflow flag. Interprets a, b in range [0, P)
    // @dev Throws an error is overflow occured
    // @param a Unsigned felt integer
    // @param b Unsigned felt integer
    // @returns res Product of a and b
    func mul_unsigned{range_check_ptr}(a: felt, b: felt) -> (res: felt) {
        alloc_locals;
        let (res, overflow) = FeltMath.mul_unsigned(a, b);
        with_attr error_message("mul_unsigned: Overflow") {
            assert overflow = FALSE;
        }
        return (res,);
    }
    // @notice Calculates exponention of an integer, and return output and an overflow flag. Interprets base, power in range [0, P)
    // @dev Throws an error is overflow occured
    // @param base Unsigned felt integer
    // @param power Unsigned felt integer
    // @returns res Exponention of base to the power
    func pow_unsigned{range_check_ptr}(base: felt, power: felt) -> (res: felt) {
        alloc_locals;
        let (res, overflow) = FeltMath.pow_unsigned(base, power);
        with_attr error_message("pow_unsigned: Overflow") {
            assert overflow = FALSE;
        }
        return (res,);
    }
    // @notice Adds two integers and multiplies result by last integer, and returns output. Interprets a, b and c in range [0, P)
    // @dev Throws an error is overflow occured
    // @param a Unsigned felt integer
    // @param b Unsigned felt integer
    // @param b Unsigned felt integer
    // @returns res Result of (a + b) * c
    func add_mul_unsigned{range_check_ptr}(a: felt, b: felt, c: felt) -> (res: felt) {
        alloc_locals;
        let (add_res, add_overflow) = FeltMath.add_unsigned(a, b);
        let (res, mul_overflow) = FeltMath.mul_unsigned(add_res, c);
        let (overflow) = BoolCmp.either(add_overflow, mul_overflow);
        with_attr error_message("add_mul_unsigned: Overflow") {
            assert overflow = FALSE;
        }
        return (res,);
    }
    // @notice Multiplies two integers and adds result to the last integer, and returns output. Interprets a, b and c in range [0, P)
    // @dev Throws an error is overflow occured
    // @param a Unsigned felt integer
    // @param b Unsigned felt integer
    // @param b Unsigned felt integer
    // @returns res Result of (a * b) + c
    func mul_add_unsigned{range_check_ptr}(a: felt, b: felt, c: felt) -> (res: felt) {
        alloc_locals;
        let (mul_res, mul_overflow) = FeltMath.mul_unsigned(a, b);
        let (res, add_overflow) = FeltMath.add_unsigned(mul_res, c);
        let (overflow) = BoolCmp.either(add_overflow, mul_overflow);
        with_attr error_message("mul_add_unsigned: Overflow") {
            assert overflow = FALSE;
        }
        return (res,);
    }

    //
    //
    // SIGNED
    //
    //

    // @notice Adds two integers, and return output and carry. Interprets a, b in range [-(P-1)/2, (P-1)/2]
    // @dev Throws an error is overflow occured
    // @param a Signed felt integer
    // @param b Signed felt integer
    // @returns res Sum of a and b
    func add_signed{range_check_ptr}(a: felt, b: felt) -> (res: felt) {
        alloc_locals;
        let (res, overflow) = FeltMath.add_signed(a, b);
        with_attr error_message("add_signed: Overflow") {
            assert overflow = FALSE;
        }
        return (res,);
    }
    // @notice Subtracts two integers, and return output and underflow flag. Interprets a, b in range [-P/2, P/2]
    // @dev Throws an error is underflow occured
    // @param a Signed felt integer
    // @param b Signed felt integer
    // @returns res Difference between a and b
    func sub_signed{range_check_ptr}(a: felt, b: felt) -> (res: felt) {
        alloc_locals;
        let (res, underflow) = FeltMath.sub_signed(a, b);
        with_attr error_message("sub_signed: Underflow") {
            assert underflow = FALSE;
        }
        return (res,);
    }
}
