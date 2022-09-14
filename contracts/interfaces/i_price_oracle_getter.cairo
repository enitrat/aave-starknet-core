%lang starknet

@contract_interface
namespace IPriceOracleGetter {
    func BASE_CURRENCY() -> (address: felt) {
    }

    func BASE_CURRENCY_UNIT() -> (base: felt) {
    }

    func get_asset_price(asset: felt) -> (asset_price: felt) {
    }
}
