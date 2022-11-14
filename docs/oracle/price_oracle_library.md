
Price_oracle_library
====================
  
{% swagger method = "event" path = " " baseUrl = " " summary = "AssetPriceUpdated" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="asset" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="price" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="timestamp" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "event" path = " " baseUrl = " " summary = "EthPriceUpdated" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="price" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="timestamp" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "st0rage" path = " " baseUrl = " " summary = "PriceOracle_assets_prices" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="asset" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="price ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "st0rage" path = " " baseUrl = " " summary = "PriceOracle_eth_price_usd" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="price ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_asset_price" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="asset" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="price ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "set_asset_price" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="asset" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="price" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_eth_usd_price" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="price ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "set_eth_usd_price" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="price" %}  
  
{% endswagger-parameter %}  
{% endswagger %}