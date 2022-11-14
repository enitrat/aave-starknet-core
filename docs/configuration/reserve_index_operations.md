
Reserve_index_operations
========================
  
{% swagger method = "st0rage" path = " " baseUrl = " " summary = "ReserveIndex_index" %}  
{% swagger-description %}  
Stores indices of reserve assets in a packed list  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="type" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="slot" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="user_address" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="index ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "add_reserve_index" %}  
{% swagger-description %}  
Adds reserve index at the end of the list in ReserveIndex_index  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="type" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="user_address" %}  
The address of a user  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="index" %}  
The index of the reserve object  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "remove_reserve_index" %}  
{% swagger-description %}  
Removes reserve index the list in ReserveIndex_index, by reserve index not by slot number  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="type" %}  
Type of reserve asset: BORROWING_TYPE or USING_AS_COLLATERAL_TYPE  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="user_address" %}  
The address of a user  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="index" %}  
The index of the reserve object  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "remove_reserve_index_inner" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="type" %}  
Type of reserve asset: BORROWING_TYPE or USING_AS_COLLATERAL_TYPE  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="slot" %}  
Number representing slot in the list  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="user_address" %}  
The address of a user  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="index" %}  
The index of the reserve object  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_reserve_index" %}  
{% swagger-description %}  
Returns reserve index of given type, slot and user address  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="type" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="slot" %}  
Number representing slot in the list  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="user_address" %}  
The address of a user  
{% endswagger-parameter %}  
{% swagger-response status="index ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "is_list_empty" %}  
{% swagger-description %}  
Checks is list of given slot and user address is empty  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="type" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="user_address" %}  
The address of a user  
{% endswagger-parameter %}  
{% swagger-response status="res ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "is_only_one_element" %}  
{% swagger-description %}  
Checks if list of given slot and user address has only one element  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="type" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="user_address" %}  
The address of a user  
{% endswagger-parameter %}  
{% swagger-response status="res ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_lowest_reserve_index" %}  
{% swagger-description %}  
Returns reserve index with the lowest value  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="type" %}  
Type of reserve asset: BORROWING_TYPE or USING_AS_COLLATERAL_TYPE  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="user_address" %}  
The address of a user  
{% endswagger-parameter %}  
{% swagger-response status="lowest_index ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_lowest_reserve_index_internal" %}  
{% swagger-description %}  
Internal recursive function to get_lowest_reserve_index  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="type" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="slot" %}  
Number representing slot in the list  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="user_address" %}  
The address of a user  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="last_lowest_index" %}  
Last lowest reserve index  
{% endswagger-parameter %}  
{% swagger-response status="lowest_index ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_last_slot" %}  
{% swagger-description %}  
Finds last slot of a list and returns slot nunmber with corresonding value (index)  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="type" %}  
Type of reserve asset: BORROWING_TYPE or USING_AS_COLLATERAL_TYPE  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="user_address" %}  
The address of a user  
{% endswagger-parameter %}  
{% swagger-response status="slot ( felt )" description="" %}  
{% endswagger-response %}  
{% swagger-response status="index ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_last_slot_inner" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="type" %}  
Type of reserve asset: BORROWING_TYPE or USING_AS_COLLATERAL_TYPE  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="slot" %}  
Number representing slot in the list  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="user_address" %}  
The address of a user  
{% endswagger-parameter %}  
{% swagger-response status="slot ( felt )" description="" %}  
{% endswagger-response %}  
{% swagger-response status="index ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}