%lang starknet

@contract_interface
namespace IAaveOracle {
    func initialize(
        provider: felt,
        oracle_address: felt,
        assets_len: felt,
        assets: felt*,
        tickers_len: felt,
        tickers: felt*,
        fallback_oracle: felt,
        base_currency: felt,
        base_currency_unit: felt,
    ) {
    }

    func ADDRESSES_PROVIDER() -> (provider: felt) {
    }

    func BASE_CURRENCY() -> (base_currency: felt) {
    }

    func BASE_CURRENCY_UNIT() -> (base_currency_unit: felt) {
    }

    func set_assets_tickers(assets_len: felt, assets: felt*, tickers_len: felt, tickers: felt*) {
    }

    func set_fallback_oracle(fallback_oracle: felt) {
    }

    func get_asset_price(asset: felt) -> (price: felt) {
    }

    func get_assets_prices(assets_len: felt, assets: felt*) -> (prices_len: felt, prices: felt*) {
    }

    func get_ticker_of_asset(asset: felt) -> (ticker: felt) {
    }

    func get_fallback_oracle() -> (fallback_oracle: felt) {
    }
}
