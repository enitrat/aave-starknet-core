%lang starknet

from starkware.cairo.common.bool import FALSE, TRUE

from contracts.protocol.libraries.math.safecmp import SafeCmp

# Max value when felt interpreted as signed integer
const signed_MAX = SafeCmp.signed_MIN - 1
# Max value when felt interpreted as unsigned integer
const unsigned_MAX = SafeCmp.P - 1

@view
func test_P{range_check_ptr}():
    assert signed_MAX = -SafeCmp.signed_MIN
    return ()
end

@view
func test_is_le_unsigned{range_check_ptr}():
    # Regular tests
    let (res_1) = SafeCmp.is_le_unsigned(1, 2)
    assert res_1 = TRUE
    let (res_2) = SafeCmp.is_le_unsigned(2, 2)
    assert res_2 = TRUE
    let (res_3) = SafeCmp.is_le_unsigned(3, 2)
    assert res_3 = FALSE

    # check boundaries
    let (res_4) = SafeCmp.is_le_unsigned(signed_MAX, SafeCmp.signed_MIN)
    assert res_4 = TRUE
    let (res_5) = SafeCmp.is_le_unsigned(0, SafeCmp.signed_MIN)
    assert res_5 = TRUE
    let (res_6) = SafeCmp.is_le_unsigned(SafeCmp.signed_MIN, unsigned_MAX)
    assert res_6 = TRUE
    let (res_7) = SafeCmp.is_le_unsigned(0, unsigned_MAX)
    assert res_7 = TRUE
    return ()
end

@view
func test_is_lt_unsigned{range_check_ptr}():
    # Regular tests
    let (res_1) = SafeCmp.is_lt_unsigned(1, 2)
    assert res_1 = TRUE
    let (res_2) = SafeCmp.is_lt_unsigned(2, 2)
    assert res_2 = FALSE
    let (res_3) = SafeCmp.is_lt_unsigned(3, 2)
    assert res_3 = FALSE

    # check boundaries
    let (res_4) = SafeCmp.is_lt_unsigned(signed_MAX, SafeCmp.signed_MIN)
    assert res_4 = TRUE
    let (res_5) = SafeCmp.is_lt_unsigned(0, SafeCmp.signed_MIN)
    assert res_5 = TRUE
    let (res_6) = SafeCmp.is_lt_unsigned(SafeCmp.signed_MIN, unsigned_MAX)
    assert res_6 = TRUE
    let (res_7) = SafeCmp.is_lt_unsigned(0, unsigned_MAX)
    assert res_7 = TRUE

    return ()
end

@view
func test_is_in_range_unsigned{range_check_ptr}():
    let (res_1) = SafeCmp.is_in_range_unsigned(3, 0, 5)
    assert res_1 = TRUE
    let (res_2) = SafeCmp.is_in_range_unsigned(3, 3, 5)
    assert res_2 = TRUE
    let (res_3) = SafeCmp.is_in_range_unsigned(5, 3, 5)
    assert res_3 = FALSE
    let (res_4) = SafeCmp.is_in_range_unsigned(6, 0, 2)
    assert res_4 = FALSE

    %{ expect_revert(error_message="Range definition error: low >= high") %}
    SafeCmp.is_in_range_unsigned(3, 7, 2)
    return ()
end

@view
func test_assert_le_unsigned_1{range_check_ptr}():
    %{ expect_revert() %}
    SafeCmp.assert_le_unsigned(unsigned_MAX, SafeCmp.signed_MIN)
    return ()
end

@view
func test_assert_le_unsigned_2{range_check_ptr}():
    %{ expect_revert() %}
    SafeCmp.assert_le_unsigned(SafeCmp.signed_MIN, 0)
    return ()
end

@view
func test_assert_le_unsigned_3{range_check_ptr}():
    SafeCmp.assert_le_unsigned(SafeCmp.signed_MIN, SafeCmp.signed_MIN)
    SafeCmp.assert_le_unsigned(SafeCmp.signed_MIN, unsigned_MAX)
    return ()
end

@view
func test_assert_lt_unsigned_1{range_check_ptr}():
    %{ expect_revert() %}
    SafeCmp.assert_lt_unsigned(unsigned_MAX, SafeCmp.signed_MIN)
    return ()
end

@view
func test_assert_lt_unsigned_2{range_check_ptr}():
    %{ expect_revert() %}
    SafeCmp.assert_lt_unsigned(SafeCmp.signed_MIN, 0)
    return ()
end

@view
func test_assert_lt_unsigned_3{range_check_ptr}():
    %{ expect_revert() %}
    SafeCmp.assert_lt_unsigned(SafeCmp.signed_MIN, SafeCmp.signed_MIN)
    return ()
end

@view
func test_assert_lt_unsigned_4{range_check_ptr}():
    SafeCmp.assert_lt_unsigned(SafeCmp.signed_MIN, unsigned_MAX)
    SafeCmp.assert_lt_unsigned(1, 2)
    return ()
end

@view
func test_assert_in_range_unsigned_1{range_check_ptr}():
    %{ expect_revert(error_message="Range definition error: low >= high") %}
    SafeCmp.assert_in_range_unsigned(SafeCmp.signed_MIN, unsigned_MAX, SafeCmp.signed_MIN)
    return ()
end

@view
func test_assert_in_range_unsigned_2{range_check_ptr}():
    %{ expect_revert() %}
    SafeCmp.assert_in_range_unsigned(unsigned_MAX, 0, SafeCmp.signed_MIN)
    return ()
end

@view
func test_assert_in_range_unsigned_3{range_check_ptr}():
    %{ expect_revert() %}
    SafeCmp.assert_in_range_unsigned(SafeCmp.signed_MIN, 0, SafeCmp.signed_MIN)
    return ()
end

@view
func test_assert_in_range_unsigned_4{range_check_ptr}():
    SafeCmp.assert_in_range_unsigned(SafeCmp.signed_MIN, SafeCmp.signed_MIN, unsigned_MAX)
    SafeCmp.assert_in_range_unsigned(SafeCmp.signed_MIN, 0, unsigned_MAX)
    SafeCmp.assert_in_range_unsigned(1, 0, 2)
    return ()
end

@view
func test_is_nn_signed{range_check_ptr}():
    # False results
    let (res_1) = SafeCmp.is_nn_signed(SafeCmp.signed_MIN)
    assert res_1 = FALSE
    let (res_2) = SafeCmp.is_nn_signed(unsigned_MAX)
    assert res_2 = FALSE
    let (res_3) = SafeCmp.is_nn_signed(-1)
    assert res_3 = FALSE

    # True results
    let (res_4) = SafeCmp.is_nn_signed(signed_MAX)
    assert res_4 = TRUE
    let (res_5) = SafeCmp.is_nn_signed(0)
    assert res_5 = TRUE

    return ()
end

@view
func test_is_le_signed{range_check_ptr}():
    # tests when a = b
    let (res_1) = SafeCmp.is_le_signed(1, 1)
    assert res_1 = TRUE
    let (res_2) = SafeCmp.is_le_signed(-1, -1)
    assert res_2 = TRUE
    let (res_3) = SafeCmp.is_le_signed(SafeCmp.signed_MIN, SafeCmp.signed_MIN)
    assert res_3 = TRUE

    # tests when a is non negative and b neg (always FALSE)
    let (res_4) = SafeCmp.is_le_signed(3, -1)
    assert res_4 = FALSE
    let (res_5) = SafeCmp.is_le_signed(1, SafeCmp.signed_MIN)
    assert res_5 = FALSE

    # tests when a is neg and b non neg (always TRUE)
    let (res_6) = SafeCmp.is_le_signed(SafeCmp.signed_MIN, 2)
    assert res_6 = TRUE
    let (res_7) = SafeCmp.is_le_signed(-1, 5)
    assert res_7 = TRUE

    # tests when a and b are the same sign
    let (res_8) = SafeCmp.is_le_signed(SafeCmp.P + 1, signed_MAX)
    assert res_8 = TRUE
    let (res_9) = SafeCmp.is_le_signed(3, 2)
    assert res_9 = FALSE
    let (res_10) = SafeCmp.is_le_signed(signed_MAX, SafeCmp.P + 1)
    assert res_10 = FALSE
    let (res_11) = SafeCmp.is_le_signed(unsigned_MAX, SafeCmp.signed_MIN)
    assert res_11 = FALSE
    let (res_12) = SafeCmp.is_le_signed(SafeCmp.signed_MIN, unsigned_MAX)
    assert res_12 = TRUE

    return ()
end

@view
func test_is_lt_signed{range_check_ptr}():
    # tests when a = b
    let (res_1) = SafeCmp.is_lt_signed(1, 1)
    assert res_1 = FALSE
    let (res_2) = SafeCmp.is_lt_signed(-1, -1)
    assert res_2 = FALSE
    let (res_3) = SafeCmp.is_lt_signed(SafeCmp.signed_MIN, SafeCmp.signed_MIN)
    assert res_3 = FALSE

    # tests when a is non negative and b neg (always FALSE)
    let (res_4) = SafeCmp.is_lt_signed(3, -1)
    assert res_4 = FALSE
    let (res_5) = SafeCmp.is_lt_signed(1, SafeCmp.signed_MIN)
    assert res_5 = FALSE

    # tests when a is neg and b non neg (always TRUE)
    let (res_6) = SafeCmp.is_lt_signed(SafeCmp.signed_MIN, 2)
    assert res_6 = TRUE
    let (res_7) = SafeCmp.is_lt_signed(-1, 5)
    assert res_7 = TRUE

    # tests when a and b are the same sign
    let (res_8) = SafeCmp.is_lt_signed(SafeCmp.P + 1, signed_MAX)
    assert res_8 = TRUE
    let (res_9) = SafeCmp.is_lt_signed(3, 2)
    assert res_9 = FALSE
    let (res_10) = SafeCmp.is_lt_signed(signed_MAX, SafeCmp.P + 1)
    assert res_10 = FALSE
    let (res_11) = SafeCmp.is_lt_signed(unsigned_MAX, SafeCmp.signed_MIN)
    assert res_11 = FALSE
    let (res_12) = SafeCmp.is_lt_signed(SafeCmp.signed_MIN, unsigned_MAX)
    assert res_12 = TRUE

    return ()
end

@view
func test_is_in_range_signed_1{range_check_ptr}():
    %{ expect_revert(error_message="Range definition error: low >= high") %}
    SafeCmp.is_in_range_signed(5, 5, 3)
    return ()
end

@view
func test_is_in_range_signed_2{range_check_ptr}():
    %{ expect_revert(error_message="Range definition error: low >= high") %}
    SafeCmp.is_in_range_signed(5, 5, 5)
    return ()
end

@view
func test_is_in_range_signed_3{range_check_ptr}():
    # test when value = low : always TRUE
    let (res_1) = SafeCmp.is_in_range_signed(5, 5, 6)
    assert res_1 = TRUE

    assert SafeCmp.P = 0
    let (res_2) = SafeCmp.is_in_range_signed(SafeCmp.P, 0, signed_MAX)
    assert res_2 = TRUE

    # tests when  low is neg, high and value are positive
    let (res_3) = SafeCmp.is_in_range_signed(1, unsigned_MAX, signed_MAX)
    assert res_3 = TRUE
    let (res_4) = SafeCmp.is_in_range_signed(1, -1, 2)
    assert res_4 = TRUE
    let (res_5) = SafeCmp.is_in_range_signed(2, -1, 2)
    assert res_5 = FALSE

    # tests when  low and value are neg, high is positive
    let (res_6) = SafeCmp.is_in_range_signed(unsigned_MAX, SafeCmp.P - 2, 1)
    assert res_6 = TRUE
    let (res_7) = SafeCmp.is_in_range_signed(-1, -1, 2)
    assert res_7 = TRUE
    let (res_8) = SafeCmp.is_in_range_signed(-3, -2, 3)
    assert res_8 = FALSE

    # tests when  low and high are same sign
    let (res_9) = SafeCmp.is_in_range_signed(-2, SafeCmp.signed_MIN, unsigned_MAX)
    assert res_9 = TRUE
    let (res_10) = SafeCmp.is_in_range_signed(1, SafeCmp.P, signed_MAX)
    assert res_10 = TRUE
    let (res_11) = SafeCmp.is_in_range_signed(SafeCmp.P, 1, signed_MAX)
    assert res_11 = FALSE
    let (res_12) = SafeCmp.is_in_range_signed(unsigned_MAX, SafeCmp.signed_MIN, -2)
    assert res_12 = FALSE

    return ()
end

@view
func test_assert_nn_signed_1{range_check_ptr}():
    SafeCmp.assert_nn_signed(0)
    SafeCmp.assert_nn_signed(SafeCmp.P + 1)
    SafeCmp.assert_nn_signed(signed_MAX)
    return ()
end

@view
func test_assert_nn_signed_2{range_check_ptr}():
    %{ expect_revert() %}
    SafeCmp.assert_nn_signed(SafeCmp.signed_MIN)
    return ()
end

@view
func test_assert_nn_signed_3{range_check_ptr}():
    %{ expect_revert() %}
    SafeCmp.assert_nn_signed(unsigned_MAX)
    return ()
end

@view
func test_assert_nn_signed_4{range_check_ptr}():
    %{ expect_revert() %}
    SafeCmp.assert_nn_signed(-1)
    return ()
end

@view
func test_assert_le_signed_1{range_check_ptr}():
    # tests when a = b
    SafeCmp.assert_le_signed(1, 1)
    SafeCmp.assert_le_signed(-1, -1)
    SafeCmp.assert_le_signed(SafeCmp.P, 0)

    # tests when a is neg and b non neg (always TRUE)
    SafeCmp.assert_le_signed(SafeCmp.signed_MIN, 2)
    SafeCmp.assert_le_signed(-1, 5)

    # tests when a and b are the same sign
    SafeCmp.assert_le_signed(SafeCmp.P + 1, signed_MAX)
    SafeCmp.assert_le_signed(SafeCmp.signed_MIN, unsigned_MAX)
    return ()
end

@view
func test_assert_le_signed_2{range_check_ptr}():
    # tests when a is non negative and b neg (reverts)
    %{ expect_revert() %}
    SafeCmp.assert_le_signed(3, -1)
    return ()
end

@view
func test_assert_le_signed_3{range_check_ptr}():
    # tests when a is non negative and b neg (reverts)
    %{ expect_revert() %}
    SafeCmp.assert_le_signed(1, SafeCmp.signed_MIN)
    return ()
end

@view
func test_assert_lt_signed_1{range_check_ptr}():
    # tests when a = b : expects revert
    %{ expect_revert() %}
    SafeCmp.assert_lt_signed(1, 1)
    return ()
end

@view
func test_assert_lt_signed_2{range_check_ptr}():
    # tests when a = b : expects revert
    %{ expect_revert() %}
    SafeCmp.assert_lt_signed(SafeCmp.P, 0)
    return ()
end

func test_assert_lt_signed_3{range_check_ptr}():
    # tests when a is neg and b non neg (always TRUE)
    SafeCmp.assert_lt_signed(SafeCmp.signed_MIN, 2)
    SafeCmp.assert_lt_signed(-1, 5)

    # tests when a and b are the same sign
    SafeCmp.assert_lt_signed(SafeCmp.P + 1, signed_MAX)
    SafeCmp.assert_lt_signed(SafeCmp.signed_MIN, unsigned_MAX)
    return ()
end

@view
func test_assert_lt_signed_4{range_check_ptr}():
    # tests when a is non negative and b neg (reverts)
    %{ expect_revert() %}
    SafeCmp.assert_lt_signed(3, -1)
    return ()
end

@view
func test_assert_lt_signed_5{range_check_ptr}():
    # tests when a is non negative and b neg (reverts)
    %{ expect_revert() %}
    SafeCmp.assert_lt_signed(1, SafeCmp.signed_MIN)
    return ()
end

@view
func test_assert_in_range_signed_1{range_check_ptr}():
    # tests when high is lower or equal that low (reverts)
    %{ expect_revert() %}
    SafeCmp.assert_in_range_signed(1, unsigned_MAX, SafeCmp.signed_MIN)
    return ()
end

@view
func test_assert_in_range_signed_2{range_check_ptr}():
    # tests when high is lower or equal that low (reverts)
    %{ expect_revert() %}
    SafeCmp.assert_in_range_signed(1, 1, -1)
    return ()
end

@view
func test_assert_in_range_signed_3{range_check_ptr}():
    # tests when value is equal to lower : always TRUE
    SafeCmp.assert_in_range_signed(1, 1, 10)
    SafeCmp.assert_in_range_signed(SafeCmp.P + 1, SafeCmp.P + 1, signed_MAX)
    SafeCmp.assert_in_range_signed(unsigned_MAX, unsigned_MAX, signed_MAX)

    # tests when low is neg, high and value are positive
    SafeCmp.assert_in_range_signed(1, unsigned_MAX, signed_MAX)
    SafeCmp.assert_in_range_signed(1, -1, 2)

    # tests when  low and value are neg, high is positive
    SafeCmp.assert_in_range_signed(unsigned_MAX, SafeCmp.P - 2, 1)
    SafeCmp.assert_in_range_signed(-1, -1, 2)

    # tests when  low and high are same sign
    SafeCmp.assert_in_range_signed(-2, SafeCmp.signed_MIN, unsigned_MAX)
    SafeCmp.assert_in_range_signed(1, SafeCmp.P, signed_MAX)

    return ()
end

func test_assert_in_range_signed_4{range_check_ptr}():
    # reverts when low is neg, value and high are positive but value not lower than high
    %{ expect_revert() %}
    SafeCmp.assert_in_range_signed(2, -1, 2)
    return ()
end

func test_assert_in_range_signed_5{range_check_ptr}():
    # reverts when low and value are neg, high is positive but value lower than low
    %{ expect_revert() %}
    SafeCmp.assert_in_range_signed(-3, -2, 3)
    return ()
end

func test_assert_in_range_signed_6{range_check_ptr}():
    # reverts when low and high are same sign
    %{ expect_revert() %}
    SafeCmp.assert_in_range_signed(SafeCmp.P, 1, signed_MAX)
    return ()
end

func test_assert_in_range_signed_7{range_check_ptr}():
    # reverts when low and high are same sign
    %{ expect_revert() %}
    SafeCmp.assert_in_range_signed(unsigned_MAX, SafeCmp.signed_MIN, -2)
    return ()
end
