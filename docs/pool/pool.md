
Pool
====
  
{% swagger method = "view" path = " " baseUrl = " " summary = "get_revision" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="revision ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "get_addresses_provider" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="provider ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "get_reserve_data" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="asset" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="reserve_data (  )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "get_configuration" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="asset" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="config (  )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "get_reserve_normalized_variable_debt" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="asset" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="normalized_variable_debt ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "get_reserve_normalized_income" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="asset" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="res ( Uint256 )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "get_reserves_list" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="assets_len ( felt )" description="" %}  
{% endswagger-response %}  
{% swagger-response status="assets ( felt* )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "get_reserve_address_by_id" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="reserve_id" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="address ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "MAX_NUMBER_RESERVES" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="max_number ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "initialize" %}  
{% swagger-description %}  
Initializes the Pool.  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="provider" %}  
The address of the PoolAddressesProvider  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "supply" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="asset" %}  
The address of the underlying asset to supply  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="amount" %}  
The amount to be supplied  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="on_behalf_of" %}  
The address that will receive the aTokens, same as caller_address if the user
wants to receive them on his own wallet, or a different address if the beneficiary of aTokens
is a different wallet.  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="referral_code" %}  
Code used to register the integrator originating the operation, for potential rewards.
0 if the action is executed directly by the user, without any middle-man.  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "withdraw" %}  
{% swagger-description %}  
Withdraws an `amount` of underlying asset from the reserve, burning the equivalent aTokens owned
E.g. User has 100 aUSDC, calls withdraw() and receives 100 USDC, burning the 100 aUSDC  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="asset" %}  
The address of the underlying asset to withdraw  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="amount" %}  
The underlying amount to be withdrawn
- Send the value type(uint256).max in order to withdraw the whole aToken balance  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="to" %}  
The address that will receive the underlying, same as msg.sender if the user
wants to receive it on his own wallet, or a different address if the beneficiary is a
different wallet  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "init_reserve" %}  
{% swagger-description %}  
Initializes a reserve, activating it, assigning an aToken and debt tokens and an
interest rate strategy  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="asset" %}  
The address of the underlying asset of the reserve  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="a_token_address" %}  
The address of the aToken that will be assigned to the reserve  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="stable_debt_token_address" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="variable_debt_token_address" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="interest_rate_strategy_address" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "drop_reserve" %}  
{% swagger-description %}  
Drop a reserve  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="asset" %}  
The address of the underlying asset of the reserve  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "set_configuration" %}  
{% swagger-description %}  
Set pool configuration  
{% endswagger-description %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "finalize_transfer" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="asset" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="sender" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="recipient" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256" name="amount" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256" name="sender_balance" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256" name="recipient_balance" %}  
  
{% endswagger-parameter %}  
{% endswagger %}