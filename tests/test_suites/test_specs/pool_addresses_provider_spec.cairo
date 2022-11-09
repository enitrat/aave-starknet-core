%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_not_equal
from starkware.starknet.common.syscalls import get_contract_address

from contracts.interfaces.i_pool import IPool
from contracts.interfaces.i_pool_addresses_provider import IPoolAddressesProvider
from contracts.interfaces.i_proxy import IProxy
from contracts.protocol.configuration.pool_addresses_provider_library import PoolAddressesProvider
from contracts.protocol.libraries.helpers.constants import INITIALIZE_SELECTOR

from tests.utils.constants import MOCK_CONTRACT_ADDRESS, USER_1, USER_2

const convertible_address_id = 'CONVERTIBLE_ADDRESS';
const convertible_2_address_id = 'CONVERTIBLE_2_ADDRESS';
const pool_id = 'POOL';
const pool_configurator_id = 'POOL_CONFIGURATOR';
const new_registered_contract_id = 'NEW_REGISTERED_CONTRACT';

namespace TestPoolAddressesProvider {
    const MOCKED_PROXY_ADDRESS = 8930645;
    const MOCKED_IMPLEMENTATION_HASH = 192083;
    const MOCKED_CONTRACT_ADDRESS = 349678;
    //
    // Function guards tests
    //

    // Test the only_owner accessibility of the PoolAddressesProvider

    func test_only_owner_set_market_id{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }() {
        // Transfer ownership to user_1
        PoolAddressesProvider.transfer_ownership(USER_1);

        // Try to access it (using the 0 address in protostar)
        %{ expect_revert(error_message="Ownable: caller is the zero address") %}
        PoolAddressesProvider.set_market_id(1);
        return ();
    }

    func test_only_owner_set_pool_impl{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }() {
        PoolAddressesProvider.transfer_ownership(USER_1);
        %{ expect_revert(error_message="Ownable: caller is the zero address") %}
        PoolAddressesProvider.set_pool_impl(MOCKED_IMPLEMENTATION_HASH, 1234);
        return ();
    }

    func test_only_owner_set_pool_configurator_impl{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }() {
        PoolAddressesProvider.transfer_ownership(USER_1);
        %{ expect_revert(error_message="Ownable: caller is the zero address") %}
        PoolAddressesProvider.set_pool_configurator_impl(MOCKED_IMPLEMENTATION_HASH, 1234);
        return ();
    }

    func test_only_owner_set_price_oracle{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }() {
        PoolAddressesProvider.transfer_ownership(USER_1);
        %{ expect_revert(error_message="Ownable: caller is the zero address") %}
        PoolAddressesProvider.set_price_oracle(MOCKED_CONTRACT_ADDRESS);
        return ();
    }

    func test_only_owner_set_ACL_admin{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }() {
        PoolAddressesProvider.transfer_ownership(USER_1);
        %{ expect_revert(error_message="Ownable: caller is the zero address") %}
        PoolAddressesProvider.set_ACL_admin(MOCKED_CONTRACT_ADDRESS);
        return ();
    }

    func test_only_owner_set_ACL_manager{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }() {
        PoolAddressesProvider.transfer_ownership(USER_1);
        %{ expect_revert(error_message="Ownable: caller is the zero address") %}
        PoolAddressesProvider.set_ACL_manager(MOCKED_CONTRACT_ADDRESS);
        return ();
    }

    func test_only_owner_set_price_oracle_sentinel{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }() {
        PoolAddressesProvider.transfer_ownership(USER_1);
        %{ expect_revert(error_message="Ownable: caller is the zero address") %}
        PoolAddressesProvider.set_price_oracle_sentinel(MOCKED_CONTRACT_ADDRESS);
        return ();
    }

    func test_only_owner_set_pool_data_provider{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }() {
        PoolAddressesProvider.transfer_ownership(USER_1);
        %{ expect_revert(error_message="Ownable: caller is the zero address") %}
        PoolAddressesProvider.set_pool_data_provider(MOCKED_CONTRACT_ADDRESS);
        return ();
    }

    func test_only_owner_set_address{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }() {
        PoolAddressesProvider.transfer_ownership(USER_1);
        %{ expect_revert(error_message="Ownable: caller is the zero address") %}
        PoolAddressesProvider.set_address('RANDOM_ID', MOCKED_CONTRACT_ADDRESS);
        return ();
    }

    func test_only_owner_set_address_as_proxy{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }() {
        PoolAddressesProvider.transfer_ownership(USER_1);
        %{ expect_revert(error_message="Ownable: caller is the zero address") %}
        PoolAddressesProvider.set_address_as_proxy('RANDOM_ID', MOCKED_IMPLEMENTATION_HASH, 1234);
        return ();
    }

    //
    // Getters / Setters tests
    //

    // Owner adds a new address with no proxy

    func test_owner_adds_new_address_with_no_proxy{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }() {
        %{ expect_events({"name": "AddressSet", "data": [context.RANDOM_NON_PROXIED,0,ids.MOCKED_CONTRACT_ADDRESS]}) %}
        let (contract_address) = get_contract_address();
        let non_proxied_address_id = 'RANDOM_NON_PROXIED';
        PoolAddressesProvider.transfer_ownership(USER_1);
        %{ stop_prank_user = start_prank(ids.USER_1) %}
        PoolAddressesProvider.set_address(non_proxied_address_id, MOCKED_CONTRACT_ADDRESS);
        %{ stop_prank_user() %}
        let (address) = PoolAddressesProvider.get_address(non_proxied_address_id);
        assert address = MOCKED_CONTRACT_ADDRESS;
        return ();
    }

    // Owner updates the MarketId

    func test_owner_updates_market_id{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }() {
        let (contract_address) = get_contract_address();
        let (old_market_id) = PoolAddressesProvider.get_market_id();
        %{ expect_events({"name": "MarketIdSet", "data": [ids.old_market_id,context.NEW_MARKET_ID]}) %}
        PoolAddressesProvider.transfer_ownership(USER_1);
        %{ stop_prank_user = start_prank(ids.USER_1) %}
        PoolAddressesProvider.set_market_id('NEW_MARKET_ID');
        %{ stop_prank_user() %}
        let (new_market_id) = PoolAddressesProvider.get_market_id();
        assert new_market_id = 'NEW_MARKET_ID';
        return ();
    }

    // Owner updates the PriceOracle

    func test_owner_updates_price_oracle{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }() {
        %{ expect_events({"name": "PriceOracleUpdated", "data": [0,10]}) %}
        let (old_price_oracle) = PoolAddressesProvider.get_price_oracle();
        assert old_price_oracle = 0;
        PoolAddressesProvider.transfer_ownership(USER_1);
        %{ stop_prank_user = start_prank(ids.USER_1) %}
        PoolAddressesProvider.set_price_oracle(10);
        %{ stop_prank_user() %}
        let (new_price_oracle) = PoolAddressesProvider.get_price_oracle();
        assert new_price_oracle = 10;
        return ();
    }

    // Owner updates the ACL manager

    func test_owner_updates_ACL_manager{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }() {
        %{ expect_events({"name": "ACLManagerUpdated", "data": [0,10]}) %}
        let (old_ACL_manager) = PoolAddressesProvider.get_ACL_manager();
        assert old_ACL_manager = 0;
        PoolAddressesProvider.transfer_ownership(USER_1);
        %{ stop_prank_user = start_prank(ids.USER_1) %}
        PoolAddressesProvider.set_ACL_manager(10);
        %{ stop_prank_user() %}
        let (new_ACL_manager) = PoolAddressesProvider.get_ACL_manager();
        assert new_ACL_manager = 10;
        return ();
    }

    // Owner updates the ACL admin

    func test_owner_updates_ACL_admin{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }() {
        %{ expect_events({"name": "ACLAdminUpdated", "data": [0,10]}) %}
        let (old_ACL_admin) = PoolAddressesProvider.get_ACL_admin();
        assert old_ACL_admin = 0;
        PoolAddressesProvider.transfer_ownership(USER_1);
        %{ stop_prank_user = start_prank(ids.USER_1) %}
        PoolAddressesProvider.set_ACL_admin(10);
        %{ stop_prank_user() %}
        let (new_ACL_admin) = PoolAddressesProvider.get_ACL_admin();
        assert new_ACL_admin = 10;
        return ();
    }

    // Owner updates the DataProvider

    func test_owner_updates_price_oracle_sentinel{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }() {
        %{ expect_events({"name": "PriceOracleSentinelUpdated", "data": [0,10]}) %}
        let (old_price_oracle_sentinel) = PoolAddressesProvider.get_price_oracle_sentinel();
        assert old_price_oracle_sentinel = 0;
        PoolAddressesProvider.transfer_ownership(USER_1);
        %{ stop_prank_user = start_prank(ids.USER_1) %}
        PoolAddressesProvider.set_price_oracle_sentinel(10);
        %{ stop_prank_user() %}
        let (price_oracle_sentinel) = PoolAddressesProvider.get_price_oracle_sentinel();
        assert price_oracle_sentinel = 10;
        return ();
    }

    // Owner updates the DataProvider

    func test_owner_updates_pool_data_provider{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }() {
        %{ expect_events({"name": "PoolDataProviderUpdated", "data": [0,10]}) %}
        let (old_pool_data_provider) = PoolAddressesProvider.get_pool_data_provider();
        assert old_pool_data_provider = 0;
        PoolAddressesProvider.transfer_ownership(USER_1);
        %{ stop_prank_user = start_prank(ids.USER_1) %}
        PoolAddressesProvider.set_pool_data_provider(10);
        %{ stop_prank_user() %}
        let (pool_data_provider) = PoolAddressesProvider.get_pool_data_provider();
        assert pool_data_provider = 10;
        return ();
    }
}

namespace TestPoolAddressesProviderDeployed {
    // Owner adds a new address as proxy
    func test_owner_adds_a_new_address_as_proxy{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }() {
        alloc_locals;
        let (pool_addresses_provider, implementation_hash, new_implementation_hash) = before_each();
        IPoolAddressesProvider.transfer_ownership(pool_addresses_provider, USER_1);
        %{
            # Mock caller_address as USER_1 (proxy admin & pool_addresses_provider owner)
            stop_prank_provider = start_prank(ids.USER_1,target_contract_address=ids.pool_addresses_provider) 

            expect_events({"name": "ProxyCreated"})
            expect_events({"name": "AddressSetAsProxy"})
        %}
        IPoolAddressesProvider.set_address_as_proxy(
            pool_addresses_provider, 'RANDOM_PROXIED', implementation_hash, 5678
        );
        %{ stop_prank_provider() %}
        return ();
    }

    // Owner adds a new address with no proxy and turns it into a proxy - stops after expect_revert
    func test_owner_adds_a_new_address_with_no_proxy_and_turns_it_into_a_proxy_1{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }() {
        alloc_locals;
        let (pool_addresses_provider, implementation_hash, new_implementation_hash) = before_each();
        IPoolAddressesProvider.transfer_ownership(pool_addresses_provider, USER_1);

        // add address as non proxy
        add_non_proxy_address(convertible_address_id);
        %{ expect_revert() %}
        IProxy.get_implementation(MOCK_CONTRACT_ADDRESS);
        return ();
    }

    // Owner adds a new address with no proxy and turns it into a proxy
    func test_owner_adds_a_new_address_with_no_proxy_and_turns_it_into_a_proxy_2{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }() {
        alloc_locals;
        let (pool_addresses_provider, implementation_hash, new_implementation_hash) = before_each();
        IPoolAddressesProvider.transfer_ownership(pool_addresses_provider, USER_1);

        add_non_proxy_address(convertible_address_id);
        unregister_address(convertible_address_id);  // Unregister address as non proxy
        add_proxy_address(convertible_address_id, implementation_hash);  // Add address as proxy
        let (proxy_address) = IPoolAddressesProvider.get_address(
            pool_addresses_provider, convertible_address_id
        );
        let (implementation) = IProxy.get_implementation(proxy_address);
        assert implementation = implementation_hash;
        return ();
    }

    // Unregister a proxy address
    func test_unregister_a_proxy_address{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }() {
        alloc_locals;
        let (pool_addresses_provider, implementation_hash, new_implementation_hash) = before_each();
        IPoolAddressesProvider.transfer_ownership(pool_addresses_provider, USER_1);

        add_proxy_address(convertible_address_id, implementation_hash);
        unregister_address(convertible_address_id);
        let (proxy_address) = IPoolAddressesProvider.get_address(
            pool_addresses_provider, convertible_address_id
        );
        %{ expect_revert() %}
        IProxy.get_implementation(proxy_address);
        return ();
    }

    // Owner adds a new address with proxy and turns it into no a proxy
    func test_owner_adds_a_new_address_with_proxy_and_turns_it_into_a_no_proxy{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }() {
        alloc_locals;
        let (pool_addresses_provider, implementation_hash, new_implementation_hash) = before_each();
        IPoolAddressesProvider.transfer_ownership(pool_addresses_provider, USER_1);
        let (current_address) = IPoolAddressesProvider.get_address(
            pool_addresses_provider, convertible_2_address_id
        );
        assert current_address = 0;
        add_proxy_address(convertible_2_address_id, implementation_hash);  // Add address as proxy
        let (proxy_address) = IPoolAddressesProvider.get_address(
            pool_addresses_provider, convertible_2_address_id
        );
        let (proxy_implementation) = IProxy.get_implementation(proxy_address);
        assert proxy_implementation = implementation_hash;
        unregister_address(convertible_2_address_id);  // Unregister address as proxy
        add_non_proxy_address(convertible_2_address_id);  // Add address as non proxy
        %{ expect_revert() %}
        IProxy.get_implementation(MOCK_CONTRACT_ADDRESS);
        return ();
    }

    // Unregister a no proxy address
    func test_unregister_a_no_proxy_address{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }() {
        alloc_locals;
        let (pool_addresses_provider, implementation_hash, new_implementation_hash) = before_each();
        IPoolAddressesProvider.transfer_ownership(pool_addresses_provider, USER_1);

        add_non_proxy_address(convertible_2_address_id);
        let (registered_address) = IPoolAddressesProvider.get_address(
            pool_addresses_provider, convertible_2_address_id
        );
        unregister_address(convertible_2_address_id);
        let (registered_after) = IPoolAddressesProvider.get_address(
            pool_addresses_provider, convertible_2_address_id
        );
        assert registered_after = 0;
        assert_not_equal(registered_address, registered_after);
        %{ expect_revert() %}
        IProxy.get_implementation(registered_after);
        return ();
    }

    // Owner registers an existing contract (with proxy) and upgrade it
    func test_owner_registers_an_existing_contract_with_proxy_and_upgrade_it{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }() {
        alloc_locals;
        let (pool_addresses_provider, implementation_hash, new_implementation_hash) = before_each();
        IPoolAddressesProvider.transfer_ownership(pool_addresses_provider, USER_1);
        %{ stop_prank_provider = start_prank(ids.USER_1,target_contract_address=ids.pool_addresses_provider) %}

        local proxy_address: felt;
        // deploy a new proxy w/ USER_2 as admin
        %{ ids.proxy_address = deploy_contract("./contracts/protocol/libraries/aave_upgradeability/initializable_immutable_admin_upgradeability_proxy.cairo", {"proxy_admin": ids.USER_2}).contract_address %}

        // Initialize proxy with implementation of mock_token v1.
        let (local empty_calldata: felt*) = alloc();
        %{ stop_prank_proxy= start_prank(ids.USER_2,target_contract_address=ids.proxy_address) %}
        IProxy.initialize(
            proxy_address, implementation_hash, INITIALIZE_SELECTOR, 0, empty_calldata
        );
        %{ stop_prank_proxy() %}
        let (proxy_admin) = IProxy.get_admin(proxy_address);
        let (version) = IPool.get_revision(proxy_address);
        assert proxy_admin = USER_2;
        assert version = 1;

        // Register mock_token contract in PoolAddressesProvider
        %{ stop_prank_proxy= start_prank(ids.USER_2,target_contract_address=ids.proxy_address) %}
        IProxy.change_proxy_admin(proxy_address, pool_addresses_provider);
        %{ stop_prank_proxy() %}
        IPoolAddressesProvider.set_address(
            pool_addresses_provider, new_registered_contract_id, proxy_address
        );
        let (expected_address) = IPoolAddressesProvider.get_address(
            pool_addresses_provider, new_registered_contract_id
        );
        assert expected_address = proxy_address;

        // Replaces proxy implementation (currently pool) with mock_pool_v2
        IPoolAddressesProvider.set_address_as_proxy(
            pool_addresses_provider, new_registered_contract_id, new_implementation_hash, 1357
        );
        let (version) = IPool.get_revision(proxy_address);
        assert version = 2;
        %{ stop_prank_provider() %}
        return ();
    }

    // Owner updates the implementation of a proxy which is already initialized
    func test_owner_updates_the_implementation_of_a_proxy_which_is_already_initialized{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }() {
        alloc_locals;
        let (pool_addresses_provider, implementation_hash, new_implementation_hash) = before_each();
        IPoolAddressesProvider.transfer_ownership(pool_addresses_provider, USER_1);
        add_proxy_address(pool_id, implementation_hash);  // Deploy proxy for pool
        let (proxy_address) = IPoolAddressesProvider.get_address(pool_addresses_provider, pool_id);
        let (pool_implementation) = IProxy.get_implementation(proxy_address);
        %{
            expect_events({"name": "PoolUpdated","data":[ids.pool_implementation,ids.new_implementation_hash]}) 
            stop_prank_provider = start_prank(ids.USER_1,target_contract_address=ids.pool_addresses_provider)
        %}
        // Update the pool proxy
        IPoolAddressesProvider.set_pool_impl(
            pool_addresses_provider, new_implementation_hash, 1234
        );
        let (new_pool_impl) = IProxy.get_implementation(proxy_address);
        let (pool_proxy_address) = IPoolAddressesProvider.get_pool(pool_addresses_provider);

        // pool address should not change
        assert pool_proxy_address = proxy_address;
        %{ stop_prank_provider() %}
        return ();
    }

    // Owner updates the PoolConfigurator
    func test_owner_updates_the_pool_configurator{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }() {
        alloc_locals;
        let (pool_addresses_provider, implementation_hash, new_implementation_hash) = before_each();
        IPoolAddressesProvider.transfer_ownership(pool_addresses_provider, USER_1);

        // TODO replace with poolConfigurator's address once implemented
        add_proxy_address(pool_configurator_id, implementation_hash);  // Deploy proxy for pool_configurator
        let (proxy_address) = IPoolAddressesProvider.get_address(
            pool_addresses_provider, pool_configurator_id
        );
        let (pool_configurator_implementation) = IProxy.get_implementation(proxy_address);
        %{
            expect_events({"name": "PoolConfiguratorUpdated","data":[ids.pool_configurator_implementation,ids.new_implementation_hash]}) 
            stop_prank_provider = start_prank(ids.USER_1,target_contract_address=ids.pool_addresses_provider)
        %}

        // Update the PoolConfigurator proxy
        IPoolAddressesProvider.set_pool_configurator_impl(
            pool_addresses_provider, new_implementation_hash, 1234
        );
        let (new_pool_configurator_impl) = IProxy.get_implementation(proxy_address);
        let (pool_configurator_proxy_address) = IPoolAddressesProvider.get_pool_configurator(
            pool_addresses_provider
        );
        // proxy address should stay the same
        assert pool_configurator_proxy_address = proxy_address;

        // pool implementation should change
        assert new_pool_configurator_impl = new_implementation_hash;
        %{ stop_prank_provider() %}
        return ();
    }
}

// Before each test_case get the address of the PoolAddressesProvider, the hash of Pool and the hash of mock_pool_v2
func before_each{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    pool_addresses_provider: felt, implementation_hash: felt, new_implementation_hash: felt
) {
    alloc_locals;
    local pool_addresses_provider;
    local implementation_hash;
    local new_implementation_hash;
    %{
        ids.pool_addresses_provider = context.pool_addresses_provider
        ids.implementation_hash = context.implementation_hash # hash of Pool
        ids.new_implementation_hash = context.new_implementation_hash # hash of mock_pool_v2
    %}
    return (pool_addresses_provider, implementation_hash, new_implementation_hash);
}

// Owner adds a new address with no proxy and turns it into a proxy
func add_non_proxy_address{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    id: felt
) {
    alloc_locals;
    let (pool_addresses_provider, implementation_hash, new_implementation_hash) = before_each();
    local pool_addresses_provider;
    %{ ids.pool_addresses_provider = context.pool_addresses_provider %}
    tempvar temp_id = id;
    %{
        # Mock caller_address as USER_1 (proxy admin & pool_addresses_provider owner)
        stop_prank_provider = start_prank(ids.USER_1,target_contract_address=ids.pool_addresses_provider) 

        expect_events({"name": "AddressSet","data":[ids.id, 0,ids.MOCK_CONTRACT_ADDRESS]})
    %}

    let (old_non_proxied_address) = IPoolAddressesProvider.get_address(pool_addresses_provider, id);
    assert old_non_proxied_address = 0;
    IPoolAddressesProvider.set_address(pool_addresses_provider, id, MOCK_CONTRACT_ADDRESS);
    %{ stop_prank_provider() %}

    let (registered_address) = IPoolAddressesProvider.get_address(pool_addresses_provider, id);
    assert registered_address = MOCK_CONTRACT_ADDRESS;
    return ();
}

func unregister_address{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(id: felt) {
    alloc_locals;
    let (pool_addresses_provider, implementation_hash, new_implementation_hash) = before_each();
    local pool_addresses_provider;
    %{
        ids.pool_addresses_provider = context.pool_addresses_provider
        expect_events({"name": "AddressSet","data":[ids.id, ids.MOCK_CONTRACT_ADDRESS,0]})
        stop_prank_provider = start_prank(ids.USER_1,target_contract_address=ids.pool_addresses_provider)
    %}
    IPoolAddressesProvider.set_address(pool_addresses_provider, id, 0);
    %{ stop_prank_provider() %}
    return ();
}

func add_proxy_address{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    id: felt, implementation_hash: felt
) {
    alloc_locals;
    local pool_addresses_provider;
    %{ ids.pool_addresses_provider = context.pool_addresses_provider %}
    %{
        expect_events({"name": "ProxyCreated"})
        expect_events({"name": "AddressSetAsProxy"})
        stop_prank_provider = start_prank(ids.USER_1,target_contract_address=ids.pool_addresses_provider)
    %}
    IPoolAddressesProvider.set_address_as_proxy(
        pool_addresses_provider, id, implementation_hash, 2468
    );

    let (proxy_address) = IPoolAddressesProvider.get_address(pool_addresses_provider, id);
    let (proxy_implementation_hash) = IProxy.get_implementation(proxy_address);
    assert proxy_implementation_hash = implementation_hash;
    %{ stop_prank_provider() %}
    return ();
}
