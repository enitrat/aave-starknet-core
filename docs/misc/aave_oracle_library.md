
Aave_oracle_library
===================
  
{% swagger method = "event" path = " " baseUrl = " " summary = "BaseCurrencySet" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="base_currency" %}  
The base currency of used for price quotes  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="base_currency_unit" %}  
The unit of the base currency  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "event" path = " " baseUrl = " " summary = "AssetSourceUpdated" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="asset" %}  
The address of the asset  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="ticker" %}  
The price ticker of the asset  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "event" path = " " baseUrl = " " summary = "FallbackOracleUpdated" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="fallback_oracle" %}  
The address of the fallback oracle  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "st0rage" path = " " baseUrl = " " summary = "AaveOracle_addresses_provider" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="addresses_provider ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "st0rage" path = " " baseUrl = " " summary = "AaveOracle_asset_tickers" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="asset" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="ticker ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "st0rage" path = " " baseUrl = " " summary = "AaveOracle_oracle_address" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="oracle_address ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "st0rage" path = " " baseUrl = " " summary = "AaveOracle_fallback_oracle" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="fallback_oracle ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "st0rage" path = " " baseUrl = " " summary = "AaveOracle_base_currency" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="base_currency ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "st0rage" path = " " baseUrl = " " summary = "AaveOracle_base_currency_unit" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="base_currency_unit ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "initializer" %}  
{% swagger-description %}  
Initializer  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="provider" %}  
The address of the new PoolAddressesProvider  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="oracle_address" %}  
The address of the oracle  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="assets_len" %}  
Length of the assets array  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="assets" %}  
The addresses of the assets  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="tickers_len" %}  
Length of the tickers array  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="tickers" %}  
The tickers of each asset  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="fallback_oracle" %}  
The address of the fallback oracle to use if the data of an
aggregator is not consistent  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="base_currency" %}  
The base currency used for the price quotes. If USD is used, base currency is 0  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="base_currency_unit" %}  
The unit of the base currency  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "ADDRESSES_PROVIDER" %}  
{% swagger-description %}  
Returns the PoolAddressesProvider  
{% endswagger-description %}  
{% swagger-response status="provider ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "BASE_CURRENCY" %}  
{% swagger-description %}  
Returns the base currency  
{% endswagger-description %}  
{% swagger-response status="base_currency ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "BASE_CURRENCY_UNIT" %}  
{% swagger-description %}  
Returns the base_currency_unit  
{% endswagger-description %}  
{% swagger-response status="base_currency_unit ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "set_assets_tickers" %}  
{% swagger-description %}  
Sets or replaces price tickers of assets  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="assets_len" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="assets" %}  
The addresses of the assets  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="tickers_len" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="tickers" %}  
The addresses of the price tickers  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "set_fallback_oracle" %}  
{% swagger-description %}  
Sets the fallback oracle  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="fallback_oracle" %}  
The address of the fallback oracle  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_asset_price" %}  
{% swagger-description %}  
Returns the asset price in the base currency  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="asset" %}  
The address of the asset  
{% endswagger-parameter %}  
{% swagger-response status="price ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_assets_prices" %}  
{% swagger-description %}  
Returns a list of prices from a list of assets addresses  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="assets_len" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="assets" %}  
The list of assets addresses  
{% endswagger-parameter %}  
{% swagger-response status="prices_len ( felt )" description="" %}  
{% endswagger-response %}  
{% swagger-response status="prices ( felt* )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_ticker_of_asset" %}  
{% swagger-description %}  
Returns the address of the ticker for an asset address  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="asset" %}  
The address of the asset  
{% endswagger-parameter %}  
{% swagger-response status="ticker ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_fallback_oracle" %}  
{% swagger-description %}  
Returns the address of the fallback oracle  
{% endswagger-description %}  
{% swagger-response status="fallback_oracle ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}