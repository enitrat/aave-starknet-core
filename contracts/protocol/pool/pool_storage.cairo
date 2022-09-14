%lang starknet
from starkware.cairo.common.cairo_builtins import HashBuiltin

from contracts.protocol.libraries.types.data_types import DataTypes

@storage_var
func PoolStorage_addresses_provider() -> (address: felt) {
}

// Map of reserves and their data (underlyind_asset => reserve_data)
@storage_var
func PoolStorage_reserves(asset: felt) -> (reserve_data: DataTypes.ReserveData) {
}

@storage_var
func PoolStorage_reserves_config(asset: felt) -> (res_config: DataTypes.ReserveConfiguration) {
}

// Map of users address and their configuration data (user_address=> userConfiguration)
@storage_var
func PoolStorage_users_config(user_address: felt, reserve_index: felt) -> (
    user_config: DataTypes.UserConfigurationMap
) {
}

// List of reserves as a map (reserve_id => address).
@storage_var
func PoolStorage_reserves_list(reserve_id: felt) -> (address: felt) {
}

// TODO List of eMode_categories

// Map of users address and their eMode category (userAddress => eModeCategoryId)
@storage_var
func PoolStorage_users_eMode_category(address: felt) -> (category_id: felt) {
}

// Fee of the protocol bridge, expressed in bps
@storage_var
func PoolStorage_bridge_protocol_fee() -> (bps: felt) {
}

// Total FlashLoan Premium, expressed in bps
@storage_var
func PoolStorage_flash_loan_premium_total() -> (bps: felt) {
}

// FlashLoan premium paid to protocol treasury, expressed in bps
@storage_var
func PoolStorage_flash_loan_premium_to_protocol() -> (bps: felt) {
}

// Available liquidity that can be borrowed at once at stable rate, expressed in bps
@storage_var
func PoolStorage_max_stable_rate_borrow_size_percent() -> (bps: felt) {
}

// Maximum number of active reserves there have been in the protocol. It is the upper bound of the reserves list
@storage_var
func PoolStorage_reserves_count() -> (count: felt) {
}

namespace PoolStorage {
    //
    // Reads
    //

    func addresses_provider_read{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        ) -> (address: felt) {
        let (address) = PoolStorage_addresses_provider.read();
        return (address,);
    }

    func reserves_read{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        address: felt
    ) -> (reserve_data: DataTypes.ReserveData) {
        let (reserve) = PoolStorage_reserves.read(address);
        return (reserve,);
    }

    func reserves_config_read{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        address: felt
    ) -> (res_config: DataTypes.ReserveConfiguration) {
        let (res) = PoolStorage_reserves_config.read(address);
        return (res,);
    }

    func users_config_read{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        user_address: felt, reserve_index: felt
    ) -> (user_config: DataTypes.UserConfigurationMap) {
        let (user_config) = PoolStorage_users_config.read(user_address, reserve_index);
        return (user_config,);
    }

    func reserves_list_read{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        reserve_id: felt
    ) -> (address: felt) {
        let (address) = PoolStorage_reserves_list.read(reserve_id);
        return (address,);
    }

    func users_eMode_category_read{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        address: felt
    ) -> (category_id: felt) {
        let (category_id) = PoolStorage_users_eMode_category.read(address);
        return (category_id,);
    }

    func bridge_protocol_fee_read{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        ) -> (bps: felt) {
        let (bps) = PoolStorage_bridge_protocol_fee.read();
        return (bps,);
    }

    func flash_loan_premium_total_read{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }() -> (bps: felt) {
        let (bps) = PoolStorage_flash_loan_premium_total.read();
        return (bps,);
    }

    func flash_loan_premium_to_protocol_read{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }() -> (bps: felt) {
        let (bps) = PoolStorage_flash_loan_premium_to_protocol.read();
        return (bps,);
    }

    func max_stable_rate_borrow_size_percent_read{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }() -> (bps: felt) {
        let (bps) = PoolStorage_max_stable_rate_borrow_size_percent.read();
        return (bps,);
    }

    func reserves_count_read{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        count: felt
    ) {
        let (count) = PoolStorage_reserves_count.read();
        return (count,);
    }

    //
    // Writes
    //

    func addresses_provider_write{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        address: felt
    ) {
        PoolStorage_addresses_provider.write(address);
        return ();
    }

    func reserves_write{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        asset: felt, reserve_data: DataTypes.ReserveData
    ) {
        PoolStorage_reserves.write(asset, reserve_data);
        return ();
    }

    func reserves_config_write{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        address: felt, res_config: DataTypes.ReserveConfiguration
    ) {
        PoolStorage_reserves_config.write(address, res_config);
        return ();
    }

    func users_config_write{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        user_address: felt, reserve_index: felt, user_config: DataTypes.UserConfigurationMap
    ) {
        PoolStorage_users_config.write(user_address, reserve_index, user_config);
        return ();
    }

    func reserves_list_write{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        reserve_id: felt, address: felt
    ) {
        PoolStorage_reserves_list.write(reserve_id, address);
        return ();
    }

    func users_eMode_category_write{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }(address: felt, category_id: felt) {
        PoolStorage_users_eMode_category.write(address, category_id);
        return ();
    }

    func bridge_protocol_fee_write{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        bps: felt
    ) {
        PoolStorage_bridge_protocol_fee.write(bps);
        return ();
    }

    func flash_loan_premium_total_write{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }(bps: felt) {
        PoolStorage_flash_loan_premium_total.write(bps);
        return ();
    }

    func flash_loan_premium_to_protocol_write{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }(bps: felt) {
        PoolStorage_flash_loan_premium_to_protocol.write(bps);
        return ();
    }

    func max_stable_rate_borrow_size_percent_write{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }(bps: felt) {
        PoolStorage_max_stable_rate_borrow_size_percent.write(bps);
        return ();
    }

    func reserves_count_write{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        count: felt
    ) {
        PoolStorage_reserves_count.write(count);
        return ();
    }
}
