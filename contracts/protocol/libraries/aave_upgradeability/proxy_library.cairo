%lang starknet

from starkware.cairo.common.bool import TRUE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_not_zero
from starkware.starknet.common.syscalls import get_caller_address

//
// Events
//

@event
func Upgraded(implementation: felt) {
}

@event
func AdminChanged(previous_admin: felt, new_admin: felt) {
}

//
// Storage variables
//

@storage_var
func Proxy_implementation_hash() -> (class_hash: felt) {
}

@storage_var
func Proxy_admin() -> (proxy_admin: felt) {
}

@storage_var
func Proxy_initialized() -> (initialized: felt) {
}

namespace Proxy {
    //
    // Guards
    //

    func assert_only_admin{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
        let (caller) = get_caller_address();
        let (admin) = Proxy_admin.read();
        with_attr error_message("Proxy: caller is not admin") {
            assert admin = caller;
        }
        return ();
    }

    func assert_not_admin{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
        let (caller) = get_caller_address();
        let (admin) = Proxy_admin.read();
        with_attr error_message("Proxy: caller is admin") {
            assert_not_zero(admin - caller);
        }
        return ();
    }

    //
    // Getters
    //

    func get_implementation_hash{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        ) -> (implementation: felt) {
        let (implementation) = Proxy_implementation_hash.read();
        return (implementation,);
    }

    func get_initialized{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        implementation: felt
    ) {
        let (initialized) = Proxy_initialized.read();

        return (initialized,);
    }

    func get_admin{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        admin: felt
    ) {
        let (admin) = Proxy_admin.read();
        return (admin,);
    }

    //
    // Unprotected
    //

    func _set_admin{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        new_admin: felt
    ) {
        let (previous_admin) = get_admin();
        Proxy_admin.write(new_admin);
        AdminChanged.emit(previous_admin, new_admin);
        return ();
    }

    //
    // Upgrade
    //

    func _set_implementation_hash{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        new_implementation_hash: felt
    ) {
        with_attr error_message("Proxy: implementation hash cannot be zero") {
            assert_not_zero(new_implementation_hash);
        }
        Proxy_implementation_hash.write(new_implementation_hash);
        Upgraded.emit(new_implementation_hash);
        return ();
    }

    func _set_initialized{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
        Proxy_initialized.write(TRUE);
        return ();
    }
}
