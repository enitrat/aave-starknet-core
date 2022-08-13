%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin

from contracts.interfaces.i_proxy import IProxy
from contracts.protocol.libraries.helpers.constants import INITIALIZE_SELECTOR
from contracts.mocks.i_mock_initializable_implementation import (
    IMockInitializableImplementation,
    IMockInitializableReentrantImplementation,
)
from contracts.mocks.mock_initializable_implementation_library import (
    MockInitializableImplementation,
)
from tests.utils.constants import USER_1

const INIT_VALUE = 10
const INIT_TEXT = 'text'
const PRANK_USER = 123

#
# VersionedInitializable tests
#

namespace TestVersionedInitializable:
    func test_initialize_when_already_initialized{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }():
        MockInitializableImplementation.initialize(INIT_VALUE, INIT_TEXT)
        %{ expect_revert(error_message="Contract instance has already been initialized") %}
        MockInitializableImplementation.initialize(INIT_VALUE, INIT_TEXT)
        return ()
    end
end

#
# InitializableImmutableAdminUpgradeabilityProxy tests
#
namespace TestInitializableImmutableAdminUpgradeabilityProxy:
    func test_initialize_impl_version_is_correct{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }():
        alloc_locals
        local impl_address
        %{ ids.impl_address = context.proxy %}
        %{ stop_prank_user = start_prank(ids.PRANK_USER, target_contract_address = ids.impl_address) %}
        let (revision) = IMockInitializableImplementation.get_revision(impl_address)
        %{ stop_prank_user() %}
        assert revision = 1
        return ()
    end

    func test_initialize_impl_initialization_is_correct{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }():
        alloc_locals
        local impl_address
        %{ ids.impl_address = context.proxy %}
        %{ stop_prank_user = start_prank(ids.PRANK_USER, target_contract_address = ids.impl_address) %}
        let (value) = IMockInitializableImplementation.get_value(impl_address)
        let (text) = IMockInitializableImplementation.get_text(impl_address)
        %{ stop_prank_user() %}

        assert value = INIT_VALUE
        assert text = INIT_TEXT
        return ()
    end

    func test_initialize_from_non_admin_when_already_initialized{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }():
        alloc_locals
        local impl_address
        local impl_hash
        %{
            ids.impl_address = context.proxy
            ids.impl_hash = context.mock_initializable_v1
            expect_revert(error_message="Contract instance has already been initialized")
        %}
        IProxy.upgrade_to_and_call(
            impl_address,
            impl_hash,
            INITIALIZE_SELECTOR,
            2,
            cast(new (INIT_VALUE, INIT_TEXT), felt*),
        )
        return ()
    end

    func test_upgrade_to_new_impl_from_admin{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }():
        alloc_locals
        local proxy_address
        local new_impl
        %{
            ids.proxy_address = context.proxy
            ids.new_impl = context.mock_initializable_v2
        %}

        # Upgrade from v1 to v2, and initialize v2
        IProxy.upgrade_to_and_call(
            proxy_address, new_impl, INITIALIZE_SELECTOR, 2, cast(new (20, 'new text'), felt*)
        )

        # Check new values of v2 implementation
        %{ stop_prank_user = start_prank(ids.PRANK_USER, target_contract_address = ids.proxy_address) %}
        let (value) = IMockInitializableImplementation.get_value(proxy_address)
        let (text) = IMockInitializableImplementation.get_text(proxy_address)
        %{ stop_prank_user() %}
        assert value = 20
        assert text = 'new text'

        # This initialize fail because we already initialized v2
        %{ expect_revert(error_message="Contract instance has already been initialized") %}
        IProxy.upgrade_to_and_call(
            proxy_address, new_impl, INITIALIZE_SELECTOR, 2, cast(new (30, 100), felt*)
        )
        # IMockInitializableImplementation.initialize(proxy_address, 30, 100)
        return ()
    end

    # TODO further testing is required when InitializableImmutableAdminUpgradeabilityProxy is implemented
end
