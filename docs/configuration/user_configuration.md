
User_configuration
==================
  
{% swagger method = "internal" path = " " baseUrl = " " summary = "set_borrowing" %}  
{% swagger-description %}  
Sets if the user is borrowing the reserve identified by reserve_index  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="user_address" %}  
The address of a user  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="reserve_index" %}  
The index of the reserve object  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="borrowing" %}  
TRUE if user is borrowing the reserve, FALSE otherwise  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "set_using_as_collateral" %}  
{% swagger-description %}  
Sets if the user is using as collateral the reserve identified by reserve_index  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="user_address" %}  
The address of a user  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="reserve_index" %}  
The index of the reserve object  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="using_as_collateral" %}  
TRUE if user is using the reserve as collateral, FALSE otherwise  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "is_using_as_collateral_or_borrowing" %}  
{% swagger-description %}  
Returns if a user has been using the reserve for borrowing or as collateral  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="user_address" %}  
The address of a user  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="reserve_index" %}  
The index of the reserve object  
{% endswagger-parameter %}  
{% swagger-response status="res ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "is_borrowing" %}  
{% swagger-description %}  
Validate a user has been using the reserve for borrowing  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="user_address" %}  
The address of a user  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="reserve_index" %}  
The index of the reserve object  
{% endswagger-parameter %}  
{% swagger-response status="res ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "is_using_as_collateral" %}  
{% swagger-description %}  
Validate a user has been using the reserve as collateral  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="user_address" %}  
The address of a user  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="reserve_index" %}  
The index of the reserve object  
{% endswagger-parameter %}  
{% swagger-response status="res ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "is_using_as_collateral_one" %}  
{% swagger-description %}  
Checks if a user has been supplying only one reserve as collateral  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="user_address" %}  
The address of a user  
{% endswagger-parameter %}  
{% swagger-response status="res ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "is_using_as_collateral_any" %}  
{% swagger-description %}  
Checks if a user has been supplying any reserve as collateral  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="user_address" %}  
The address of a user  
{% endswagger-parameter %}  
{% swagger-response status="res ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "is_borrowing_one" %}  
{% swagger-description %}  
Checks if a user has been borrowing only one asset  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="user_address" %}  
The address of a user  
{% endswagger-parameter %}  
{% swagger-response status="res ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "is_borrowing_any" %}  
{% swagger-description %}  
Checks if a user has been borrowing from any reserve  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="user_address" %}  
The address of a user  
{% endswagger-parameter %}  
{% swagger-response status="res ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "is_empty" %}  
{% swagger-description %}  
Checks if a user has not been using any reserve for borrowing or supply  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="user_address" %}  
The address of a user  
{% endswagger-parameter %}  
{% swagger-response status="res ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_isolation_mode_state" %}  
{% swagger-description %}  
Returns the Isolation Mode state of the user  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="user_address" %}  
The address of a user  
{% endswagger-parameter %}  
{% swagger-response status="bool ( felt )" description="" %}  
{% endswagger-response %}  
{% swagger-response status="asset_address ( felt )" description="" %}  
{% endswagger-response %}  
{% swagger-response status="ceilling ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_siloed_borrowing_state" %}  
{% swagger-description %}  
Returns the siloed borrowing state for the user  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="user_address" %}  
The address of a user  
{% endswagger-parameter %}  
{% swagger-response status="bool ( felt )" description="" %}  
{% endswagger-response %}  
{% swagger-response status="asset_address ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_first_asset_by_type" %}  
{% swagger-description %}  
Returns the address of the first asset (lowest index) flagged given the corresponding type (borrowing/using as collateral)  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="user_address" %}  
The address of a user  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="type" %}  
The type of asset: BORROWING_TYPE or USING_AS_COLLATERAL_TYPE  
{% endswagger-parameter %}  
{% swagger-response status="res ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}