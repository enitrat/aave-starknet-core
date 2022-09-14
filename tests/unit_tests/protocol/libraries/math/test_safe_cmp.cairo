%lang starknet

from starkware.cairo.common.bool import FALSE, TRUE

from contracts.protocol.libraries.math.safe_cmp import SafeCmp
from contracts.protocol.libraries.helpers.constants import (
    CAIRO_FIELD_ORDER,
    MIN_SIGNED_FELT,
    MAX_SIGNED_FELT,
    MAX_UNSIGNED_FELT,
)

@view
func test_max_unsigned_felt{range_check_ptr}() {
    assert MAX_SIGNED_FELT = -MIN_SIGNED_FELT;
    return ();
}

@view
func test_is_le_unsigned{range_check_ptr}() {
    // Regular tests
    let (res_1) = SafeCmp.is_le_unsigned(1, 2);
    assert res_1 = TRUE;
    let (res_2) = SafeCmp.is_le_unsigned(2, 2);
    assert res_2 = TRUE;
    let (res_3) = SafeCmp.is_le_unsigned(3, 2);
    assert res_3 = FALSE;

    // check boundaries
    let (res_4) = SafeCmp.is_le_unsigned(MAX_SIGNED_FELT, MIN_SIGNED_FELT);
    assert res_4 = TRUE;
    let (res_5) = SafeCmp.is_le_unsigned(0, MIN_SIGNED_FELT);
    assert res_5 = TRUE;
    let (res_6) = SafeCmp.is_le_unsigned(MIN_SIGNED_FELT, MAX_UNSIGNED_FELT);
    assert res_6 = TRUE;
    let (res_7) = SafeCmp.is_le_unsigned(0, MAX_UNSIGNED_FELT);
    assert res_7 = TRUE;
    return ();
}

@view
func test_is_lt_unsigned{range_check_ptr}() {
    // Regular tests
    let (res_1) = SafeCmp.is_lt_unsigned(1, 2);
    assert res_1 = TRUE;
    let (res_2) = SafeCmp.is_lt_unsigned(2, 2);
    assert res_2 = FALSE;
    let (res_3) = SafeCmp.is_lt_unsigned(3, 2);
    assert res_3 = FALSE;

    // check boundaries
    let (res_4) = SafeCmp.is_lt_unsigned(MAX_SIGNED_FELT, MIN_SIGNED_FELT);
    assert res_4 = TRUE;
    let (res_5) = SafeCmp.is_lt_unsigned(0, MIN_SIGNED_FELT);
    assert res_5 = TRUE;
    let (res_6) = SafeCmp.is_lt_unsigned(MIN_SIGNED_FELT, MAX_UNSIGNED_FELT);
    assert res_6 = TRUE;
    let (res_7) = SafeCmp.is_lt_unsigned(0, MAX_UNSIGNED_FELT);
    assert res_7 = TRUE;

    return ();
}

@view
func test_is_in_range_unsigned{range_check_ptr}() {
    let (res_1) = SafeCmp.is_in_range_unsigned(3, 0, 5);
    assert res_1 = TRUE;
    let (res_2) = SafeCmp.is_in_range_unsigned(3, 3, 5);
    assert res_2 = TRUE;
    let (res_3) = SafeCmp.is_in_range_unsigned(5, 3, 5);
    assert res_3 = FALSE;
    let (res_4) = SafeCmp.is_in_range_unsigned(6, 0, 2);
    assert res_4 = FALSE;

    %{ expect_revert(error_message="Range definition error: low >= high") %}
    SafeCmp.is_in_range_unsigned(3, 7, 2);
    return ();
}

@view
func test_assert_le_unsigned_1{range_check_ptr}() {
    %{ expect_revert() %}
    SafeCmp.assert_le_unsigned(MAX_UNSIGNED_FELT, MIN_SIGNED_FELT);
    return ();
}

@view
func test_assert_le_unsigned_2{range_check_ptr}() {
    %{ expect_revert() %}
    SafeCmp.assert_le_unsigned(MIN_SIGNED_FELT, 0);
    return ();
}

@view
func test_assert_le_unsigned_3{range_check_ptr}() {
    SafeCmp.assert_le_unsigned(MIN_SIGNED_FELT, MIN_SIGNED_FELT);
    SafeCmp.assert_le_unsigned(MIN_SIGNED_FELT, MAX_UNSIGNED_FELT);
    return ();
}

@view
func test_assert_lt_unsigned_1{range_check_ptr}() {
    %{ expect_revert() %}
    SafeCmp.assert_lt_unsigned(MAX_UNSIGNED_FELT, MIN_SIGNED_FELT);
    return ();
}

@view
func test_assert_lt_unsigned_2{range_check_ptr}() {
    %{ expect_revert() %}
    SafeCmp.assert_lt_unsigned(MIN_SIGNED_FELT, 0);
    return ();
}

@view
func test_assert_lt_unsigned_3{range_check_ptr}() {
    %{ expect_revert() %}
    SafeCmp.assert_lt_unsigned(MIN_SIGNED_FELT, MIN_SIGNED_FELT);
    return ();
}

@view
func test_assert_lt_unsigned_4{range_check_ptr}() {
    SafeCmp.assert_lt_unsigned(MIN_SIGNED_FELT, MAX_UNSIGNED_FELT);
    SafeCmp.assert_lt_unsigned(1, 2);
    return ();
}

@view
func test_assert_in_range_unsigned_1{range_check_ptr}() {
    %{ expect_revert(error_message="Range definition error: low >= high") %}
    SafeCmp.assert_in_range_unsigned(MIN_SIGNED_FELT, MAX_UNSIGNED_FELT, MIN_SIGNED_FELT);
    return ();
}

@view
func test_assert_in_range_unsigned_2{range_check_ptr}() {
    %{ expect_revert() %}
    SafeCmp.assert_in_range_unsigned(MAX_UNSIGNED_FELT, 0, MIN_SIGNED_FELT);
    return ();
}

@view
func test_assert_in_range_unsigned_3{range_check_ptr}() {
    %{ expect_revert() %}
    SafeCmp.assert_in_range_unsigned(MIN_SIGNED_FELT, 0, MIN_SIGNED_FELT);
    return ();
}

@view
func test_assert_in_range_unsigned_4{range_check_ptr}() {
    SafeCmp.assert_in_range_unsigned(MIN_SIGNED_FELT, MIN_SIGNED_FELT, MAX_UNSIGNED_FELT);
    SafeCmp.assert_in_range_unsigned(MIN_SIGNED_FELT, 0, MAX_UNSIGNED_FELT);
    SafeCmp.assert_in_range_unsigned(1, 0, 2);
    return ();
}

@view
func test_is_nn_signed{range_check_ptr}() {
    // False results
    let (res_1) = SafeCmp.is_nn_signed(MIN_SIGNED_FELT);
    assert res_1 = FALSE;
    let (res_2) = SafeCmp.is_nn_signed(MAX_UNSIGNED_FELT);
    assert res_2 = FALSE;
    let (res_3) = SafeCmp.is_nn_signed(-1);
    assert res_3 = FALSE;

    // True results
    let (res_4) = SafeCmp.is_nn_signed(MAX_SIGNED_FELT);
    assert res_4 = TRUE;
    let (res_5) = SafeCmp.is_nn_signed(0);
    assert res_5 = TRUE;

    return ();
}

@view
func test_is_le_signed{range_check_ptr}() {
    // tests when a = b
    let (res_1) = SafeCmp.is_le_signed(1, 1);
    assert res_1 = TRUE;
    let (res_2) = SafeCmp.is_le_signed(-1, -1);
    assert res_2 = TRUE;
    let (res_3) = SafeCmp.is_le_signed(MIN_SIGNED_FELT, MIN_SIGNED_FELT);
    assert res_3 = TRUE;

    // tests when a is non negative and b neg (always FALSE)
    let (res_4) = SafeCmp.is_le_signed(3, -1);
    assert res_4 = FALSE;
    let (res_5) = SafeCmp.is_le_signed(1, MIN_SIGNED_FELT);
    assert res_5 = FALSE;

    // tests when a is neg and b non neg (always TRUE)
    let (res_6) = SafeCmp.is_le_signed(MIN_SIGNED_FELT, 2);
    assert res_6 = TRUE;
    let (res_7) = SafeCmp.is_le_signed(-1, 5);
    assert res_7 = TRUE;

    // tests when a and b are the same sign
    let (res_8) = SafeCmp.is_le_signed(CAIRO_FIELD_ORDER + 1, MAX_SIGNED_FELT);
    assert res_8 = TRUE;
    let (res_9) = SafeCmp.is_le_signed(3, 2);
    assert res_9 = FALSE;
    let (res_10) = SafeCmp.is_le_signed(MAX_SIGNED_FELT, CAIRO_FIELD_ORDER + 1);
    assert res_10 = FALSE;
    let (res_11) = SafeCmp.is_le_signed(MAX_UNSIGNED_FELT, MIN_SIGNED_FELT);
    assert res_11 = FALSE;
    let (res_12) = SafeCmp.is_le_signed(MIN_SIGNED_FELT, MAX_UNSIGNED_FELT);
    assert res_12 = TRUE;

    return ();
}

@view
func test_is_lt_signed{range_check_ptr}() {
    // tests when a = b
    let (res_1) = SafeCmp.is_lt_signed(1, 1);
    assert res_1 = FALSE;
    let (res_2) = SafeCmp.is_lt_signed(-1, -1);
    assert res_2 = FALSE;
    let (res_3) = SafeCmp.is_lt_signed(MIN_SIGNED_FELT, MIN_SIGNED_FELT);
    assert res_3 = FALSE;

    // tests when a is non negative and b neg (always FALSE)
    let (res_4) = SafeCmp.is_lt_signed(3, -1);
    assert res_4 = FALSE;
    let (res_5) = SafeCmp.is_lt_signed(1, MIN_SIGNED_FELT);
    assert res_5 = FALSE;

    // tests when a is neg and b non neg (always TRUE)
    let (res_6) = SafeCmp.is_lt_signed(MIN_SIGNED_FELT, 2);
    assert res_6 = TRUE;
    let (res_7) = SafeCmp.is_lt_signed(-1, 5);
    assert res_7 = TRUE;

    // tests when a and b are the same sign
    let (res_8) = SafeCmp.is_lt_signed(CAIRO_FIELD_ORDER + 1, MAX_SIGNED_FELT);
    assert res_8 = TRUE;
    let (res_9) = SafeCmp.is_lt_signed(3, 2);
    assert res_9 = FALSE;
    let (res_10) = SafeCmp.is_lt_signed(MAX_SIGNED_FELT, CAIRO_FIELD_ORDER + 1);
    assert res_10 = FALSE;
    let (res_11) = SafeCmp.is_lt_signed(MAX_UNSIGNED_FELT, MIN_SIGNED_FELT);
    assert res_11 = FALSE;
    let (res_12) = SafeCmp.is_lt_signed(MIN_SIGNED_FELT, MAX_UNSIGNED_FELT);
    assert res_12 = TRUE;

    return ();
}

@view
func test_is_in_range_signed_1{range_check_ptr}() {
    %{ expect_revert(error_message="Range definition error: low >= high") %}
    SafeCmp.is_in_range_signed(5, 5, 3);
    return ();
}

@view
func test_is_in_range_signed_2{range_check_ptr}() {
    %{ expect_revert(error_message="Range definition error: low >= high") %}
    SafeCmp.is_in_range_signed(5, 5, 5);
    return ();
}

@view
func test_is_in_range_signed_3{range_check_ptr}() {
    // test when value = low : always TRUE
    let (res_1) = SafeCmp.is_in_range_signed(5, 5, 6);
    assert res_1 = TRUE;

    assert CAIRO_FIELD_ORDER = 0;
    let (res_2) = SafeCmp.is_in_range_signed(CAIRO_FIELD_ORDER, 0, MAX_SIGNED_FELT);
    assert res_2 = TRUE;

    // tests when  low is neg, high and value are positive
    let (res_3) = SafeCmp.is_in_range_signed(1, MAX_UNSIGNED_FELT, MAX_SIGNED_FELT);
    assert res_3 = TRUE;
    let (res_4) = SafeCmp.is_in_range_signed(1, -1, 2);
    assert res_4 = TRUE;
    let (res_5) = SafeCmp.is_in_range_signed(2, -1, 2);
    assert res_5 = FALSE;

    // tests when  low and value are neg, high is positive
    let (res_6) = SafeCmp.is_in_range_signed(MAX_UNSIGNED_FELT, CAIRO_FIELD_ORDER - 2, 1);
    assert res_6 = TRUE;
    let (res_7) = SafeCmp.is_in_range_signed(-1, -1, 2);
    assert res_7 = TRUE;
    let (res_8) = SafeCmp.is_in_range_signed(-3, -2, 3);
    assert res_8 = FALSE;

    // tests when  low and high are same sign
    let (res_9) = SafeCmp.is_in_range_signed(-2, MIN_SIGNED_FELT, MAX_UNSIGNED_FELT);
    assert res_9 = TRUE;
    let (res_10) = SafeCmp.is_in_range_signed(1, CAIRO_FIELD_ORDER, MAX_SIGNED_FELT);
    assert res_10 = TRUE;
    let (res_11) = SafeCmp.is_in_range_signed(CAIRO_FIELD_ORDER, 1, MAX_SIGNED_FELT);
    assert res_11 = FALSE;
    let (res_12) = SafeCmp.is_in_range_signed(MAX_UNSIGNED_FELT, MIN_SIGNED_FELT, -2);
    assert res_12 = FALSE;

    return ();
}

@view
func test_assert_nn_signed_1{range_check_ptr}() {
    SafeCmp.assert_nn_signed(0);
    SafeCmp.assert_nn_signed(CAIRO_FIELD_ORDER + 1);
    SafeCmp.assert_nn_signed(MAX_SIGNED_FELT);
    return ();
}

@view
func test_assert_nn_signed_2{range_check_ptr}() {
    %{ expect_revert() %}
    SafeCmp.assert_nn_signed(MIN_SIGNED_FELT);
    return ();
}

@view
func test_assert_nn_signed_3{range_check_ptr}() {
    %{ expect_revert() %}
    SafeCmp.assert_nn_signed(MAX_UNSIGNED_FELT);
    return ();
}

@view
func test_assert_nn_signed_4{range_check_ptr}() {
    %{ expect_revert() %}
    SafeCmp.assert_nn_signed(-1);
    return ();
}

@view
func test_assert_le_signed_1{range_check_ptr}() {
    // tests when a = b
    SafeCmp.assert_le_signed(1, 1);
    SafeCmp.assert_le_signed(-1, -1);
    SafeCmp.assert_le_signed(CAIRO_FIELD_ORDER, 0);

    // tests when a is neg and b non neg (always TRUE)
    SafeCmp.assert_le_signed(MIN_SIGNED_FELT, 2);
    SafeCmp.assert_le_signed(-1, 5);

    // tests when a and b are the same sign
    SafeCmp.assert_le_signed(CAIRO_FIELD_ORDER + 1, MAX_SIGNED_FELT);
    SafeCmp.assert_le_signed(MIN_SIGNED_FELT, MAX_UNSIGNED_FELT);
    return ();
}

@view
func test_assert_le_signed_2{range_check_ptr}() {
    // tests when a is non negative and b neg (reverts)
    %{ expect_revert() %}
    SafeCmp.assert_le_signed(3, -1);
    return ();
}

@view
func test_assert_le_signed_3{range_check_ptr}() {
    // tests when a is non negative and b neg (reverts)
    %{ expect_revert() %}
    SafeCmp.assert_le_signed(1, MIN_SIGNED_FELT);
    return ();
}

@view
func test_assert_lt_signed_1{range_check_ptr}() {
    // tests when a = b : expects revert
    %{ expect_revert() %}
    SafeCmp.assert_lt_signed(1, 1);
    return ();
}

@view
func test_assert_lt_signed_2{range_check_ptr}() {
    // tests when a = b : expects revert
    %{ expect_revert() %}
    SafeCmp.assert_lt_signed(CAIRO_FIELD_ORDER, 0);
    return ();
}

func test_assert_lt_signed_3{range_check_ptr}() {
    // tests when a is neg and b non neg (always TRUE)
    SafeCmp.assert_lt_signed(MIN_SIGNED_FELT, 2);
    SafeCmp.assert_lt_signed(-1, 5);

    // tests when a and b are the same sign
    SafeCmp.assert_lt_signed(CAIRO_FIELD_ORDER + 1, MAX_SIGNED_FELT);
    SafeCmp.assert_lt_signed(MIN_SIGNED_FELT, MAX_UNSIGNED_FELT);
    return ();
}

@view
func test_assert_lt_signed_4{range_check_ptr}() {
    // tests when a is non negative and b neg (reverts)
    %{ expect_revert() %}
    SafeCmp.assert_lt_signed(3, -1);
    return ();
}

@view
func test_assert_lt_signed_5{range_check_ptr}() {
    // tests when a is non negative and b neg (reverts)
    %{ expect_revert() %}
    SafeCmp.assert_lt_signed(1, MIN_SIGNED_FELT);
    return ();
}

@view
func test_assert_in_range_signed_1{range_check_ptr}() {
    // tests when high is lower or equal that low (reverts)
    %{ expect_revert() %}
    SafeCmp.assert_in_range_signed(1, MAX_UNSIGNED_FELT, MIN_SIGNED_FELT);
    return ();
}

@view
func test_assert_in_range_signed_2{range_check_ptr}() {
    // tests when high is lower or equal that low (reverts)
    %{ expect_revert() %}
    SafeCmp.assert_in_range_signed(1, 1, -1);
    return ();
}

@view
func test_assert_in_range_signed_3{range_check_ptr}() {
    // tests when value is equal to lower : always TRUE
    SafeCmp.assert_in_range_signed(1, 1, 10);
    SafeCmp.assert_in_range_signed(CAIRO_FIELD_ORDER + 1, CAIRO_FIELD_ORDER + 1, MAX_SIGNED_FELT);
    SafeCmp.assert_in_range_signed(MAX_UNSIGNED_FELT, MAX_UNSIGNED_FELT, MAX_SIGNED_FELT);

    // tests when low is neg, high and value are positive
    SafeCmp.assert_in_range_signed(1, MAX_UNSIGNED_FELT, MAX_SIGNED_FELT);
    SafeCmp.assert_in_range_signed(1, -1, 2);

    // tests when  low and value are neg, high is positive
    SafeCmp.assert_in_range_signed(MAX_UNSIGNED_FELT, CAIRO_FIELD_ORDER - 2, 1);
    SafeCmp.assert_in_range_signed(-1, -1, 2);

    // tests when  low and high are same sign
    SafeCmp.assert_in_range_signed(-2, MIN_SIGNED_FELT, MAX_UNSIGNED_FELT);
    SafeCmp.assert_in_range_signed(1, CAIRO_FIELD_ORDER, MAX_SIGNED_FELT);

    return ();
}

func test_assert_in_range_signed_4{range_check_ptr}() {
    // reverts when low is neg, value and high are positive but value not lower than high
    %{ expect_revert() %}
    SafeCmp.assert_in_range_signed(2, -1, 2);
    return ();
}

func test_assert_in_range_signed_5{range_check_ptr}() {
    // reverts when low and value are neg, high is positive but value lower than low
    %{ expect_revert() %}
    SafeCmp.assert_in_range_signed(-3, -2, 3);
    return ();
}

func test_assert_in_range_signed_6{range_check_ptr}() {
    // reverts when low and high are same sign
    %{ expect_revert() %}
    SafeCmp.assert_in_range_signed(CAIRO_FIELD_ORDER, 1, MAX_SIGNED_FELT);
    return ();
}

func test_assert_in_range_signed_7{range_check_ptr}() {
    // reverts when low and high are same sign
    %{ expect_revert() %}
    SafeCmp.assert_in_range_signed(MAX_UNSIGNED_FELT, MIN_SIGNED_FELT, -2);
    return ();
}
