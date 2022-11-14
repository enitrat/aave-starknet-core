
Safe_cmp
========
  
{% swagger method = "internal" path = " " baseUrl = " " summary = "is_le_unsigned" %}  
{% swagger-description %}  
Checks if the a <= b. Interprets a, b in range [0, P)  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="a" %}  
Unsigned felt integer  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="b" %}  
Unsigned felt integer  
{% endswagger-parameter %}  
{% swagger-response status="felt (  )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "is_lt_unsigned" %}  
{% swagger-description %}  
Checks if the a < b. Interprets a, b in range [0, P)  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="a" %}  
Unsigned felt integer  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="b" %}  
Unsigned felt integer  
{% endswagger-parameter %}  
{% swagger-response status="felt (  )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "is_in_range_unsigned" %}  
{% swagger-description %}  
Checks if the vale is in range [low, high). Interprets value, low, high in range [0, P)  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="value" %}  
Unsigned felt integer, checked if is in range  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="low" %}  
Unsigned felt integer, lower bound of the range  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="high" %}  
Unsigned felt integer, upper bound of the range  
{% endswagger-parameter %}  
{% swagger-response status="felt (  )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "assert_le_unsigned" %}  
{% swagger-description %}  
Asserts that a <= b. Interprets a, b in range [0, P)  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="a" %}  
Unsigned felt integer  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="b" %}  
Unsigned felt integer  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "assert_lt_unsigned" %}  
{% swagger-description %}  
Asserts that a < b. Interprets a, b in range [0, P)  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="a" %}  
Unsigned felt integer  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="b" %}  
Unsigned felt integer  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "assert_in_range_unsigned" %}  
{% swagger-description %}  
Asserts that the value is in range [low, high). Interprets value, low, high in range [0, P)  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="value" %}  
Unsigned felt integer, checked if is in range  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="low" %}  
Unsigned felt integer, lower bound of the range  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="high" %}  
Unsigned felt integer, upper bound of the range  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "is_nn_signed" %}  
{% swagger-description %}  
Checks if the value is non-negative integer, i.e. 0 <= value < floor(P/2) + 1. Interprets a in range [floor(-P/2), floor(P/2)]  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="value" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="felt (  )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "is_le_signed" %}  
{% swagger-description %}  
Checks if the a <= b. Interprets a, b in range [floor(-P/2), floor(P/2)] (Recall : floor(P/2) = (P-1)/2)  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="a" %}  
Signed felt integer  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="b" %}  
Signed felt integer  
{% endswagger-parameter %}  
{% swagger-response status="felt (  )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "is_lt_signed" %}  
{% swagger-description %}  
Checks if the a < b. Interprets a, b in range [floor(-P/2), floor(P/2)]  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="a" %}  
Signed felt integer  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="b" %}  
Signed felt integer  
{% endswagger-parameter %}  
{% swagger-response status="felt (  )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "is_in_range_signed" %}  
{% swagger-description %}  
Checks if the [low, high). Interprets value, low, high in range [floor(-P/2), floor(P/2)]  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="value" %}  
Signed felt integer, checked if is in range  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="low" %}  
Signed felt integer, lower bound of the range  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="high" %}  
Signed felt integer, upper bound of the range  
{% endswagger-parameter %}  
{% swagger-response status="felt (  )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "assert_nn_signed" %}  
{% swagger-description %}  
Asserts that a is non-negative integer, i.e. 0 <= a < floor(P/2) + 1. Interprets a in range [floor(-P/2), floor(P/2)]  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="value" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "assert_le_signed" %}  
{% swagger-description %}  
Asserts that a <= b. Interprets a, b in range [floor(-P/2), floor(P/2)]  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="a" %}  
Signed felt integer  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="b" %}  
Signed felt integer  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "assert_lt_signed" %}  
{% swagger-description %}  
Asserts that a < b. Interprets a, b in range [floor(-P/2), floor(P/2)]  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="a" %}  
Signed felt integer  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="b" %}  
Signed felt integer  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "assert_in_range_signed" %}  
{% swagger-description %}  
Asserts that the value is in [low, high). Interprets value, low, high in range [floor(-P/2), floor(P/2)]  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="value" %}  
Signed felt integer, checked if is in range  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="low" %}  
Signed felt integer, lower bound of the range  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="high" %}  
Signed felt integer, upper bound of the range  
{% endswagger-parameter %}  
{% endswagger %}