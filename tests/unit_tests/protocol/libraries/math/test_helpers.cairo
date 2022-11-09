%lang starknet

from starkware.cairo.common.bool import TRUE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256, uint256_eq

from contracts.protocol.libraries.helpers.constants import UINT128_MAX
from contracts.protocol.libraries.math.felt_math import to_felt, to_uint256
from contracts.protocol.libraries.math.helpers import (
    assert_nonnegative_uint256,
    assert_not_zero_uint256,
)

// Values chosen randomly where: Uint(LOW, HIGH) = VALUE
const HIGH_LARGE = 21;
const LOW_LARGE = 37;
const VALUE_LARGE = 7145929705339707732730866756067132440613;

const HIGH_SMALL = 0;
const LOW_SMALL = 2 ** 127 + 1;
const VALUE_SMALL = LOW_SMALL;

@view
func test_to_felt{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;
    let uint_256 = Uint256(LOW_LARGE, HIGH_LARGE);
    let value_felt = to_felt(uint_256);

    assert value_felt = VALUE_LARGE;

    return ();
}

@view
func test_to_uint256{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;
    let uint_256_constructed = Uint256(LOW_SMALL, HIGH_SMALL);
    let uint_256_from_library = to_uint256(VALUE_SMALL);

    let (are_equal) = uint256_eq(uint_256_from_library, uint_256_constructed);
    assert are_equal = TRUE;

    return ();
}

@view
func test_felt_to_uint256_to_felt{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) {
    alloc_locals;
    let uint_256_val = to_uint256(VALUE_SMALL);
    let felt_val: felt = to_felt(uint_256_val);
    assert VALUE_SMALL = felt_val;

    return ();
}

@view
func test_failure_to_felt{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;
    let uint_256 = Uint256(UINT128_MAX, UINT128_MAX);
    %{ expect_revert() %}
    let value_felt = to_felt(uint_256);

    return ();
}

@view
func test_assert_nonnegative_uint256{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    let sample_uint_256 = to_uint256(VALUE_SMALL);
    assert_nonnegative_uint256(sample_uint_256);
    return ();
}

@view
func test_revert_assert_nonnegative_uint256{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    // TODO: Check with lower values.
    // Right now, this assert fails when values are relatively small.
    // for example: negative_uint_256 = Uint256(UINT128_MAX, 0)
    // won't revert, considering the main function is is using a standard
    // library function, and that, in theory, this check shouldn't be needed
    // for uint values, this function should be double checked before release.
    tempvar negative_uint_256 = Uint256(0, UINT128_MAX);
    %{ expect_revert() %}
    assert_nonnegative_uint256(negative_uint_256);
    return ();
}

@view
func test_assert_not_zero_uint256{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) {
    let not_zero_uint_256 = to_uint256(VALUE_SMALL);
    assert_not_zero_uint256(not_zero_uint_256);
    return ();
}

@view
func test_revert_assert_not_zero_uint256{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    let zero_uint_256 = to_uint256(0);
    %{ expect_revert() %}
    assert_not_zero_uint256(zero_uint_256);
    return ();
}
