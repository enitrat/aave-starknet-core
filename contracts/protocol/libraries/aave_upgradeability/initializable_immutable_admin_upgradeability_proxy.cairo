%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.bool import FALSE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_not_zero
from starkware.starknet.common.syscalls import library_call, library_call_l1_handler

from contracts.protocol.libraries.aave_upgradeability.proxy_library import Proxy
from contracts.protocol.libraries.helpers.errors import Errors

//
// Constructor
//

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    proxy_admin: felt
) {
    let error_code = Errors.ZERO_ADDRESS_NOT_VALID;
    with_attr error_message("{error_code}") {
        assert_not_zero(proxy_admin);
    }
    Proxy._set_admin(proxy_admin);
    return ();
}

@external
func initialize{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    implementation_class_hash: felt, selector: felt, calldata_len: felt, calldata: felt*
) -> (retdata_len: felt, retdata: felt*) {
    alloc_locals;
    Proxy.assert_only_admin();
    let (is_initialized) = Proxy.get_initialized();

    with_attr error_message("Already initialized") {
        assert is_initialized = FALSE;
    }
    Proxy._set_initialized();
    // set implementation
    Proxy._set_implementation_hash(implementation_class_hash);

    if (calldata_len == 0) {
        let (local empty_calldata: felt*) = alloc();
        return (0, empty_calldata);
    } else {
        let (retdata_len: felt, retdata: felt*) = library_call(
            class_hash=implementation_class_hash,
            function_selector=selector,
            calldata_size=calldata_len,
            calldata=calldata,
        );
        return (retdata_len=retdata_len, retdata=retdata);
    }
}

@external
func upgrade_to_and_call{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    implementation_class_hash: felt, selector: felt, calldata_len: felt, calldata: felt*
) -> (retdata_len: felt, retdata: felt*) {
    Proxy.assert_only_admin();
    // set implementation
    Proxy._set_implementation_hash(implementation_class_hash);

    // library_call
    let (retdata_len: felt, retdata: felt*) = library_call(
        class_hash=implementation_class_hash,
        function_selector=selector,
        calldata_size=calldata_len,
        calldata=calldata,
    );

    return (retdata_len=retdata_len, retdata=retdata);
}

@external
func upgrade_to{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    implementation_class_hash: felt
) {
    Proxy.assert_only_admin();
    Proxy._set_implementation_hash(implementation_class_hash);
    return ();
}

//
// Getters
//

@view
func get_admin{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (admin: felt) {
    let (admin) = Proxy.get_admin();
    return (admin,);
}

@view
func get_implementation{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    implementation: felt
) {
    let (implementation) = Proxy.get_implementation_hash();
    return (implementation,);
}

//
// Setters
//

@external
func change_proxy_admin{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    new_admin: felt
) {
    Proxy.assert_only_admin();
    let error_code = Errors.ZERO_ADDRESS_NOT_VALID;
    with_attr error_message("{error_code}") {
        assert_not_zero(new_admin);
    }

    Proxy._set_admin(new_admin);

    return ();
}

//
// Fallback functions
//

@external
@raw_input
@raw_output
func __default__{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    selector: felt, calldata_size: felt, calldata: felt*
) -> (retdata_size: felt, retdata: felt*) {
    // Only fall back when the sender is not the admin.
    Proxy.assert_not_admin();
    let (implementation_class_hash) = Proxy.get_implementation_hash();
    with_attr error_message("Proxy: does not have a class hash.") {
        assert_not_zero(implementation_class_hash);
    }

    let (retdata_size: felt, retdata: felt*) = library_call(
        class_hash=implementation_class_hash,
        function_selector=selector,
        calldata_size=calldata_size,
        calldata=calldata,
    );

    return (retdata_size=retdata_size, retdata=retdata);
}

@l1_handler
@raw_input
func __l1_default__{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    selector: felt, calldata_size: felt, calldata: felt*
) {
    Proxy.assert_not_admin();
    let (implementation_class_hash) = Proxy.get_implementation_hash();
    with_attr error_message("Proxy: does not have a class hash.") {
        assert_not_zero(implementation_class_hash);
    }

    library_call_l1_handler(
        class_hash=implementation_class_hash,
        function_selector=selector,
        calldata_size=calldata_size,
        calldata=calldata,
    );

    return ();
}
