%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_block_timestamp

from contracts.mocks.oracle.price_oracle_library import PriceOracle

@view
func get_asset_price{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    asset : felt
) -> (price : felt):
    return PriceOracle.get_asset_price(asset)
end

@external
func set_asset_price{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    asset : felt, price : felt
):
    PriceOracle.set_asset_price(asset, price)
    return ()
end

@view
func get_eth_usd_price{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    price : felt
):
    return PriceOracle.get_eth_usd_price()
end

@external
func set_eth_usd_price{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    price : felt
):
    PriceOracle.set_eth_usd_price(price)
    return ()
end
