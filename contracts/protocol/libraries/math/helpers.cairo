from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256, uint256_signed_nn, uint256_eq
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.math import assert_250_bit, assert_nn, split_felt, assert_not_equal

// Takes Uint256 as input and returns a felt
func to_felt{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(value: Uint256) -> (
    res: felt
) {
    let res = value.low + value.high * (2 ** 128);

    with_attr error_message("to_felt: Value doesn't fit in a felt") {
        assert_250_bit(res);
    }

    return (res,);
}

// Takes felt of any size and turns it into uint256
func to_uint256{range_check_ptr}(value: felt) -> (res: Uint256) {
    alloc_locals;

    // with_attr error_message("to_uint256: Not a positive value or overflown"):
    //    assert_nn(value)
    // end

    with_attr error_message("to_uint256: invalid uint") {
        let (local high, local low) = split_felt(value);
    }

    let res = Uint256(low, high);
    return (res,);
}

func assert_nonnegative_uint256{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    value: Uint256
) {
    let (is_non_negative) = uint256_signed_nn(value);
    with_attr error_message("assert_nonnegative_uint256: negative number") {
        assert_not_equal(is_non_negative, FALSE);
    }

    return ();
}

func assert_not_zero_uint256{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    value: Uint256
) {
    let (value_felt) = to_felt(value);
    assert_not_equal(value_felt, 0);
    return ();
}

func assert_eq_uint256{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    value_1: Uint256, value_2: Uint256
) {
    let (is_equal) = uint256_eq(value_1, value_2);
    assert is_equal = TRUE;
    return ();
}
