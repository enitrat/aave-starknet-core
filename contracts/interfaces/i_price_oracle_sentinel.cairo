%lang starknet

@contract_interface
namespace IPriceOracleSentinel:
    func ADDRESSES_PROVIDER() -> (provider : felt):
    end

    func is_borrow_allowed() -> (bool : felt):
    end

    func is_liquidation_allowed() -> (bool : felt):
    end

    func set_sequencer_oracle(new_sequencer_oracle : felt):
    end

    func set_grace_period(new_grace_period : felt):
    end

    func get_sequencer_oracle() -> (sequencer_oracle : felt):
    end

    func get_grace_period() -> (grace_period : felt):
    end
end
