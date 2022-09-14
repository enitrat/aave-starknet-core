%lang starknet

from starkware.starknet.common.syscalls import get_contract_address
from starkware.cairo.common.cairo_builtins import HashBuiltin

from contracts.interfaces.i_proxy import IProxy
from contracts.protocol.libraries.helpers.constants import INITIALIZE_SELECTOR
from tests.test_suites.test_specs.upgradeability_spec import (
    TestVersionedInitializable,
    TestInitializableImmutableAdminUpgradeabilityProxy,
    INIT_VALUE,
    INIT_TEXT,
)

@external
func __setup__{syscall_ptr: felt*, range_check_ptr}() {
    alloc_locals;
    let (deployer) = get_contract_address();
    local proxy_address;
    local mock_initializable_v1;
    %{
        def str_to_felt(text):
            MAX_LEN_FELT = 31
            if len(text) > MAX_LEN_FELT:
                raise Exception("Text length too long to convert to felt.")

            return int.from_bytes(text.encode(), "big")

        # Declare the 3 mock initializable implementations
        context.mock_initializable_v1 = declare("./contracts/mocks/mock_initializable_implementation.cairo").class_hash
        context.mock_initializable_v2 = declare("./contracts/mocks/mock_initializable_implementation_v2.cairo").class_hash
        context.mock_initializable_reentrant = declare("./contracts/mocks/mock_initializable_reentrant.cairo").class_hash

        # Deploy proxy with initializable_v1 as implementation
        context.proxy = deploy_contract("./contracts/protocol/libraries/aave_upgradeability/initializable_immutable_admin_upgradeability_proxy.cairo", {"proxy_admin":ids.deployer}).contract_address

        context.deployer = ids.deployer
        ids.proxy_address = context.proxy
        ids.mock_initializable_v1 = context.mock_initializable_v1
    %}
    IProxy.initialize(
        proxy_address,
        mock_initializable_v1,
        INITIALIZE_SELECTOR,
        2,
        cast(new (INIT_VALUE, INIT_TEXT), felt*),
    );
    return ();
}

//
// VersionedInitializable tests
//

@external
func test_initialize_when_already_initialized{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    TestVersionedInitializable.test_initialize_when_already_initialized();
    return ();
}

//
// InitializableImmutableAdminUpgradeabilityProxy tests
//

@external
func test_initialize_impl_version_is_correct{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    TestInitializableImmutableAdminUpgradeabilityProxy.test_initialize_impl_version_is_correct();
    return ();
}

@external
func test_initialize_impl_initialization_is_correct{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    TestInitializableImmutableAdminUpgradeabilityProxy.test_initialize_impl_initialization_is_correct(
        );
    return ();
}

@external
func test_initialize_from_non_admin_when_already_initialized{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    TestInitializableImmutableAdminUpgradeabilityProxy.test_initialize_from_non_admin_when_already_initialized(
        );
    return ();
}

@external
func test_upgrade_to_new_impl_from_admin{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    TestInitializableImmutableAdminUpgradeabilityProxy.test_upgrade_to_new_impl_from_admin();
    return ();
}
