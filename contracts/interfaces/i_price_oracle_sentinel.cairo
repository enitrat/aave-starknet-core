%lang starknet

@contract_interface
namespace IPriceOracleSentinel {
    func ADDRESSES_PROVIDER() -> (provider: felt) {
    }

    func is_borrow_allowed() -> (bool: felt) {
    }

    func is_liquidation_allowed() -> (bool: felt) {
    }

    func set_sequencer_oracle(new_sequencer_oracle: felt) {
    }

    func set_grace_period(new_grace_period: felt) {
    }

    func get_sequencer_oracle() -> (sequencer_oracle: felt) {
    }

    func get_grace_period() -> (grace_period: felt) {
    }
}
