
Reserve_configuration
=====================
  
{% swagger method = "internal" path = " " baseUrl = " " summary = "set_ltv" %}  
{% swagger-description %}  
Sets the Loan to Value of the reserve  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="reserve_asset" %}  
underlying asset of the reserve  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="value" %}  
The new ltv  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_ltv" %}  
{% swagger-description %}  
Gets the Loan to Value of the reserve  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="reserve_asset" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="value ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "set_liquidation_threshold" %}  
{% swagger-description %}  
Sets the liquidation threshold of the reserve  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="reserve_asset" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="value" %}  
The new liquidation threshold  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_liquidation_threshold" %}  
{% swagger-description %}  
Gets the liquidation threshold of the reserve  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="reserve_asset" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="value ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "set_liquidation_bonus" %}  
{% swagger-description %}  
Sets the liquidation bonus of the reserve  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="reserve_asset" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="value" %}  
The new liquidation bonus  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_liquidation_bonus" %}  
{% swagger-description %}  
Gets the liquidation bonus of the reserve  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="reserve_asset" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="value ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "set_decimals" %}  
{% swagger-description %}  
Sets the decimals of the underlying asset of the reserve  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="reserve_asset" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="value" %}  
The decimals  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_decimals" %}  
{% swagger-description %}  
Gets the decimals of the underlying asset of the reserve  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="reserve_asset" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="value ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "set_active" %}  
{% swagger-description %}  
Sets the active state of the reserve  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="reserve_asset" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="active" %}  
The active state  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_active" %}  
{% swagger-description %}  
Gets the active state of the reserve  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="reserve_asset" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="value ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "set_frozen" %}  
{% swagger-description %}  
Sets the frozen state of the reserve  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="reserve_asset" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="frozen" %}  
The frozen state  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_frozen" %}  
{% swagger-description %}  
Gets the frozen state of the reserve  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="reserve_asset" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="value ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "set_paused" %}  
{% swagger-description %}  
Sets the paused state of the reserve  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="reserve_asset" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="paused" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_paused" %}  
{% swagger-description %}  
Gets the paused state of the reserve  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="reserve_asset" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="value ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "set_borrowable_in_isolation" %}  
{% swagger-description %}  
Sets the borrowable in isolation flag for the reserve  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="reserve_asset" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="borrowable" %}  
True if the asset is borrowable  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_borrowable_in_isolation" %}  
{% swagger-description %}  
Gets the borrowable in isolation flag for the reserve.  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="reserve_asset" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="value ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "set_siloed_borrowing" %}  
{% swagger-description %}  
Sets the siloed borrowing flag for the reserve.  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="reserve_asset" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="siloed" %}  
True if the asset is siloed  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_siloed_borrowing" %}  
{% swagger-description %}  
Gets the siloed borrowing flag for the reserve.  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="reserve_asset" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="value ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "set_borrowing_enabled" %}  
{% swagger-description %}  
Enables or disables borrowing on the reserve  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="reserve_asset" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="enabled" %}  
True if the borrowing needs to be enabled, false otherwise  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_borrowing_enabled" %}  
{% swagger-description %}  
Gets the borrowing state of the reserve  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="reserve_asset" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="value ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "set_stable_rate_borrowing_enabled" %}  
{% swagger-description %}  
Enables or disables stable rate borrowing on the reserve  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="reserve_asset" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="enabled" %}  
True if the stable rate borrowing needs to be enabled, false otherwise  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_stable_rate_borrowing_enabled" %}  
{% swagger-description %}  
Gets the stable rate borrowing state of the reserve  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="reserve_asset" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="value ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "set_reserve_factor" %}  
{% swagger-description %}  
Sets the reserve factor of the reserve  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="reserve_asset" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="value" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_reserve_factor" %}  
{% swagger-description %}  
Gets the reserve factor of the reserve  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="reserve_asset" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="value ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "set_borrow_cap" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="reserve_asset" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="value" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_borrow_cap" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="reserve_asset" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="value ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "set_supply_cap" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="reserve_asset" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="value" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_supply_cap" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="reserve_asset" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="value ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "set_debt_ceiling" %}  
{% swagger-description %}  
Sets the debt ceiling in isolation mode for the asset  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="reserve_asset" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="ceiling" %}  
The maximum debt ceiling for the asset  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_debt_ceiling" %}  
{% swagger-description %}  
Gets the debt ceiling for the asset if the asset is in isolation mode  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="reserve_asset" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="value ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "set_liquidation_protocol_fee" %}  
{% swagger-description %}  
Sets the liquidation protocol fee of the reserve  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="reserve_asset" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="value" %}  
The liquidation protocol fee  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_liquidation_protocol_fee" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="reserve_asset" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="value ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "set_unbacked_mint_cap" %}  
{% swagger-description %}  
Sets the unbacked mint cap of the reserve  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="reserve_asset" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="value" %}  
The unbacked mint cap  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_unbacked_mint_cap" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="reserve_asset" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="value ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "set_e_mode_category" %}  
{% swagger-description %}  
Sets the e_mode asset category  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="reserve_asset" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="category" %}  
The asset category when the user selects the e_mode  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_e_mode_category" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="reserve_asset" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="value ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_flags" %}  
{% swagger-description %}  
Gets the configuration flags of the reserve  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="reserve_asset" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="is_active ( felt )" description="" %}  
{% endswagger-response %}  
{% swagger-response status="is_frozen ( felt )" description="" %}  
{% endswagger-response %}  
{% swagger-response status="is_borrowing_enabled ( felt )" description="" %}  
{% endswagger-response %}  
{% swagger-response status="is_stable_rate_borrowing_enabled ( felt )" description="" %}  
{% endswagger-response %}  
{% swagger-response status="is_paused ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_params" %}  
{% swagger-description %}  
Gets the configuration parameters of the reserve from storage  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="reserve_asset" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="ltv_value ( felt )" description="" %}  
{% endswagger-response %}  
{% swagger-response status="liquidation_threshold_value ( felt )" description="" %}  
{% endswagger-response %}  
{% swagger-response status="liquidation_bonus_value ( felt )" description="" %}  
{% endswagger-response %}  
{% swagger-response status="decimals_value ( felt )" description="" %}  
{% endswagger-response %}  
{% swagger-response status="reserve_factor_value ( felt )" description="" %}  
{% endswagger-response %}  
{% swagger-response status="e_mode_category_value ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_caps" %}  
{% swagger-description %}  
Gets the caps parameters of the reserve from storage  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="reserve_asset" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="borrow_cap ( felt )" description="" %}  
{% endswagger-response %}  
{% swagger-response status="supply_cap ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}