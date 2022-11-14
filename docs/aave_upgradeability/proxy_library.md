
Proxy_library
=============
  
{% swagger method = "event" path = " " baseUrl = " " summary = "Upgraded" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="implementation" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "event" path = " " baseUrl = " " summary = "AdminChanged" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="previous_admin" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="new_admin" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "st0rage" path = " " baseUrl = " " summary = "Proxy_implementation_hash" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="class_hash ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "st0rage" path = " " baseUrl = " " summary = "Proxy_admin" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="proxy_admin ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "st0rage" path = " " baseUrl = " " summary = "Proxy_initialized" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="initialized ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "assert_only_admin" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "assert_not_admin" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_implementation_hash" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="implementation ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_initialized" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="implementation ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_admin" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="admin ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "_set_admin" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="new_admin" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "_set_implementation_hash" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="new_implementation_hash" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "_set_initialized" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% endswagger %}