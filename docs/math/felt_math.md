
Felt_math
=========
  
{% swagger method = "internal" path = " " baseUrl = " " summary = "add_unsigned" %}  
{% swagger-description %}  
Adds two integers, and return output and carry. Interprets a, b in range [0, P)  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="a" %}  
Unsigned felt integer  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="b" %}  
Unsigned felt integer  
{% endswagger-parameter %}  
{% swagger-response status="res ( felt )" description="" %}  
{% endswagger-response %}  
{% swagger-response status="carry ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "sub_unsigned" %}  
{% swagger-description %}  
Subtracts two integers, and return output and underflow flag. Interprets a, b in range [0, P)  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="a" %}  
Unsigned felt integer  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="b" %}  
Unsigned felt integer  
{% endswagger-parameter %}  
{% swagger-response status="res ( felt )" description="" %}  
{% endswagger-response %}  
{% swagger-response status="underflow ( felt )" description="" %}  
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
{% swagger-response status="res ( felt )" description="" %}  
{% endswagger-response %}  
{% swagger-response status="overflow ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "div_unsigned" %}  
{% swagger-description %}  
Divides two felts, and return the quotient and the remainder. Interprets a, b in range [0, P)  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="a" %}  
Unsigned felt integer  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="b" %}  
Unsigned felt integer  
{% endswagger-parameter %}  
{% swagger-response status="q ( felt )" description="" %}  
{% endswagger-response %}  
{% swagger-response status="r ( felt )" description="" %}  
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
{% swagger-response status="res ( felt )" description="" %}  
{% endswagger-response %}  
{% swagger-response status="overflow ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "_pow_inner" %}  
{% swagger-description %}  
Inner function to pow_unsigned  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="acc" %}  
Accumulated result from the previous recursive calls  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="flag_overflow" %}  
Bool flag indicating if overflow happened  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="base" %}  
Unsigned integer - base of exponantion  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="counter" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="res ( felt )" description="" %}  
{% endswagger-response %}  
{% swagger-response status="overflow ( felt )" description="" %}  
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
{% swagger-response status="res ( felt )" description="" %}  
{% endswagger-response %}  
{% swagger-response status="carry ( felt )" description="" %}  
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
{% swagger-response status="res ( felt )" description="" %}  
{% endswagger-response %}  
{% swagger-response status="carry ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}