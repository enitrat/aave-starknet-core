%lang starknet

@contract_interface
namespace IPoolAddressesProvider {
    func transfer_ownership(new_owner: felt) {
    }

    func get_market_id() -> (market_id: felt) {
    }

    func set_market_id(market_id: felt) {
    }

    func get_address(id: felt) -> (address: felt) {
    }

    func set_address(id: felt, new_address: felt) {
    }

    func set_address_as_proxy(id: felt, implementation: felt, salt: felt) {
    }

    func get_pool() -> (pool: felt) {
    }

    func set_pool_impl(new_implementation: felt, salt: felt) {
    }

    func get_pool_configurator() -> (pool_configurator: felt) {
    }

    func set_pool_configurator_impl(new_implementation: felt, salt: felt) {
    }

    func get_price_oracle() -> (price_oracle: felt) {
    }

    func set_price_oracle(new_address: felt) {
    }

    func get_ACL_manager() -> (ACL_manager: felt) {
    }

    func set_ACL_manager(new_address: felt) {
    }

    func get_ACL_admin() -> (ACL_admin: felt) {
    }

    func set_ACL_admin(new_address: felt) {
    }

    func get_price_oracle_sentinel() -> (price_oracle_sentinel: felt) {
    }

    func set_price_oracle_sentinel(new_address: felt) {
    }

    func get_pool_data_provider() -> (get_pool_data_provider: felt) {
    }

    func set_pool_data_provider(new_address: felt) {
    }
}
