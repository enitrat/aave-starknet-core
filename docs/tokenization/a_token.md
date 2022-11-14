
A_token
=======
  
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
{% swagger method = "view" path = " " baseUrl = " " summary = "totalSupply" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="totalSupply ( Uint256 )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "decimals" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="decimals ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "balanceOf" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="account" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="balance ( Uint256 )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "allowance" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="owner" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="spender" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="remaining ( Uint256 )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "RESERVE_TREASURY_ADDRESS" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="res ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "UNDERLYING_ASSET_ADDRESS" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="res ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "POOL" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="res ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "get_incentives_controller" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="res ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "initialize" %}  
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
{% swagger method = "external" path = " " baseUrl = " " summary = "transfer" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="recipient" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256" name="amount" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="success ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "transferFrom" %}  
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
{% swagger method = "external" path = " " baseUrl = " " summary = "approve" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="spender" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256" name="amount" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="success ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "increaseAllowance" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="spender" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256" name="added_value" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="success ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "decreaseAllowance" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="spender" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256" name="subtracted_value" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="success ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "mint" %}  
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
{% swagger-response status="success ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "burn" %}  
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
{% swagger method = "external" path = " " baseUrl = " " summary = "burn" %}  
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
{% swagger method = "external" path = " " baseUrl = " " summary = "mint_to_treasury" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="Uint256" name="amount" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256" name="index" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="success ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "transfer_on_liquidation" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="from_" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="to" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256" name="value" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "transfer_underlying_to" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="target" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256" name="amount" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "handle_repayment" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "permit" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "rescue_tokens" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="token" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="to" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256" name="amount" %}  
  
{% endswagger-parameter %}  
{% endswagger %}