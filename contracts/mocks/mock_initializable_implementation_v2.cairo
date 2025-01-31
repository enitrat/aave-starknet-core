%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin

from contracts.mocks.mock_initializable_implementation_library import (
    MockInitializableImplementation,
    MockInitializableImplementationV2,
)

@external
func initialize{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    val: felt, txt: felt
) {
    return MockInitializableImplementationV2.initialize(val, txt);
}

@view
func get_value{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (value: felt) {
    return MockInitializableImplementation.get_value();
}

@view
func get_text{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (text: felt) {
    return MockInitializableImplementation.get_text();
}

@view
func get_revision{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    revision: felt
) {
    return MockInitializableImplementationV2.get_revision();
}

@external
func set_value{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(new_value: felt) {
    MockInitializableImplementation.set_value(new_value);
    return ();
}

@external
func set_value_via_proxy{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    new_value: felt
) {
    MockInitializableImplementation.set_value_via_proxy(new_value);
    return ();
}
