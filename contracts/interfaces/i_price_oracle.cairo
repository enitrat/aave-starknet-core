%lang starknet

@contract_interface
namespace IPriceOracle {
    func get_asset_price(asset: felt) -> (price: felt) {
    }

    func set_asset_price(asset: felt, price: felt) {
    }
}
