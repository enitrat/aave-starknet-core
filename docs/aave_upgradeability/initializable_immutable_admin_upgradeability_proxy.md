
Initializable_immutable_admin_upgradeability_proxy
==================================================
  
{% swagger method = "c0nstruct0r" path = " " baseUrl = " " summary = "constructor" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="proxy_admin" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "get_admin" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="admin ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "get_implementation" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="implementation ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "initialize" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="implementation_class_hash" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="selector" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="calldata_len" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt*" name="calldata" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="retdata_len ( felt )" description="" %}  
{% endswagger-response %}  
{% swagger-response status="retdata ( felt* )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "upgrade_to_and_call" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="implementation_class_hash" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="selector" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="calldata_len" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt*" name="calldata" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="retdata_len ( felt )" description="" %}  
{% endswagger-response %}  
{% swagger-response status="retdata ( felt* )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "upgrade_to" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="implementation_class_hash" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "change_proxy_admin" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="new_admin" %}  
  
{% endswagger-parameter %}  
{% endswagger %}