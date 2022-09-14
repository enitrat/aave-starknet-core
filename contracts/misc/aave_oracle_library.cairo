%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math_cmp import is_nn
from starkware.starknet.common.syscalls import get_caller_address
from starkware.cairo.common.bool import TRUE
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.math import split_felt
from contracts.dependencies.empiric.i_oracle_proxy import IEmpiricOracle, EmpiricAggregationModes
from contracts.interfaces.i_pool_addresses_provider import IPoolAddressesProvider
from contracts.interfaces.i_acl_manager import IACLManager
from contracts.protocol.libraries.helpers.bool_cmp import BoolCmp
from contracts.protocol.libraries.helpers.helpers import is_zero
from contracts.protocol.libraries.helpers.errors import Errors

@storage_var
func AaveOracle_addresses_provider() -> (addresses_provider: felt) {
}

@storage_var
func AaveOracle_asset_tickers(asset: felt) -> (ticker: felt) {
}

@storage_var
func AaveOracle_oracle_address() -> (oracle_address: felt) {
}

@storage_var
func AaveOracle_fallback_oracle() -> (fallback_oracle: felt) {
}

@storage_var
func AaveOracle_base_currency() -> (base_currency: felt) {
}

@storage_var
func AaveOracle_base_currency_unit() -> (base_currency_unit: felt) {
}

// @dev Emitted after the base currency is set
// @param base_currency The base currency of used for price quotes
// @param base_currency_unit The unit of the base currency
@event
func BaseCurrencySet(base_currency: felt, base_currency_unit: felt) {
}

// @dev Emitted after the ticker of an asset is updated
// @param asset The address of the asset
// @param ticker The price ticker of the asset
@event
func AssetSourceUpdated(asset: felt, ticker: felt) {
}

// @dev Emitted after the address of fallback oracle is updated
// @param fallback_oracle The address of the fallback oracle
@event
func FallbackOracleUpdated(fallback_oracle: felt) {
}

func assert_only_asset_listing_or_pool_admin{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    let (pool_addresses_provider) = AaveOracle_addresses_provider.read();
    let (ACL_manager_address) = IPoolAddressesProvider.get_ACL_manager(pool_addresses_provider);
    let (caller) = get_caller_address();
    let (is_asset_listing_admin) = IACLManager.is_asset_listing_admin(ACL_manager_address, caller);
    let (is_pool_admin) = IACLManager.is_pool_admin(ACL_manager_address, caller);
    let (either) = BoolCmp.either(is_asset_listing_admin, is_pool_admin);
    let error_code = Errors.CALLER_NOT_ASSET_LISTING_OR_POOL_ADMIN;
    with_attr error_message("{error_code}") {
        assert either = TRUE;
    }
    return ();
}

namespace AaveOracle {
    // @notice Initializer
    // @param provider The address of the new PoolAddressesProvider
    // @param oracle_address The address of the oracle
    // @param assets_len Length of the assets array
    // @param assets The addresses of the assets
    // @param tickers_len Length of the tickers array
    // @param tickers The tickers of each asset
    // @param fallback_oracle The address of the fallback oracle to use if the data of an
    //        aggregator is not consistent
    // @param base_currency The base currency used for the price quotes. If USD is used, base currency is 0
    // @param base_currency_unit The unit of the base currency
    func initializer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
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
        AaveOracle_addresses_provider.write(provider);
        AaveOracle_oracle_address.write(oracle_address);
        AaveOracle_base_currency.write(base_currency);
        AaveOracle_base_currency_unit.write(base_currency_unit);
        _set_assets_tickers(assets_len, assets, tickers_len, tickers);
        BaseCurrencySet.emit(base_currency, base_currency_unit);
        return ();
    }

    // @notice Returns the PoolAddressesProvider
    // @return The address of the PoolAddressesProvider contract
    func ADDRESSES_PROVIDER{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        provider: felt
    ) {
        let (pool_addresses_provider) = AaveOracle_addresses_provider.read();
        return (pool_addresses_provider,);
    }

    // @notice Returns the base currency
    // @return the base currency
    func BASE_CURRENCY{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        base_currency: felt
    ) {
        let (base_currency) = AaveOracle_base_currency.read();
        return (base_currency,);
    }

    // @notice Returns the base_currency_unit
    // @return The address of the base_currency_unit
    func BASE_CURRENCY_UNIT{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        base_currency_unit: felt
    ) {
        let (base_currency_unit) = AaveOracle_base_currency_unit.read();
        return (base_currency_unit,);
    }

    // @notice Sets or replaces price tickers of assets
    // @param assets The addresses of the assets
    // @param tickers The addresses of the price tickers
    func set_assets_tickers{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        assets_len: felt, assets: felt*, tickers_len: felt, tickers: felt*
    ) {
        assert_only_asset_listing_or_pool_admin();
        _set_assets_tickers(assets_len, assets, tickers_len, tickers);
        return ();
    }

    // @notice Sets the fallback oracle
    // @param fallback_oracle The address of the fallback oracle
    func set_fallback_oracle{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        fallback_oracle: felt
    ) {
        assert_only_asset_listing_or_pool_admin();
        _set_fallback_oracle(fallback_oracle);
        return ();
    }

    // @notice Returns the asset price in the base currency
    // @param asset The address of the asset
    // @return The price of the asset
    func get_asset_price{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        asset: felt
    ) -> (price: felt) {
        let (ticker) = AaveOracle_asset_tickers.read(asset);
        let (base_currency) = AaveOracle_base_currency.read();
        let (base_currency_unit) = AaveOracle_base_currency_unit.read();

        if (asset == base_currency) {
            return (base_currency_unit,);
        }

        if (ticker == 0) {
            // no fallback oracle to rely on - we return 0
            return (0,);
        } else {
            return _read_price_from_oracle(ticker);
        }
    }

    // @notice Returns a list of prices from a list of assets addresses
    // @param assets The list of assets addresses
    // @return The prices of the given assets
    func get_assets_prices{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        assets_len: felt, assets: felt*
    ) -> (prices_len: felt, prices: felt*) {
        alloc_locals;
        let (local prices: felt*) = alloc();
        let (prices_len) = _get_assets_prices(assets_len, assets, 0, prices);
        return (prices_len, prices);
    }

    // @notice Returns the address of the ticker for an asset address
    // @param asset The address of the asset
    // @return The ticker of the ticker
    func get_ticker_of_asset{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        asset: felt
    ) -> (ticker: felt) {
        let (ticker) = AaveOracle_asset_tickers.read(asset);
        return (ticker,);
    }

    // @notice Returns the address of the fallback oracle
    // @return The address of the fallback oracle
    func get_fallback_oracle{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        fallback_oracle: felt
    ) {
        let (fallback_oracle) = AaveOracle_fallback_oracle.read();
        return (fallback_oracle,);
    }
}

// @notice Internal function to set the tickers for each asset
// @param assets_len Length of the assets array
// @param assets The addresses of the assets
// @param tickers_len Length of the tickers array
// @param tickers The address of the ticker of each asset
func _set_assets_tickers{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    assets_len: felt, assets: felt*, tickers_len: felt, tickers: felt*
) {
    let error_code = Errors.INCONSISTENT_PARAMS_LENGTH;
    with_attr error_message("{error_code}") {
        assert assets_len = tickers_len;
    }
    if (assets_len == 0) {
        return ();
    }

    AaveOracle_asset_tickers.write([assets], [tickers]);
    AssetSourceUpdated.emit([assets], [tickers]);
    return _set_assets_tickers(assets_len - 1, assets + 1, tickers_len - 1, tickers + 1);
}

// @notice Internal function to set the fallback oracle
// @param fallback_oracle The address of the fallback oracle
func _set_fallback_oracle{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    fallback_oracle: felt
) {
    AaveOracle_fallback_oracle.write(fallback_oracle);
    FallbackOracleUpdated.emit(fallback_oracle);
    return ();
}

func _get_assets_prices{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    assets_len: felt, assets: felt*, prices_len: felt, prices: felt*
) -> (prices_len: felt) {
    if (assets_len == 0) {
        return (prices_len,);
    }
    let (asset_price) = AaveOracle.get_asset_price([assets]);
    assert [prices] = asset_price;
    return _get_assets_prices(assets_len - 1, assets + 1, prices_len + 1, prices + 1);
}

// @notice Internal function to read an asset price from the oracle.
// @param ticker The ticker of the asset
func _read_price_from_oracle{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ticker
) -> (price: felt) {
    alloc_locals;
    let (oracle_address) = AaveOracle_oracle_address.read();
    let (price, _, _, _) = IEmpiricOracle.get_value(
        oracle_address, ticker, EmpiricAggregationModes.MEDIAN
    );
    let price_above_zero = is_nn(price);
    let (price_is_zero) = is_zero(price);
    let (either) = BoolCmp.either(price_above_zero, price_is_zero);
    if (either == TRUE) {
        return (price,);
    } else {
        // no fallback oracle
        return (0,);
    }
}
