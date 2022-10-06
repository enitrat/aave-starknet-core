from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256, uint256_signed_nn, uint256_eq, uint256_check
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.math import assert_250_bit, assert_nn, split_felt, assert_not_equal

from contracts.protocol.libraries.math.felt_math import FeltMath, to_felt

func assert_nonnegative_uint256{range_check_ptr}(value: Uint256) {
    let (is_non_negative) = uint256_signed_nn(value);
    with_attr error_message("assert_nonnegative_uint256: negative number") {
        assert_not_equal(is_non_negative, FALSE);
    }

    return ();
}

func assert_not_zero_uint256{range_check_ptr}(value: Uint256) {
    let (value_felt) = to_felt(value);
    assert_not_equal(value_felt, 0);
    return ();
}

func assert_eq_uint256{range_check_ptr}(value_1: Uint256, value_2: Uint256) {
    let (is_equal) = uint256_eq(value_1, value_2);
    assert is_equal = TRUE;
    return ();
}
