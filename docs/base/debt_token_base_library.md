
Debt_token_base_library
=======================
  
{% swagger method = "event" path = " " baseUrl = " " summary = "BorrowAllowanceDelegated" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="from_user" %}  
The address of the delegator  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="to_user" %}  
The address of the delegatee  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="asset" %}  
The address of the delegated asset  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="amount" %}  
The amount being delegated  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "st0rage" path = " " baseUrl = " " summary = "DebtTokenBase_borrow_allowances" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="delegator" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="delegatee" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="allowance ( Uint256 )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "st0rage" path = " " baseUrl = " " summary = "DebtTokenBase_underlying_asset" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="asset ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_underlying_asset" %}  
{% swagger-description %}  
Returns the underlying asset of the debt token  
{% endswagger-description %}  
{% swagger-response status="underlying ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "set_underlying_asset" %}  
{% swagger-description %}  
Sets the underlying asset of the debt token  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="underlying" %}  
The underlying asset of the debt token  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "approve_delegation" %}  
{% swagger-description %}  
Delegates borrowing power to a user on the specific debt token.
Delegation will still respect the liquidation constraints (even if delegated, a
delegatee cannot force a delegator HF to go below 1)  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="delegatee" %}  
The address receiving the delegated borrowing power  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="amount" %}  
The maximum amount being delegated.  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "borrow_allowance" %}  
{% swagger-description %}  
Returns the borrow allowance of the user  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="from_user" %}  
The user to giving allowance  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="to_user" %}  
The user to give allowance to  
{% endswagger-parameter %}  
{% swagger-response status="allowance ( Uint256 )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "decrease_borrow_allowance" %}  
{% swagger-description %}  
Decreases the borrow allowance of a user on the specific debt token.  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="delegator" %}  
The address delegating the borrowing power  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="delegatee" %}  
The address receiving the delegated borrowing power  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="amount" %}  
The amount to subtract from the current allowance  
{% endswagger-parameter %}  
{% endswagger %}