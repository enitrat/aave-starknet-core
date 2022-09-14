%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin

from contracts.protocol.configuration.price_oracle_sentinel_library import PriceOracleSentinel

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    addresses_provider: felt, oracle_sentinel: felt, grace_period: felt
) {
    PriceOracleSentinel.initializer(addresses_provider, oracle_sentinel, grace_period);
    return ();
}

@view
func is_borrow_allowed{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    bool: felt
) {
    return PriceOracleSentinel.is_borrow_allowed();
}

@view
func is_liquidation_allowed{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    bool: felt
) {
    return PriceOracleSentinel.is_liquidation_allowed();
}

@external
func set_sequencer_oracle{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    new_sequencer_oracle: felt
) -> () {
    PriceOracleSentinel.set_sequencer_oracle(new_sequencer_oracle);
    return ();
}

@external
func set_grace_period{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    new_grace_period: felt
) -> () {
    PriceOracleSentinel.set_grace_period(new_grace_period);
    return ();
}

@view
func get_sequencer_oracle{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    sequencer_oracle: felt
) {
    return PriceOracleSentinel.get_sequencer_oracle();
}

@view
func get_grace_period{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    grace_period: felt
) {
    return PriceOracleSentinel.get_grace_period();
}

@view
func ADDRESSES_PROVIDER{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    addresses_provider: felt
) {
    return PriceOracleSentinel.ADDRESSES_PROVIDER();
}
