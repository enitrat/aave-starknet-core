
E_mode_logic
============
  
{% swagger method = "event" path = " " baseUrl = " " summary = "UserEModeSet" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="user" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="category_id" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "execute_set_user_emode" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "is_in_e_mode_category" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="e_mode_user_category" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="e_mode_asset_category" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="is_in_e_mode ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}