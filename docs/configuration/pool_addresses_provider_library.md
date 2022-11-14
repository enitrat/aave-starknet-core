
Pool_addresses_provider_library
===============================
  
{% swagger method = "event" path = " " baseUrl = " " summary = "MarketIdSet" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="old_market_id" %}  
The old id of the market  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="new_market_id" %}  
The new id of the market  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "event" path = " " baseUrl = " " summary = "PoolUpdated" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="old_implementation" %}  
The old implementation of the Pool  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="new_implementation" %}  
The new implementation of the Pool  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "event" path = " " baseUrl = " " summary = "PoolConfiguratorUpdated" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="old_implementation" %}  
The old implementation of the PoolConfigurator  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="new_implementation" %}  
The new implementation of the PoolConfigurator  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "event" path = " " baseUrl = " " summary = "PriceOracleUpdated" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="old_implementation" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="new_implementation" %}  
The new address of the PriceOracle  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "event" path = " " baseUrl = " " summary = "ACLManagerUpdated" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="old_address" %}  
The old address of the ACLManager  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="new_address" %}  
The new address of the ACLManager  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "event" path = " " baseUrl = " " summary = "ACLAdminUpdated" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="old_address" %}  
The old address of the ACLAdmin  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="new_address" %}  
The new address of the ACLAdmin  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "event" path = " " baseUrl = " " summary = "PriceOracleSentinelUpdated" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="old_address" %}  
The old address of the PriceOracleSentinel  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="new_address" %}  
The new address of the PriceOracleSentinel  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "event" path = " " baseUrl = " " summary = "PoolDataProviderUpdated" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="old_address" %}  
The old address of the PoolDataProvider  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="new_address" %}  
The new address of the PoolDataProvider  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "event" path = " " baseUrl = " " summary = "ProxyCreated" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="id" %}  
The identifier of the proxy  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="proxy_address" %}  
The address of the created proxy contract  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="implementation_hash" %}  
The address of the implementation contract  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "event" path = " " baseUrl = " " summary = "AddressSet" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="id" %}  
The identifier of the contract  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="old_address" %}  
The address of the old contract  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="new_address" %}  
The address of the new contract  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "event" path = " " baseUrl = " " summary = "AddressSetAsProxy" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="id" %}  
The identifier of the contract  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="proxy_address" %}  
The address of the proxy contract  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="old_implementation_hash" %}  
The old implementation hash  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="new_implementation_hash" %}  
The new implementation hash  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "st0rage" path = " " baseUrl = " " summary = "PoolAddressesProvider_market_id" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="id ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "st0rage" path = " " baseUrl = " " summary = "PoolAddressesProvider_addresses" %}  
{% swagger-description %}  
Maps an identifier to its address  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="id" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="registered_address ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "st0rage" path = " " baseUrl = " " summary = "PoolAddressesProvider_proxy_class_hash" %}  
{% swagger-description %}  
Stores the class_hash of a proxy contract.  
{% endswagger-description %}  
{% swagger-response status="salt ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "initializer" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="market_id" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="owner" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="proxy_class_hash" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "transfer_ownership" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="new_owner" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_market_id" %}  
{% swagger-description %}  
Returns the id of the Aave market to which this contract points to.  
{% endswagger-description %}  
{% swagger-response status="market_id ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "set_market_id" %}  
{% swagger-description %}  
Associates an id with a specific PoolAddressesProvider.  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="new_market_id" %}  
The market id  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_address" %}  
{% swagger-description %}  
Returns an address by its identifier.  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="id" %}  
The id  
{% endswagger-parameter %}  
{% swagger-response status="address ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "set_address_as_proxy" %}  
{% swagger-description %}  
General function to update the implementation of a proxy registered with
certain `id`. If there is no proxy registered, it will instantiate one and
set as implementation the `new_implementation`.  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="id" %}  
The id  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="new_implementation" %}  
The hash of the new implementation  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="salt" %}  
random number required to deploy a proxy  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "set_address" %}  
{% swagger-description %}  
Sets an address for an id replacing the address saved in the addresses map.  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="id" %}  
The id  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="new_address" %}  
The address to set  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_pool" %}  
{% swagger-description %}  
Returns the address of the Pool proxy.  
{% endswagger-description %}  
{% swagger-response status="pool ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "set_pool_impl" %}  
{% swagger-description %}  
Updates the implementation of the Pool, or creates a proxy
setting the new `pool` implementation when the function is called for the first time.  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="new_pool_impl" %}  
The new Pool implementation  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="salt" %}  
random number required to deploy a proxy  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_pool_configurator" %}  
{% swagger-description %}  
Returns the address of the PoolConfigurator proxy.  
{% endswagger-description %}  
{% swagger-response status="pool_configurator ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "set_pool_configurator_impl" %}  
{% swagger-description %}  
Updates the implementation of the PoolConfigurator, or creates a proxy
setting the new `PoolConfigurator` implementation when the function is called for the first time.  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="new_pool_configurator_impl" %}  
The new PoolConfigurator implementation  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="salt" %}  
random number required to deploy a proxy  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_price_oracle" %}  
{% swagger-description %}  
Returns the address of the price oracle.  
{% endswagger-description %}  
{% swagger-response status="price_oracle ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "set_price_oracle" %}  
{% swagger-description %}  
Updates the address of the price oracle.  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="new_price_oracle" %}  
The address of the new PriceOracle  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_ACL_manager" %}  
{% swagger-description %}  
Returns the address of the ACL manager.  
{% endswagger-description %}  
{% swagger-response status="ACL_manager ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "set_ACL_manager" %}  
{% swagger-description %}  
Updates the address of the ACL manager.  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="new_acl_manager" %}  
The address of the new ACLManager  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_ACL_admin" %}  
{% swagger-description %}  
Returns the address of the ACL admin.  
{% endswagger-description %}  
{% swagger-response status="ACL_admin ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "set_ACL_admin" %}  
{% swagger-description %}  
Updates the address of the ACL admin.  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="new_acl_admin" %}  
The address of the new ACL admin  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_price_oracle_sentinel" %}  
{% swagger-description %}  
Returns the address of the price oracle sentinel.  
{% endswagger-description %}  
{% swagger-response status="price_oracle_sentinel ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "set_price_oracle_sentinel" %}  
{% swagger-description %}  
Updates the address of the price oracle sentinel.  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="new_price_oracle_sentinel" %}  
The address of the new PriceOracleSentinel  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "get_pool_data_provider" %}  
{% swagger-description %}  
Returns the address of the data provider.  
{% endswagger-description %}  
{% swagger-response status="pool_data_provider ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "set_pool_data_provider" %}  
{% swagger-description %}  
Updates the address of the data provider.  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="new_data_provider" %}  
The address of the new DataProvider  
{% endswagger-parameter %}  
{% endswagger %}