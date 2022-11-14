
Scaled_balance_token_library
============================
  
{% swagger method = "event" path = " " baseUrl = " " summary = "Mint" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="caller" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="on_behalf_of" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256" name="amount_to_mint" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256" name="balance_increase" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="index" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "event" path = " " baseUrl = " " summary = "Burn" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="user" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="target" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256" name="amount_to_burn" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256" name="balance_decrease" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="index" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "mint_scaled" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="caller" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="on_behalf_of" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256" name="amount" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="index" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="success ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "burn_scaled" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="user" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="target" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256" name="amount" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="index" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_scaled_user_balance_and_supply" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="user" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="balance ( Uint256 )" description="" %}  
{% endswagger-response %}  
{% swagger-response status="supply ( Uint256 )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_previous_index" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="user" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="index ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}