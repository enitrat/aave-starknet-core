%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from openzeppelin.access.ownable.library import Ownable
from contracts.mocks.oracle.sequencer_oracle_library import SequencerOracle

const PRANK_PROVIDER = 100;
const TEST_IS_DOWN = 1;
const TEST_TIMESTAMP = 123456789;

@view
func test_sequencer_oracle{syscall_ptr: felt*, range_check_ptr, pedersen_ptr: HashBuiltin*}() {
    Ownable.initializer(PRANK_PROVIDER);
    %{ prank_owner = start_prank(ids.PRANK_PROVIDER) %}
    SequencerOracle.initializer(PRANK_PROVIDER);
    Ownable.assert_only_owner();
    let (_, is_down_before, _, timestamp_before, _) = SequencerOracle.latest_round_data();
    assert is_down_before = 0;
    assert timestamp_before = 0;
    SequencerOracle.set_answer(TEST_IS_DOWN, TEST_TIMESTAMP);
    let (_, is_down_after, _, timestamp_after, _) = SequencerOracle.latest_round_data();
    assert is_down_after = TEST_IS_DOWN;
    assert timestamp_after = TEST_TIMESTAMP;
    %{ prank_owner() %}
    return ();
}

@view
func test_initializer{syscall_ptr: felt*, range_check_ptr, pedersen_ptr: HashBuiltin*}() {
    Ownable.initializer(PRANK_PROVIDER);
    %{ prank_owner = start_prank(ids.PRANK_PROVIDER) %}
    SequencerOracle.initializer(PRANK_PROVIDER);
    Ownable.assert_only_owner();
    %{ prank_owner() %}
    return ();
}
