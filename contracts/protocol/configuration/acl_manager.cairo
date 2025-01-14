%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin

from openzeppelin.access.accesscontrol.library import AccessControl

from contracts.protocol.configuration.acl_manager_library import ACLManager

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(provider: felt) {
    ACLManager.initializer(provider);
    return ();
}

//
// AccessControl
//

@view
func has_role{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    role: felt, user: felt
) -> (has_role: felt) {
    return AccessControl.has_role(role, user);
}

@external
func grant_role{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    role: felt, user: felt
) {
    AccessControl.grant_role(role, user);
    return ();
}

@view
func get_role_admin{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    role: felt
) -> (admin: felt) {
    return AccessControl.get_role_admin(role);
}

@external
func revoke_role{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    role: felt, user: felt
) {
    AccessControl.revoke_role(role, user);
    return ();
}

//
// ACLManager
//

@external
func set_role_admin{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    role: felt, admin_role: felt
) {
    ACLManager.set_role_admin(role, admin_role);
    return ();
}

@external
func add_pool_admin{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    admin_address: felt
) {
    ACLManager.add_pool_admin(admin_address);
    return ();
}

@external
func remove_pool_admin{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    admin_address: felt
) {
    ACLManager.remove_pool_admin(admin_address);
    return ();
}

@view
func is_pool_admin{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    admin_address: felt
) -> (has_role: felt) {
    return ACLManager.is_pool_admin(admin_address);
}

@external
func add_emergency_admin{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    admin_address: felt
) {
    ACLManager.add_emergency_admin(admin_address);
    return ();
}

@external
func remove_emergency_admin{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    admin_address: felt
) {
    ACLManager.remove_emergency_admin(admin_address);
    return ();
}

@view
func is_emergency_admin{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    admin_address: felt
) -> (has_role: felt) {
    return ACLManager.is_emergency_admin(admin_address);
}

@external
func add_risk_admin{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    admin_address: felt
) {
    ACLManager.add_risk_admin(admin_address);
    return ();
}

@external
func remove_risk_admin{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    admin_address: felt
) {
    ACLManager.remove_risk_admin(admin_address);
    return ();
}

@view
func is_risk_admin{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    admin_address: felt
) -> (has_role: felt) {
    return ACLManager.is_risk_admin(admin_address);
}

@external
func add_flash_borrower{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    flash_borrower: felt
) {
    ACLManager.add_flash_borrower(flash_borrower);
    return ();
}

@external
func remove_flash_borrower{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    flash_borrower: felt
) {
    ACLManager.remove_flash_borrower(flash_borrower);
    return ();
}

@view
func is_flash_borrower{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    flash_borrower: felt
) -> (has_role: felt) {
    return ACLManager.is_flash_borrower(flash_borrower);
}

@external
func add_bridge{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(bridge: felt) {
    ACLManager.add_bridge(bridge);
    return ();
}

@external
func remove_bridge{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(bridge: felt) {
    ACLManager.remove_bridge(bridge);
    return ();
}

@view
func is_bridge{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(bridge: felt) -> (
    has_role: felt
) {
    return ACLManager.is_bridge(bridge);
}

@external
func add_asset_listing_admin{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    admin_address: felt
) {
    ACLManager.add_asset_listing_admin(admin_address);
    return ();
}

@external
func remove_asset_listing_admin{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    admin_address: felt
) {
    ACLManager.remove_asset_listing_admin(admin_address);
    return ();
}

@view
func is_asset_listing_admin{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    admin_address: felt
) -> (has_role: felt) {
    return ACLManager.is_asset_listing_admin(admin_address);
}

@view
func get_addresses_provider{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    provider_address: felt
) {
    return ACLManager.get_addresses_provider();
}

@view
func get_pool_admin_role{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    pool_admin_role: felt
) {
    return ACLManager.get_pool_admin_role();
}

@view
func get_emergency_admin_role{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) -> (emergency_admin_role: felt) {
    return ACLManager.get_emergency_admin_role();
}

@view
func get_flash_borrower_role{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    flash_borrower_role: felt
) {
    return ACLManager.get_flash_borrower_role();
}

@view
func get_bridge_role{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    bridge_role: felt
) {
    return ACLManager.get_bridge_role();
}

@view
func get_asset_listing_admin_role{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) -> (asset_listing_admin_role: felt) {
    return ACLManager.get_asset_listing_admin_role();
}
