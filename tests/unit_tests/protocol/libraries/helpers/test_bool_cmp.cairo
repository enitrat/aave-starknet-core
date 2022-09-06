%lang starknet

from starkware.cairo.common.bool import TRUE, FALSE

from contracts.protocol.libraries.helpers.bool_cmp import BoolCmp

@external
func test_is_valid{range_check_ptr}():
    BoolCmp.is_valid(0)
    BoolCmp.is_valid(1)
    %{ expect_revert(error_message="Value should be either 0 or 1. Current value: 2") %}
    BoolCmp.is_valid(2)
    return ()
end

@external
func test_eq{range_check_ptr}():
    let (true) = BoolCmp.eq(0, 0)
    let (false) = BoolCmp.eq(1, 0)
    assert true = TRUE
    assert false = FALSE
    return ()
end

@external
func test_either{range_check_ptr}():
    let (false) = BoolCmp.either(0, 0)
    let (true_1) = BoolCmp.either(1, 1)
    let (true_2) = BoolCmp.either(1, 0)
    assert true_1 = TRUE
    assert true_2 = TRUE
    assert false = FALSE
    return ()
end

@external
func test_both{range_check_ptr}():
    let (true) = BoolCmp.both(1, 1)
    let (false_1) = BoolCmp.both(1, 0)
    let (false_2) = BoolCmp.both(0, 1)
    let (false_3) = BoolCmp.both(0, 0)
    assert true = TRUE
    assert false_1 = FALSE
    assert false_2 = FALSE
    assert false_3 = FALSE
    return ()
end

@external
func test_not{range_check_ptr}():
    let (true) = BoolCmp.not(0)
    let (false) = BoolCmp.not(1)
    assert true = TRUE
    assert false = FALSE
    return ()
end
