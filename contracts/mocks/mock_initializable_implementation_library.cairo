%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin

from contracts.protocol.libraries.aave_upgradeability.versioned_initializable_library import (
    VersionedInitializable,
)

from starkware.cairo.common.math_cmp import is_le

const REVISION_V1 = 1;
const REVISION_V2 = 2;

@storage_var
func value() -> (val: felt) {
}

@storage_var
func text() -> (txt: felt) {
}

namespace MockInitializableImplementation {
    func initialize{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        val: felt, txt: felt
    ) {
        VersionedInitializable.initializer(REVISION_V1);
        value.write(val);
        text.write(txt);
        return ();
    }

    func get_value{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        value: felt
    ) {
        let (val) = value.read();
        return (val,);
    }

    func get_revision{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        revision: felt
    ) {
        return (REVISION_V1,);
    }

    func get_text{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        text: felt
    ) {
        let (txt) = text.read();
        return (txt,);
    }

    func set_value{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        new_value: felt
    ) {
        value.write(new_value);
        return ();
    }

    func set_value_via_proxy{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        new_value: felt
    ) {
        value.write(new_value);
        return ();
    }
}

namespace MockInitializableImplementationV2 {
    func initialize{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        val: felt, txt: felt
    ) {
        VersionedInitializable.initializer(REVISION_V2);
        value.write(val);
        text.write(txt);
        return ();
    }

    func get_revision{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        revision: felt
    ) {
        return (REVISION_V2,);
    }
}

namespace MockInitializableReentrant {
    func initialize{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(val: felt) {
        alloc_locals;
        VersionedInitializable.initializer(REVISION_V2);
        value.write(val);
        let is_value_lt_2 = is_le(val, 1);
        if (is_value_lt_2 == 1) {
            initialize(val + 1);
            tempvar syscall_ptr = syscall_ptr;
            tempvar pedersen_ptr = pedersen_ptr;
            tempvar range_check_ptr = range_check_ptr;
        } else {
            tempvar syscall_ptr = syscall_ptr;
            tempvar pedersen_ptr = pedersen_ptr;
            tempvar range_check_ptr = range_check_ptr;
        }
        return ();
    }

    func get_revision{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        revision: felt
    ) {
        return (REVISION_V2,);
    }
}
