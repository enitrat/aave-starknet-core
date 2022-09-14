%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin

from contracts.mocks.oracle.price_oracle_library import PriceOracle

const ASSET_A_PRICE = 10;
const ASSET_A_ADDRESS = 1111;
const ETH_PRICE = 1;

@view
func test_price_oracle{syscall_ptr: felt*, range_check_ptr, pedersen_ptr: HashBuiltin*}() {
    let (asset_a_price_before) = PriceOracle.get_asset_price(ASSET_A_ADDRESS);
    let (eth_before) = PriceOracle.get_eth_usd_price();
    assert asset_a_price_before = 0;
    assert eth_before = 0;

    PriceOracle.set_asset_price(ASSET_A_ADDRESS, ASSET_A_PRICE);
    PriceOracle.set_eth_usd_price(ETH_PRICE);

    let (asset_a_price_after) = PriceOracle.get_asset_price(ASSET_A_ADDRESS);
    let (eth_after) = PriceOracle.get_eth_usd_price();

    assert asset_a_price_after = ASSET_A_PRICE;
    assert eth_after = ETH_PRICE;
    return ();
}
