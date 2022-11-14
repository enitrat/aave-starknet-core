
Price_oracle_sentinel_library
=============================
  
{% swagger method = "event" path = " " baseUrl = " " summary = "SequencerOracleUpdated" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="new_sequencer_oracle" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "event" path = " " baseUrl = " " summary = "GracePeriodUpdated" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="new_grace_period" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "st0rage" path = " " baseUrl = " " summary = "PriceOracleSentinel_addresses_provider" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="provider ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "st0rage" path = " " baseUrl = " " summary = "PriceOracleSentinel_sequencer_oracle" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="sequencer_address ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "st0rage" path = " " baseUrl = " " summary = "PriceOracleSentinel_grace_period" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="grace_period ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "initializer" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="addresses_provider" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="oracle_sentinel" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="grace_period" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "is_borrow_allowed" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="bool ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "is_liquidation_allowed" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="bool ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "_is_up_and_grace_period_passed" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="bool ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "set_sequencer_oracle" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="new_sequencer_oracle" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "set_grace_period" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="new_grace_period" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_sequencer_oracle" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="sequencer_oracle ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_grace_period" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="grace_period ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "ADDRESSES_PROVIDER" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="addresses_provider ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}