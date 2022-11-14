
Pool_configurator_library
=========================
  
{% swagger method = "event" path = " " baseUrl = " " summary = "ReserveDropped" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="asset" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "event" path = " " baseUrl = " " summary = "ReserveBorrowing" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="asset" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="enabled" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "st0rage" path = " " baseUrl = " " summary = "PoolConfigurator_pool" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="res ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "st0rage" path = " " baseUrl = " " summary = "PoolConfigurator_addresses_provider" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="res ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "assert_only_pool_admin" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "assert_only_emergency_admin" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "assert_only_pool_or_emergency_admin" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "assert_only_asset_listing_or_pool_admins" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "assert_only_risk_or_pool_admins" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "initialize" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="provider" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "drop_reserve" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="asset" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "set_reserve_borrowing" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="asset" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="enabled" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_revision" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="revision ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_pool" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="pool ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_addresses_provider" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="addresses_provider ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}