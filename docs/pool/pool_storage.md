
Pool_storage
============
  
{% swagger method = "st0rage" path = " " baseUrl = " " summary = "PoolStorage_addresses_provider" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="address ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "st0rage" path = " " baseUrl = " " summary = "PoolStorage_reserves_list" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="reserve_id" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="address ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "st0rage" path = " " baseUrl = " " summary = "PoolStorage_users_e_mode_category" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="user_address" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="category_id ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "st0rage" path = " " baseUrl = " " summary = "PoolStorage_bridge_protocol_fee" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="bps ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "st0rage" path = " " baseUrl = " " summary = "PoolStorage_flash_loan_premium_total" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="bps ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "st0rage" path = " " baseUrl = " " summary = "PoolStorage_flash_loan_premium_to_protocol" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="bps ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "st0rage" path = " " baseUrl = " " summary = "PoolStorage_max_stable_rate_borrow_size_percent" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="bps ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "st0rage" path = " " baseUrl = " " summary = "PoolStorage_reserves_count" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="count ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "addresses_provider_read" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="address ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "reserves_read" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="address" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="reserve_data ( DataTypes )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "reserves_config_read" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="address" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="res_config ( DataTypes )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "users_config_read" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="user_address" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="reserve_id" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="user_config ( DataTypes )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "reserves_list_read" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="reserve_id" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="address ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "users_e_mode_category_read" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="user_address" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="category_id ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "e_mode_categories_read" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="category_id" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="category ( DataTypes )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "bridge_protocol_fee_read" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="bps ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "flash_loan_premium_total_read" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="bps ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "flash_loan_premium_to_protocol_read" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="bps ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "max_stable_rate_borrow_size_percent_read" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="bps ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "reserves_count_read" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="count ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "addresses_provider_write" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="address" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "reserves_list_write" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="reserve_id" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="address" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "users_e_mode_category_write" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="user_address" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="category_id" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "bridge_protocol_fee_write" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="bps" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "flash_loan_premium_total_write" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="bps" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "flash_loan_premium_to_protocol_write" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="bps" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "max_stable_rate_borrow_size_percent_write" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="bps" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "reserves_count_write" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="count" %}  
  
{% endswagger-parameter %}  
{% endswagger %}