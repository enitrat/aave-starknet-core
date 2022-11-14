
Safe_felt_math
==============
  
{% swagger method = "internal" path = " " baseUrl = " " summary = "add_unsigned" %}  
{% swagger-description %}  
Adds two integers, and returns output. Interprets a, b in range [0, P)  
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
{% swagger method = "internal" path = " " baseUrl = " " summary = "sub_le_unsigned" %}  
{% swagger-description %}  
Subtracts two integers, and return output and underflow flag. Interprets a, b in range [0, P)  
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
{% swagger method = "internal" path = " " baseUrl = " " summary = "mul_unsigned" %}  
{% swagger-description %}  
Multiplies two integers, and return output and overflow flag. Interprets a, b in range [0, P)  
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
{% swagger method = "internal" path = " " baseUrl = " " summary = "pow_unsigned" %}  
{% swagger-description %}  
Calculates exponention of an integer, and return output and an overflow flag. Interprets base, power in range [0, P)  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="base" %}  
Unsigned felt integer  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="power" %}  
Unsigned felt integer  
{% endswagger-parameter %}  
{% swagger-response status="felt (  )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "add_mul_unsigned" %}  
{% swagger-description %}  
Adds two integers and multiplies result by last integer, and returns output. Interprets a, b and c in range [0, P)  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="a" %}  
Unsigned felt integer  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="b" %}  
Unsigned felt integer  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="c" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="felt (  )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "mul_add_unsigned" %}  
{% swagger-description %}  
Multiplies two integers and adds result to the last integer, and returns output. Interprets a, b and c in range [0, P)  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="a" %}  
Unsigned felt integer  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="b" %}  
Unsigned felt integer  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="c" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="felt (  )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "add_signed" %}  
{% swagger-description %}  
Adds two integers, and return output and carry. Interprets a, b in range [-(P-1)/2, (P-1)/2]  
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
{% swagger method = "internal" path = " " baseUrl = " " summary = "sub_signed" %}  
{% swagger-description %}  
Subtracts two integers, and return output and underflow flag. Interprets a, b in range [-P/2, P/2]  
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