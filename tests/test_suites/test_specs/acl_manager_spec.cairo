%lang starknet

from starkware.cairo.common.bool import FALSE, TRUE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_not_zero

from openzeppelin.utils.constants.library import DEFAULT_ADMIN_ROLE
from openzeppelin.access.accesscontrol.library import AccessControl

from contracts.interfaces.i_acl_manager import IACLManager
from contracts.protocol.configuration.acl_manager_library import ACLManager, FLASH_BORROWER_ROLE

# prank addresses
const FLASH_BORROW_ADMIN_ADDRESS = 1111
const FLASH_BORROWER_ADDRESS = 4444
const POOL_ADMIN_ADDRESS = 5555
const PRANK_ADMIN_ADDRESS = 2222
const EMERGENCY_ADMIN_ADDRESS = 6666
const PRANK_USER_1 = 3333
const RISK_ADMIN_ADDRESS = 7777
const BRIDGE_ADDRESS = 8888
const ASSET_LISTING_ADMIN_ADDRESS = 9999

# prank roles
const FLASH_BORROW_ADMIN_ROLE = 11
const PRANK_ROLE_2 = 22
const PRANK_ADMIN_ROLE = 99

# Utils funcitons
func get_context{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    acl_address : felt, pool_addresses_provider_address : felt
):
    alloc_locals
    local acl
    local pool_addresses_provider
    %{
        ids.acl = context.acl
        ids.pool_addresses_provider = context.pool_addresses_provider
    %}
    return (acl, pool_addresses_provider)
end

namespace TestACLManager:
    func test_default_admin_role{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        ):
        # Init Context and states
        alloc_locals
        let (local acl, local pool_addresses_provider) = get_context()

        # Check init roles
        let (has_role_deployer) = IACLManager.has_role(acl, DEFAULT_ADMIN_ROLE, PRANK_ADMIN_ADDRESS)
        let (has_role_user_1) = IACLManager.has_role(acl, DEFAULT_ADMIN_ROLE, PRANK_USER_1)
        assert has_role_deployer = TRUE
        assert has_role_user_1 = FALSE
        return ()
    end

    # Grant FLASH_BORROW_ADMIN role to FLASH_BORROW_ADMIN_ADDRESS : OK
    func test_grant_flash_borrow_admin_role{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }():
        # Init Context and states
        alloc_locals
        let (local acl, local pool_addresses_provider) = get_context()
        let (has_flash_borrow_admin_role) = IACLManager.has_role(
            acl, FLASH_BORROW_ADMIN_ROLE, FLASH_BORROW_ADMIN_ADDRESS
        )
        assert has_flash_borrow_admin_role = FALSE

        # Start grant roles : PRANK_ADMIN_ADDRESS gives to FLASH_BORROW_ADMIN_ADDRESS the role of FLASH_BORROW_ADMIN_ROLE
        %{ stop_prank = start_prank(ids.PRANK_ADMIN_ADDRESS, target_contract_address = ids.acl) %}
        IACLManager.grant_role(acl, FLASH_BORROW_ADMIN_ROLE, FLASH_BORROW_ADMIN_ADDRESS)
        %{ stop_prank() %}

        # check final states
        let (has_flash_borrow_admin_role_after) = IACLManager.has_role(
            acl, FLASH_BORROW_ADMIN_ROLE, FLASH_BORROW_ADMIN_ADDRESS
        )
        assert has_flash_borrow_admin_role_after = TRUE

        return ()
    end

    # FLASH_BORROW_ADMIN_ADDRESS grant FLASH_BORROW_ROLE : revert expected because FLASH_BORROW_ADMIN_ADDRESS
    # is not yet admin for FLASH_BORROW_ROLE
    func test_grant_flash_borrow_admin_role_2{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }():
        alloc_locals
        # Init Context and states
        let (local acl, local pool_addresses_provider) = get_context()
        %{ stop_prank = start_prank(ids.PRANK_ADMIN_ADDRESS, target_contract_address = ids.acl) %}
        IACLManager.grant_role(acl, FLASH_BORROW_ADMIN_ROLE, FLASH_BORROW_ADMIN_ADDRESS)
        %{ stop_prank() %}

        # check init states
        let (role) = IACLManager.is_flash_borrower(acl, FLASH_BORROWER_ADDRESS)
        assert role = FALSE
        let (role_admin) = IACLManager.has_role(
            acl, FLASH_BORROW_ADMIN_ROLE, FLASH_BORROW_ADMIN_ADDRESS
        )
        assert role_admin = TRUE

        # Start grant roles
        %{ expect_revert(error_message="AccessControl: caller is missing role "+str(ids.DEFAULT_ADMIN_ROLE)) %}
        %{ stop_prank_call_borrower = start_prank(ids.FLASH_BORROW_ADMIN_ADDRESS, target_contract_address = ids.acl) %}
        IACLManager.add_flash_borrower(acl, FLASH_BORROWER_ADDRESS)
        %{ stop_prank_call_borrower() %}

        return ()
    end

    # Make FLASH_BORROW_ADMIN_ROLE admin of FLASH_BORROWER_ROLE
    func test_grant_flash_borrow_admin_role_3{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }():
        alloc_locals
        # Init Context and states
        let (local acl, local pool_addresses_provider) = get_context()
        %{ stop_prank = start_prank(ids.PRANK_ADMIN_ADDRESS, target_contract_address = ids.acl) %}
        IACLManager.grant_role(acl, FLASH_BORROW_ADMIN_ROLE, FLASH_BORROW_ADMIN_ADDRESS)

        # check who's the admin role for flash_borrow_role
        let (admin_role_fbr) = IACLManager.get_role_admin(acl, FLASH_BORROWER_ROLE)
        assert_not_zero(admin_role_fbr - FLASH_BORROW_ADMIN_ROLE)

        # set FLASH_BORROW_ADMIN_ROLE as admin for FLASH_BORROWER_ROLE. To do that, we need to prank call with admin_address
        IACLManager.set_role_admin(acl, FLASH_BORROWER_ROLE, FLASH_BORROW_ADMIN_ROLE)
        let (admin_role_fbr_after) = IACLManager.get_role_admin(acl, FLASH_BORROWER_ROLE)
        assert admin_role_fbr_after = FLASH_BORROW_ADMIN_ROLE

        %{ stop_prank() %}
        return ()
    end

    # FLASH_BORROW_ADMIN_ADDRESS grant FLASH_BORROW_ROLE
    func test_grant_flash_borrow_admin_role_4{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }():
        alloc_locals
        # Init Context and states
        let (local acl, local pool_addresses_provider) = get_context()
        %{ stop_prank = start_prank(ids.PRANK_ADMIN_ADDRESS, target_contract_address = ids.acl) %}
        IACLManager.grant_role(acl, FLASH_BORROW_ADMIN_ROLE, FLASH_BORROW_ADMIN_ADDRESS)
        IACLManager.set_role_admin(acl, FLASH_BORROWER_ROLE, FLASH_BORROW_ADMIN_ROLE)
        %{ stop_prank() %}

        # check initial state :  FLASH_BORROWER_ADDRESS is not FLASH_BORROWER_ROLE
        let (is_flash_borrower_before) = IACLManager.is_flash_borrower(acl, FLASH_BORROWER_ADDRESS)
        assert is_flash_borrower_before = FALSE

        # grant role
        %{ stop_prank_1 = start_prank(ids.FLASH_BORROW_ADMIN_ADDRESS, target_contract_address = ids.acl) %}
        IACLManager.add_flash_borrower(acl, FLASH_BORROWER_ADDRESS)
        %{ stop_prank_1() %}

        # chek final state : FLASH_BORROWER_ADDRESS is FLASH_BORROWER_ROLE
        let (is_flash_borrower_after) = IACLManager.is_flash_borrower(acl, FLASH_BORROWER_ADDRESS)
        assert is_flash_borrower_after = TRUE

        return ()
    end

    # DEFAULT_ADMIN tries to revoke FLASH_BORROW_ROLE : revert expected because it is not FLASH_BORROW_ROLE_ADMIN
    func test_revoke_flash_borrow_admin_role{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }():
        alloc_locals
        # Init Context and states
        let (local acl, local pool_addresses_provider) = get_context()
        %{ stop_prank = start_prank(ids.PRANK_ADMIN_ADDRESS, target_contract_address = ids.acl) %}
        IACLManager.grant_role(acl, FLASH_BORROW_ADMIN_ROLE, FLASH_BORROW_ADMIN_ADDRESS)
        IACLManager.set_role_admin(acl, FLASH_BORROWER_ROLE, FLASH_BORROW_ADMIN_ROLE)
        %{ stop_prank() %}
        %{ stop_prank_1 = start_prank(ids.FLASH_BORROW_ADMIN_ADDRESS, target_contract_address = ids.acl) %}
        IACLManager.add_flash_borrower(acl, FLASH_BORROWER_ADDRESS)
        %{ stop_prank_1() %}

        # check initial states :  FLASH_BORROW_ADMIN_ADDRESS has FLASH_BORROW_ADMIN_ROLE and
        # FLASH_BORROWER_ADDRESS is flash borrower
        let (role_admin) = IACLManager.has_role(
            acl, FLASH_BORROW_ADMIN_ROLE, FLASH_BORROW_ADMIN_ADDRESS
        )
        assert role_admin = TRUE
        let (is_flash_borrower_before) = IACLManager.is_flash_borrower(acl, FLASH_BORROWER_ADDRESS)
        assert is_flash_borrower_before = TRUE

        # PRANK_ADMIN_ADDRESS tries to revoke but fails as it is not admin for flash borrower
        %{ stop_prank = start_prank(ids.PRANK_ADMIN_ADDRESS, target_contract_address = ids.acl) %}
        %{ expect_revert() %}
        IACLManager.remove_flash_borrower(acl, FLASH_BORROWER_ADDRESS)
        %{ stop_prank() %}

        return ()
    end

    # Grant POOL_ADMIN role to POOL_ADMIN_ADDRESS
    func test_grant_pool_admin_role{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }():
        alloc_locals
        # Init Context and states
        let (local acl, local pool_addresses_provider) = get_context()

        # check initial state : POOL_ADMIN_ADDRESS is not pool admin yet
        %{ stop_prank = start_prank(ids.PRANK_ADMIN_ADDRESS, target_contract_address = ids.acl) %}
        let (pool_admin_before) = IACLManager.is_pool_admin(acl, POOL_ADMIN_ADDRESS)
        assert pool_admin_before = FALSE

        # grant pool admin role  to POOL_ADMIN_ADDRESS
        IACLManager.add_pool_admin(acl, POOL_ADMIN_ADDRESS)

        # check final state : POOL_ADMIN_ADDRESS is pool admin
        let (pool_admin_after) = IACLManager.is_pool_admin(acl, POOL_ADMIN_ADDRESS)
        assert pool_admin_after = TRUE

        %{ stop_prank() %}
        return ()
    end

    # # Grant EMERGENCY_ADMIN role to EMERGENCY_ADMIN_ADDRESS
    func test_grant_emergency_admin_role{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }():
        alloc_locals
        # Init Context and states
        let (local acl, local pool_addresses_provider) = get_context()

        # check initial state : EMERGENCY_ADMIN_ADDRESS is not emergency admin yet
        %{ stop_prank = start_prank(ids.PRANK_ADMIN_ADDRESS, target_contract_address = ids.acl) %}
        let (emergency_admin_before) = IACLManager.is_emergency_admin(acl, EMERGENCY_ADMIN_ADDRESS)
        assert emergency_admin_before = FALSE

        # grant emergency admin role  to EMERGENCY_ADMIN_ADDRESS
        IACLManager.add_emergency_admin(acl, EMERGENCY_ADMIN_ADDRESS)

        # check final state : POOL_ADMIN_ADDRESS is pool admin
        let (emergeny_admin_after) = IACLManager.is_emergency_admin(acl, EMERGENCY_ADMIN_ADDRESS)
        assert emergeny_admin_after = TRUE
        %{ stop_prank() %}
        return ()
    end

    # Grant RISK_ADMIN role to RISK_ADMIN_ADDRESS : same as above
    func test_grant_risk_admin_role{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }():
        alloc_locals
        let (local acl, local pool_addresses_provider) = get_context()
        %{ stop_prank = start_prank(ids.PRANK_ADMIN_ADDRESS, target_contract_address = ids.acl) %}
        let (risk_admin_before) = IACLManager.is_risk_admin(acl, RISK_ADMIN_ADDRESS)
        assert risk_admin_before = FALSE
        IACLManager.add_risk_admin(acl, RISK_ADMIN_ADDRESS)
        let (risk_admin_after) = IACLManager.is_risk_admin(acl, RISK_ADMIN_ADDRESS)
        assert risk_admin_after = TRUE
        %{ stop_prank() %}
        return ()
    end

    # Grant BRIDGE role to BRIDGE_ADDRESS : same as above
    func test_grant_bridge_role{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        ):
        alloc_locals
        let (local acl, local pool_addresses_provider) = get_context()
        %{ stop_prank = start_prank(ids.PRANK_ADMIN_ADDRESS, target_contract_address = ids.acl) %}
        let (bridge_before) = IACLManager.is_bridge(acl, BRIDGE_ADDRESS)
        assert bridge_before = FALSE
        IACLManager.add_bridge(acl, BRIDGE_ADDRESS)
        let (bridge_after) = IACLManager.is_bridge(acl, BRIDGE_ADDRESS)
        assert bridge_after = TRUE
        %{ stop_prank() %}
        return ()
    end

    # Grant ASSET_LISTING role to ASSET_LISTING_ADMIN_ADDRESS : same as above
    func test_grant_asset_listing_admin_role{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }():
        alloc_locals
        let (local acl, local pool_addresses_provider) = get_context()
        %{ stop_prank = start_prank(ids.PRANK_ADMIN_ADDRESS, target_contract_address = ids.acl) %}
        let (asset_listing_admin_before) = IACLManager.is_asset_listing_admin(
            acl, ASSET_LISTING_ADMIN_ADDRESS
        )
        assert asset_listing_admin_before = FALSE
        IACLManager.add_asset_listing_admin(acl, ASSET_LISTING_ADMIN_ADDRESS)
        let (asset_listing_admin_after) = IACLManager.is_asset_listing_admin(
            acl, ASSET_LISTING_ADMIN_ADDRESS
        )
        assert asset_listing_admin_after = TRUE
        %{ stop_prank() %}
        return ()
    end

    # Revoke FLASH_BORROWER_ROLE role
    func test_revoke_flash_borrower{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }():
        alloc_locals
        # Init Context and states
        let (local acl, local pool_addresses_provider) = get_context()
        %{ stop_prank = start_prank(ids.PRANK_ADMIN_ADDRESS, target_contract_address = ids.acl) %}
        IACLManager.grant_role(acl, FLASH_BORROW_ADMIN_ROLE, FLASH_BORROW_ADMIN_ADDRESS)
        IACLManager.set_role_admin(acl, FLASH_BORROWER_ROLE, FLASH_BORROW_ADMIN_ROLE)
        %{ stop_prank() %}
        %{ stop_prank_1 = start_prank(ids.FLASH_BORROW_ADMIN_ADDRESS, target_contract_address = ids.acl) %}
        IACLManager.add_flash_borrower(acl, FLASH_BORROWER_ADDRESS)

        # check initial state of admin and FLASH_BORROWER_ADDRESS
        let (role_admin) = IACLManager.has_role(
            acl, FLASH_BORROW_ADMIN_ROLE, FLASH_BORROW_ADMIN_ADDRESS
        )
        assert role_admin = TRUE
        let (is_flash_borrower_before) = IACLManager.is_flash_borrower(acl, FLASH_BORROWER_ADDRESS)
        assert is_flash_borrower_before = TRUE

        # Revoke role
        IACLManager.remove_flash_borrower(acl, FLASH_BORROWER_ADDRESS)
        %{ stop_prank_1() %}

        # check final state : FLASH_BORROWER_ADDRESS is no longer flash borrower
        let (is_flash_borrower_after) = IACLManager.is_flash_borrower(acl, FLASH_BORROWER_ADDRESS)
        assert is_flash_borrower_after = FALSE
        return ()
    end

    # Revoke FLASH_BORROW_ADMIN_ROLE role
    func test_revoke_flash_borrow_admin{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }():
        alloc_locals
        # Init Context and states
        let (local acl, local pool_addresses_provider) = get_context()
        %{ stop_prank = start_prank(ids.PRANK_ADMIN_ADDRESS, target_contract_address = ids.acl) %}
        IACLManager.grant_role(acl, FLASH_BORROW_ADMIN_ROLE, FLASH_BORROW_ADMIN_ADDRESS)
        IACLManager.set_role_admin(acl, FLASH_BORROWER_ROLE, FLASH_BORROW_ADMIN_ROLE)

        # check initial state
        let (role_admin) = IACLManager.has_role(
            acl, FLASH_BORROW_ADMIN_ROLE, FLASH_BORROW_ADMIN_ADDRESS
        )
        assert role_admin = TRUE

        # revoke FLASH_BORROW_ADMIN_ADDRESS of role FLASH_BORROW_ADMIN_ROLE
        IACLManager.revoke_role(acl, FLASH_BORROW_ADMIN_ROLE, FLASH_BORROW_ADMIN_ADDRESS)
        %{ stop_prank() %}

        # check final state  : FLASH_BORROW_ADMIN_ADDRESS is not FLASH_BORROW_ADMIN_ROLE anymore
        let (role_admin_after) = IACLManager.has_role(
            acl, FLASH_BORROW_ADMIN_ROLE, FLASH_BORROW_ADMIN_ADDRESS
        )
        assert role_admin_after = FALSE
        return ()
    end

    # Revoke POOL_ADMIN_ROLE role : same as above
    func test_revoke_pool_admin_role{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }():
        alloc_locals
        # Init Context and states
        let (local acl, local pool_addresses_provider) = get_context()
        %{ stop_prank = start_prank(ids.PRANK_ADMIN_ADDRESS, target_contract_address = ids.acl) %}
        IACLManager.add_pool_admin(acl, POOL_ADMIN_ADDRESS)

        # check initial state
        let (pool_admin_before) = IACLManager.is_pool_admin(acl, POOL_ADMIN_ADDRESS)
        assert pool_admin_before = TRUE

        # revoke role
        IACLManager.remove_pool_admin(acl, POOL_ADMIN_ADDRESS)

        # check final state
        let (pool_admin_final) = IACLManager.is_pool_admin(acl, POOL_ADMIN_ADDRESS)
        assert pool_admin_final = FALSE

        %{ stop_prank() %}
        return ()
    end

    # Revoke EMERGENCY_ADMIN_ROLE role : same as above
    func test_revoke_emergency_admin_role{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }():
        alloc_locals
        # Init Context and states
        let (local acl, local pool_addresses_provider) = get_context()
        %{ stop_prank = start_prank(ids.PRANK_ADMIN_ADDRESS, target_contract_address = ids.acl) %}
        IACLManager.add_emergency_admin(acl, EMERGENCY_ADMIN_ADDRESS)

        # check initial state
        let (emergency_admin_before) = IACLManager.is_emergency_admin(acl, EMERGENCY_ADMIN_ADDRESS)
        assert emergency_admin_before = TRUE

        # revoke emergency admin role
        IACLManager.remove_emergency_admin(acl, EMERGENCY_ADMIN_ADDRESS)

        # check final state
        let (emergency_admin_after) = IACLManager.is_emergency_admin(acl, EMERGENCY_ADMIN_ADDRESS)
        assert emergency_admin_after = FALSE
        %{ stop_prank() %}
        return ()
    end

    # Revoke RISK_ADMIN_ROLE role : same as above
    func test_revoke_risk_admin_role{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }():
        alloc_locals
        # Init Context and states
        let (local acl, local pool_addresses_provider) = get_context()
        %{ stop_prank = start_prank(ids.PRANK_ADMIN_ADDRESS, target_contract_address = ids.acl) %}
        IACLManager.add_risk_admin(acl, RISK_ADMIN_ADDRESS)

        # check initial state
        let (risk_admin_before) = IACLManager.is_risk_admin(acl, RISK_ADMIN_ADDRESS)
        assert risk_admin_before = TRUE

        # revoke risk admin role
        IACLManager.remove_risk_admin(acl, RISK_ADMIN_ADDRESS)

        # check final state
        let (risk_admin_final) = IACLManager.is_risk_admin(acl, RISK_ADMIN_ADDRESS)
        assert risk_admin_final = FALSE

        %{ stop_prank() %}
        return ()
    end

    # Revoke BRIDGE_ROLE role : same as above
    func test_revoke_bridge_role{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        ):
        alloc_locals
        # Init Context and states
        let (local acl, local pool_addresses_provider) = get_context()
        %{ stop_prank = start_prank(ids.PRANK_ADMIN_ADDRESS, target_contract_address = ids.acl) %}
        IACLManager.add_bridge(acl, BRIDGE_ADDRESS)

        # check initial state
        let (bridge_before) = IACLManager.is_bridge(acl, BRIDGE_ADDRESS)
        assert bridge_before = TRUE

        # revoke bridge role
        IACLManager.remove_bridge(acl, BRIDGE_ADDRESS)

        # check final state
        let (bridge_final) = IACLManager.is_bridge(acl, BRIDGE_ADDRESS)
        assert bridge_final = FALSE

        %{ stop_prank() %}
        return ()
    end

    # Revoke ASSET_LISTING_ROLE role : same as above
    func test_revoke_asset_listing_admin_role{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }():
        alloc_locals
        # Init Context and states
        let (local acl, local pool_addresses_provider) = get_context()
        %{ stop_prank = start_prank(ids.PRANK_ADMIN_ADDRESS, target_contract_address = ids.acl) %}
        IACLManager.add_asset_listing_admin(acl, ASSET_LISTING_ADMIN_ADDRESS)

        # check initial state
        let (asset_listing_admin_before) = IACLManager.is_asset_listing_admin(
            acl, ASSET_LISTING_ADMIN_ADDRESS
        )
        assert asset_listing_admin_before = TRUE

        # revoke asset listing role
        IACLManager.remove_asset_listing_admin(acl, ASSET_LISTING_ADMIN_ADDRESS)

        # check final state
        let (asset_listing_admin_final) = IACLManager.is_asset_listing_admin(
            acl, ASSET_LISTING_ADMIN_ADDRESS
        )
        assert asset_listing_admin_final = FALSE

        %{ stop_prank() %}
        return ()
    end

    # TODO add one test
end
