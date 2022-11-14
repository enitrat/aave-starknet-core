
Stable_debt_token_library
=========================
  
{% swagger method = "event" path = " " baseUrl = " " summary = "Initialized" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="underlying_asset" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="pool" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="incentives_controller" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="debt_token_decimals" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="debt_token_name" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="debt_token_symbol" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="params" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "event" path = " " baseUrl = " " summary = "Mint" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="user" %}  
The address of the user who triggered the minting  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="on_behalf_of" %}  
The recipient of stable debt tokens  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="amount" %}  
The amount minted (user entered amount + balance increase from interest)  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="current_balance" %}  
The current balance of the user  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="balance_increase" %}  
The increase in balance since the last action of the user  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="new_rate" %}  
The rate of the debt after the minting  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="avg_stable_rate" %}  
The next average stable rate after the minting  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="new_total_supply" %}  
The next total supply of the stable debt token after the action  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "event" path = " " baseUrl = " " summary = "Burn" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="address_from" %}  
The address from which the debt will be burned  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="amount" %}  
The amount being burned (user entered amount - balance increase from interest)  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="current_balance" %}  
The current balance of the user  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="balance_increase" %}  
The the increase in balance since the last action of the user  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="avg_stable_rate" %}  
The next average stable rate after the burning  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="new_total_supply" %}  
The next total supply of the stable debt token after the action  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "st0rage" path = " " baseUrl = " " summary = "StableDebtToken_avg_stable_rate" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="rate ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "st0rage" path = " " baseUrl = " " summary = "StableDebtToken_timestamps" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="user" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="last_updated ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "st0rage" path = " " baseUrl = " " summary = "StableDebtToken_total_supply_timestamp" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="timestamp ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "initialize" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="initializing_pool" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="underlying_asset" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="incentives_controller" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="debt_token_decimals" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="debt_token_name" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="debt_token_symbol" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="params" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_average_stable_rate" %}  
{% swagger-description %}  
Returns the average rate of all the stable rate loans.  
{% endswagger-description %}  
{% swagger-response status="avg_stable_rate ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_user_last_updated" %}  
{% swagger-description %}  
Returns the timestamp of the last update of the user  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="user" %}  
The address of the user  
{% endswagger-parameter %}  
{% swagger-response status="timestamp ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_user_stable_rate" %}  
{% swagger-description %}  
Returns the stable rate of the user debt  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="user" %}  
The address of the user  
{% endswagger-parameter %}  
{% swagger-response status="stable_rate ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "balance_of" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="account" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="balance ( Uint256 )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "mint" %}  
{% swagger-description %}  
Mints debt token to the `onBehalfOf` address.  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="user" %}  
The address receiving the borrowed underlying, being the delegatee in case
of credit delegate, or same as `on_behalf_of` otherwise  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="on_behalf_of" %}  
The address receiving the debt tokens  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="amount" %}  
The amount of debt tokens to mint  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="rate" %}  
The rate of the debt being minted  
{% endswagger-parameter %}  
{% swagger-response status="is_first_borrow ( felt )" description="" %}  
{% endswagger-response %}  
{% swagger-response status="total_stable_debt ( Uint256 )" description="" %}  
{% endswagger-response %}  
{% swagger-response status="avg_stable_borrow_rate ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "burn" %}  
{% swagger-description %}  
Burns debt of `user`  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="address_from" %}  
The address from which the debt will be burned  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="amount" %}  
The amount of debt tokens getting burned  
{% endswagger-parameter %}  
{% swagger-response status="next_supply ( Uint256 )" description="" %}  
{% endswagger-response %}  
{% swagger-response status="next_avg_stable_rate ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_supply_data" %}  
{% swagger-description %}  
Returns the principal, the total supply, the average stable rate and the timestamp for the last update  
{% endswagger-description %}  
{% swagger-response status="principal_supply ( Uint256 )" description="" %}  
{% endswagger-response %}  
{% swagger-response status="total_supply ( Uint256 )" description="" %}  
{% endswagger-response %}  
{% swagger-response status="avg_stable_rate ( felt )" description="" %}  
{% endswagger-response %}  
{% swagger-response status="total_supply_timestamp ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_total_supply_and_avg_rate" %}  
{% swagger-description %}  
Returns the total supply and the average stable rate  
{% endswagger-description %}  
{% swagger-response status="total_supply ( Uint256 )" description="" %}  
{% endswagger-response %}  
{% swagger-response status="avg_rate ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "total_supply" %}  
{% swagger-description %}  
Returns the total supply  
{% endswagger-description %}  
{% swagger-response status="total_supply ( Uint256 )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_total_supply_last_updated" %}  
{% swagger-description %}  
Returns the timestamp of the last update of the total supply  
{% endswagger-description %}  
{% swagger-response status="timestamp ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}