%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin

from openzeppelin.access.ownable.library import Ownable

@storage_var
func SequencerOracle_is_down() -> (is_down : felt):
end

@storage_var
func SequencerOracle_timestamp_got_up() -> (timestamp : felt):
end

namespace SequencerOracle:
    func initializer{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        owner : felt
    ):
        # Ownable.transfer_ownership(owner)
        Ownable.initializer(owner)

        return ()
    end

    func set_answer{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        is_down : felt, timestamp : felt
    ):
        Ownable.assert_only_owner()
        SequencerOracle_is_down.write(is_down)
        SequencerOracle_timestamp_got_up.write(timestamp)
        return ()
    end

    func latest_round_data{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
        round_id : felt,
        answer : felt,
        started_at : felt,
        update_at : felt,
        answered_in_round : felt,
    ):
        let (is_down) = SequencerOracle_is_down.read()
        let (ts) = SequencerOracle_timestamp_got_up.read()
        if is_down == 1:
            return (0, 1, 0, ts, 0)
        else:
            return (0, 0, 0, ts, 0)
        end
    end
end
