
Variable_debt_token
===================
  
{% swagger method = "view" path = " " baseUrl = " " summary = "borrow_allowance" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="from_user" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="to_user" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="allowance ( Uint256 )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "UNDERLYING_ASSET_ADDRESS" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="underlying ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "name" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="name ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "symbol" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="symbol ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "decimals" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="decimals ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "get_incentives_controller" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="incentives_controller ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "POOL" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="pool ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "scaled_balance_of" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="user" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="balance ( Uint256 )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "scaled_total_supply" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="total_supply ( Uint256 )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "get_scaled_user_balance_and_supply" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="user" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="balance ( Uint256 )" description="" %}  
{% endswagger-response %}  
{% swagger-response status="supply ( Uint256 )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "get_previous_index" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="user" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="index ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "get_revision" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="revision ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "balance_of" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="user" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="balance ( Uint256 )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "total_supply" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="total_supply ( Uint256 )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "initialize" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="initializing_pool" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="underlying_asset" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="incentives_controller" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="debt_token_decimals" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="debt_token_name" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="debt_token_symbol" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="params" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "approve_delegation" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="delegatee" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256" name="amount" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "set_incentives_controller" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="incentives_controller" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "mint" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="user" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="on_behalf_of" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256" name="amount" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="index" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="is_scaled_balance_null ( felt )" description="" %}  
{% endswagger-response %}  
{% swagger-response status="total_supply ( Uint256 )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "burn" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="address_from" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256" name="amount" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="index" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="total_supply ( Uint256 )" description="" %}  
{% endswagger-response %}  
{% endswagger %}