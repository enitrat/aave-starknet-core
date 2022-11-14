
Configurator_logic
==================
  
{% swagger method = "event" path = " " baseUrl = " " summary = "ReserveInitialized" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="asset" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="a_token" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="stable_debt_token" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="variable_debt_token" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="interest_rate_strategy_address" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "event" path = " " baseUrl = " " summary = "ATokenUpgraded" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="asset" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="proxy" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="implementation" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "event" path = " " baseUrl = " " summary = "StableDebtTokenUpgraded" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="asset" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="proxy" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="implementation" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "event" path = " " baseUrl = " " summary = "VariableDebtTokenUpgraded" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="asset" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="proxy" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="implementation" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "_init_token_with_proxy" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="implementation_class_hash" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="proxy_class_hash" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="salt" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="params_len" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt*" name="params" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="proxy_address ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "_upgrade_token_implementation" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="proxy_address" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="implementation_class_hash" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="selector" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="params_len" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt*" name="params" %}  
  
{% endswagger-parameter %}  
{% endswagger %}