%lang starknet

@contract_interface
namespace ISequencerOracle:
    func latest_round_data() -> (
        round_id : felt,
        answer : felt,
        started_at : felt,
        update_at : felt,
        answered_in_round : felt,
    ):
    end
end
