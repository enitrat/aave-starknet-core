%lang starknet

from contracts.dependencies.stork.data_types import PriceTick, PriceAggregate

@contract_interface
namespace IOracleProxy {
    func submit_multiple(prices_len: felt, prices: PriceTick*) {
    }

    func submit_single(price: PriceTick) {
    }

    func submit_multiple_aggregate(publisher: felt, prices_len: felt, prices: PriceAggregate*) {
    }

    func submit_single_aggregate(publisher: felt, price: PriceTick) {
    }

    func add_asset(asset_name: felt) {
    }

    func update_implementation(new_address: felt) {
    }

    func update_publisher_proxy(new_address: felt) {
    }

    func get_value(asset: felt) -> (price: PriceTick) {
    }

    func get_publisher_value(asset: felt, publisher: felt) -> (price: PriceTick) {
    }

    func get_values(asset: felt) -> (prices_len: felt, prices: PriceTick*) {
    }

    func get_price_bundle(asset: felt) -> (price: PriceAggregate) {
    }

    func get_caller() -> (caller: felt) {
    }

    func get_owner() -> (caller: felt) {
    }
}
