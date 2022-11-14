
Aave_oracle
===========
  
{% swagger method = "view" path = " " baseUrl = " " summary = "ADDRESSES_PROVIDER" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="provider ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "BASE_CURRENCY" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="base_currency ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "BASE_CURRENCY_UNIT" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="base_currency_unit ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "get_asset_price" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="asset" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="price ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "get_assets_prices" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="assets_len" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt*" name="assets" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="prices_len ( felt )" description="" %}  
{% endswagger-response %}  
{% swagger-response status="prices ( felt* )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "get_ticker_of_asset" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="asset" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="ticker ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "get_fallback_oracle" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="fallback_oracle ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "initialize" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="provider" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="oracle_address" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="assets_len" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt*" name="assets" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="tickers_len" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt*" name="tickers" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="fallback_oracle" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="base_currency" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="base_currency_unit" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "set_assets_tickers" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="assets_len" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt*" name="assets" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="tickers_len" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt*" name="tickers" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "set_fallback_oracle" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="fallback_oracle" %}  
  
{% endswagger-parameter %}  
{% endswagger %}