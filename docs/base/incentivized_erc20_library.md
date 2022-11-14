
Incentivized_erc20_library
==========================
  
{% swagger method = "st0rage" path = " " baseUrl = " " summary = "IncentivizedERC20_pool" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="pool ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "st0rage" path = " " baseUrl = " " summary = "IncentivizedERC20_allowances" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="delegator" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="delegatee" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="allowance ( Uint256 )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "st0rage" path = " " baseUrl = " " summary = "IncentivizedERC20_total_supply" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="total_supply ( Uint256 )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "st0rage" path = " " baseUrl = " " summary = "IncentivizedERC20_incentives_controller" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="incentives_controller ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "st0rage" path = " " baseUrl = " " summary = "IncentivizedERC20_addresses_provider" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="addresses_provider ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "st0rage" path = " " baseUrl = " " summary = "IncentivizedERC20_owner" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="owner ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "assert_only_pool_admin" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "assert_only_pool" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_pool" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="pool ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_incentives_controller" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="incentives_controller ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "total_supply" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="total_supply ( Uint256 )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_user_state" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="account" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="state ( DataTypes )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "balance_of" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="account" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="balance ( Uint256 )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "allowance" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="owner" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="spender" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="remaining ( Uint256 )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "set_balance" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="account" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="balance" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "set_additional_data" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="account" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="additional_data" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "set_total_supply" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="Uint256" name="total_supply" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "set_incentives_controller" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="incentives_controller" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "initialize" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="pool" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="name" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="symbol" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="decimals" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "transfer" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="recipient" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256" name="amount" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="success ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "transfer_from" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="sender" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="recipient" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256" name="amount" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="success ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "approve" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="spender" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256" name="amount" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "increase_allowance" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="spender" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256" name="added_value" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="success ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "decrease_allowance" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="spender" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256" name="subtracted_value" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="success ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "_set_incentives_controller" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="incentives_controller" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "_transfer" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="sender" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="recipient" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256" name="amount" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "_approve" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="owner" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="spender" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256" name="amount" %}  
  
{% endswagger-parameter %}  
{% endswagger %}