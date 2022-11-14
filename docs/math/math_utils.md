
Math_utils
==========
  
{% swagger method = "internal" path = " " baseUrl = " " summary = "calculate_linear_interest" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="rate" %}  
The interest rate, in ray  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="last_update_timestamp" %}  
The timestamp of the last update of the interest  
{% endswagger-parameter %}  
{% swagger-response status="Uint256 (  )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "calculate_compounded_interest" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="rate" %}  
The interest rate (in ray)  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="last_update_timestamp" %}  
The timestamp from which the interest accumulation needs to be calculated  
{% endswagger-parameter %}  
{% swagger-response status="Uint256 (  )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "_calculate_compounded_interest" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="rate" %}  
The interest rate, in ray  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="last_update_timestamp" %}  
The timestamp of the last update of the interest  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="current_timestamp" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="Uint256 (  )" description="" %}  
{% endswagger-response %}  
{% endswagger %}