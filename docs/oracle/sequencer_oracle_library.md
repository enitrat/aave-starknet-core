
Sequencer_oracle_library
========================
  
{% swagger method = "st0rage" path = " " baseUrl = " " summary = "SequencerOracle_is_down" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="is_down ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "st0rage" path = " " baseUrl = " " summary = "SequencerOracle_timestamp_got_up" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="timestamp ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "initializer" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="owner" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "set_answer" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="is_down" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="timestamp" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "latest_round_data" %}  
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