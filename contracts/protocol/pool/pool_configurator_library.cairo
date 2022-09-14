%lang starknet

from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.starknet.common.syscalls import get_caller_address

from contracts.interfaces.i_acl_manager import IACLManager
from contracts.interfaces.i_pool import IPool
from contracts.interfaces.i_pool_addresses_provider import IPoolAddressesProvider
from contracts.protocol.libraries.aave_upgradeability.versioned_initializable_library import (
    VersionedInitializable,
)
from contracts.protocol.libraries.helpers.bool_cmp import BoolCmp
from contracts.protocol.libraries.helpers.helpers import update_struct
from contracts.protocol.libraries.logic.configurator_logic import ConfiguratorLogic
from contracts.protocol.libraries.types.configurator_input_types import ConfiguratorInputTypes
from contracts.protocol.libraries.types.data_types import DataTypes

//
// Events
//

@event
func ReserveDropped(asset: felt) {
}

@event
func ReserveBorrowing(asset: felt, enabled: felt) {
}

//
// Storage
//

@storage_var
func PoolConfigurator_pool() -> (res: felt) {
}

@storage_var
func PoolConfigurator_addresses_provider() -> (res: felt) {
}

//
// Namespace
//

namespace PoolConfigurator {
    // Constants

    const REVISION = 1;

    // Authorization

    func assert_only_pool_admin{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
        alloc_locals;
        let (caller_address) = get_caller_address();
        let (addresses_provider) = PoolConfigurator_addresses_provider.read();
        let (acl_manager) = IPoolAddressesProvider.get_ACL_manager(addresses_provider);

        let (is_caller_pool_admin) = IACLManager.is_pool_admin(acl_manager, caller_address);
        with_attr error_message("Caller is not pool admin.") {
            assert is_caller_pool_admin = TRUE;
        }

        return ();
    }

    func assert_only_emergency_admin{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }() {
        alloc_locals;
        let (caller_address) = get_caller_address();
        let (addresses_provider) = PoolConfigurator_addresses_provider.read();
        let (acl_manager) = IPoolAddressesProvider.get_ACL_manager(addresses_provider);

        let (is_caller_emergency_admin) = IACLManager.is_emergency_admin(
            acl_manager, caller_address
        );
        with_attr error_message("Caller is not emergency admin.") {
            assert is_caller_emergency_admin = TRUE;
        }

        return ();
    }

    func assert_only_pool_or_emergency_admin{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }() {
        alloc_locals;
        let (caller_address) = get_caller_address();
        let (addresses_provider) = PoolConfigurator_addresses_provider.read();
        let (acl_manager) = IPoolAddressesProvider.get_ACL_manager(addresses_provider);

        let (is_caller_pool_admin) = IACLManager.is_pool_admin(acl_manager, caller_address);
        let (is_caller_emergency_admin) = IACLManager.is_emergency_admin(
            acl_manager, caller_address
        );
        let (is_pool_or_emergency_admin) = BoolCmp.either(
            is_caller_pool_admin, is_caller_emergency_admin
        );
        with_attr error_message("Caller is not emergency or pool admin.") {
            assert is_pool_or_emergency_admin = TRUE;
        }

        return ();
    }

    func assert_only_asset_listing_or_pool_admins{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }() {
        alloc_locals;
        let (caller_address) = get_caller_address();
        let (addresses_provider) = PoolConfigurator_addresses_provider.read();
        let (acl_manager) = IPoolAddressesProvider.get_ACL_manager(addresses_provider);

        let (is_caller_pool_admin) = IACLManager.is_pool_admin(acl_manager, caller_address);
        let (is_caller_asset_listing_admin) = IACLManager.is_asset_listing_admin(
            acl_manager, caller_address
        );
        let (is_asset_listing_or_pool_admin) = BoolCmp.either(
            is_caller_pool_admin, is_caller_asset_listing_admin
        );
        with_attr error_message("Caller is not asset listing or pool admin.") {
            assert is_asset_listing_or_pool_admin = TRUE;
        }

        return ();
    }

    func assert_only_risk_or_pool_admins{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }() {
        alloc_locals;
        let (caller_address) = get_caller_address();
        let (addresses_provider) = PoolConfigurator_addresses_provider.read();
        let (acl_manager) = IPoolAddressesProvider.get_ACL_manager(addresses_provider);

        let (is_caller_pool_admin) = IACLManager.is_pool_admin(acl_manager, caller_address);
        let (is_caller_risk_admin) = IACLManager.is_risk_admin(acl_manager, caller_address);
        let (is_risk_or_pool_admin) = BoolCmp.either(is_caller_pool_admin, is_caller_risk_admin);
        with_attr error_message("Caller is not risk or pool admin.") {
            assert is_risk_or_pool_admin = TRUE;
        }

        return ();
    }

    // Externals

    func initialize{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        provider: felt
    ) {
        VersionedInitializable.initializer(REVISION);
        PoolConfigurator_addresses_provider.write(provider);
        let (pool) = IPoolAddressesProvider.get_pool(provider);
        PoolConfigurator_pool.write(pool);
        return ();
    }

    func init_reserves{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        input_len: felt, input: ConfiguratorInputTypes.InitReserveInput*
    ) {
        assert_only_asset_listing_or_pool_admins();
        let (pool) = PoolConfigurator_pool.read();
        _init_reserves_inner(pool, input_len, input);
        return ();
    }

    func drop_reserve{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        asset: felt
    ) {
        assert_only_pool_admin();
        let (pool) = PoolConfigurator_pool.read();
        IPool.drop_reserve(pool, asset);
        ReserveDropped.emit(asset);
        return ();
    }

    func update_a_token{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        input: ConfiguratorInputTypes.UpdateATokenInput
    ) {
        assert_only_pool_admin();
        let (pool) = PoolConfigurator_pool.read();
        ConfiguratorLogic.execute_update_a_token(pool, input);
        return ();
    }

    func update_stable_debt_token{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        input: ConfiguratorInputTypes.UpdateDebtTokenInput
    ) {
        assert_only_pool_admin();
        let (pool) = PoolConfigurator_pool.read();
        ConfiguratorLogic.execute_update_stable_debt_token(pool, input);
        return ();
    }

    func update_variable_debt_token{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }(input: ConfiguratorInputTypes.UpdateDebtTokenInput) {
        assert_only_pool_admin();
        let (pool) = PoolConfigurator_pool.read();
        ConfiguratorLogic.execute_update_variable_debt_token(pool, input);
        return ();
    }

    func set_reserve_borrowing{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        asset: felt, enabled: felt
    ) {
        alloc_locals;
        assert_only_risk_or_pool_admins();
        BoolCmp.is_valid(enabled);

        let (pool) = PoolConfigurator_pool.read();
        let (local config) = IPool.get_configuration(pool, asset);

        if (enabled == FALSE) {
            with_attr error_message("Stable borrowing is enabled") {
                let is_stable_rate_borrow_enabled = config.stable_rate_borrowing_enabled;
                assert is_stable_rate_borrow_enabled = FALSE;
            }
        }

        let (__fp__, _) = get_fp_and_pc();

        let (local updated_config: DataTypes.ReserveConfiguration*) = update_struct(
            &config,
            DataTypes.ReserveConfiguration.SIZE,
            &enabled,
            DataTypes.ReserveConfiguration.stable_rate_borrowing_enabled,
        );

        IPool.set_configuration(pool, asset, [updated_config]);

        ReserveBorrowing.emit(asset, enabled);

        return ();
    }

    // Internals

    func _init_reserves_inner{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        pool: felt, input_len: felt, input: ConfiguratorInputTypes.InitReserveInput*
    ) {
        if (input_len == 0) {
            return ();
        }
        ConfiguratorLogic.execute_init_reserve(pool, [input]);
        _init_reserves_inner(
            pool, input_len - 1, input + ConfiguratorInputTypes.InitReserveInput.SIZE
        );
        return ();
    }

    // Getters

    func get_revision{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        revision: felt
    ) {
        return (REVISION,);
    }

    func get_pool{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        pool: felt
    ) {
        let (pool) = PoolConfigurator_pool.read();
        return (pool,);
    }

    func get_addresses_provider{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        ) -> (addresses_provider: felt) {
        let (addresses_provider) = PoolConfigurator_addresses_provider.read();
        return (addresses_provider,);
    }
}
