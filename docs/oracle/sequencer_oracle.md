
Sequencer_oracle
================
  
{% swagger method = "c0nstruct0r" path = " " baseUrl = " " summary = "constructor" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="owner" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "set_answer" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="is_down" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="timestamp" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "latest_round_data" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="round_id ( felt )" description="" %}  
{% endswagger-response %}  
{% swagger-response status="answer ( felt )" description="" %}  
{% endswagger-response %}  
{% swagger-response status="started_at ( felt )" description="" %}  
{% endswagger-response %}  
{% swagger-response status="update_at ( felt )" description="" %}  
{% endswagger-response %}  
{% swagger-response status="answered_in_round ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}