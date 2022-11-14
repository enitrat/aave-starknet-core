
A_token_library
===============
  
{% swagger method = "event" path = " " baseUrl = " " summary = "Transfer" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="from_" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="to" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256" name="value" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "event" path = " " baseUrl = " " summary = "BalanceTransfer" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="from_" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="to" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256" name="amount" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256" name="index" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "event" path = " " baseUrl = " " summary = "Initialized" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="underlying_asset" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="pool" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="treasury" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="incentives_controller" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="a_token_decimals" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="a_token_name" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="a_token_symbol" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "st0rage" path = " " baseUrl = " " summary = "AToken_treasury" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="res ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "st0rage" path = " " baseUrl = " " summary = "AToken_underlying_asset" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="res ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "st0rage" path = " " baseUrl = " " summary = "AToken_pool" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="res ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "st0rage" path = " " baseUrl = " " summary = "AToken_incentives_controller" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="res ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "assert_only_pool" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "assert_only_pool_admin" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "initializer" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="pool" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="treasury" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="underlying_asset" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="incentives_controller" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="a_token_decimals" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="a_token_name" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="a_token_symbol" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "mint" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="caller" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="on_behalf_of" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256" name="amount" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256" name="index" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "burn" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="from_" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="receiver_or_underlying" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256" name="amount" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256" name="index" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="success ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "transfer_on_liquidation" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="from_" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="to" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256" name="value" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "balance_of" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="user" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="balance ( Uint256 )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "total_supply" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="supply ( Uint256 )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "transfer_underlying_to" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="target" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256" name="amount" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "handle_repayment" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "rescue_tokens" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="token" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="to" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256" name="amount" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "RESERVE_TREASURY_ADDRESS" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="res ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "UNDERLYING_ASSET_ADDRESS" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="res ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "POOL" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="res ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_incentives_controller" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="res ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "DOMAIN_SEPARATOR" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "_EIP712BaseId" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "_transfer" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="from_" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="to" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256" name="amount" %}  
  
{% endswagger-parameter %}  
{% endswagger %}