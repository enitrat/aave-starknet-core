%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_block_timestamp

@storage_var
func PriceOracle_assets_prices(asset: felt) -> (price: felt) {
}

@storage_var
func PriceOracle_eth_price_usd() -> (price: felt) {
}

@event
func AssetPriceUpdated(asset: felt, price: felt, timestamp: felt) {
}

@event
func EthPriceUpdated(price: felt, timestamp: felt) {
}

namespace PriceOracle {
    func get_asset_price{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        asset: felt
    ) -> (price: felt) {
        let (price) = PriceOracle_assets_prices.read(asset);
        return (price,);
    }

    func set_asset_price{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        asset: felt, price: felt
    ) {
        let (timestamp) = get_block_timestamp();
        PriceOracle_assets_prices.write(asset, price);
        AssetPriceUpdated.emit(asset, price, timestamp);
        return ();
    }

    func get_eth_usd_price{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        price: felt
    ) {
        return PriceOracle_eth_price_usd.read();
    }

    func set_eth_usd_price{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        price: felt
    ) {
        let (timestamp) = get_block_timestamp();
        PriceOracle_eth_price_usd.write(price);
        EthPriceUpdated.emit(price, timestamp);
        return ();
    }
}
