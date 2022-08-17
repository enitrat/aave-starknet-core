%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin

from contracts.mocks.oracle.sequencer_oracle_library import SequencerOracle

@constructor
func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(owner : felt):
    SequencerOracle.initializer(owner)
    return ()
end

@external
func set_answer{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    is_down : felt, timestamp : felt
):
    SequencerOracle.set_answer(is_down, timestamp)
    return ()
end

@external
func latest_round_data{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    round_id : felt, answer : felt, started_at : felt, update_at : felt, answered_in_round : felt
):
    return SequencerOracle.latest_round_data()
end
