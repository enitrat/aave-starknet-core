%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.bool import TRUE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_contract_address

from contracts.interfaces.i_a_token import IAToken
from contracts.interfaces.i_pool import IPool
from contracts.interfaces.i_pool_addresses_provider import IPoolAddressesProvider
from contracts.interfaces.i_proxy import IProxy
from contracts.protocol.libraries.helpers.constants import INITIALIZE_SELECTOR
from contracts.protocol.libraries.types.data_types import DataTypes

from tests.test_suites.test_specs.a_token_modifiers_spec import ATokenModifier
from tests.test_suites.test_specs.acl_manager_spec import PRANK_ADMIN_ADDRESS, TestACLManager
from tests.test_suites.test_specs.pool_addresses_provider_spec import (
    TestPoolAddressesProviderDeployed,
)
from tests.test_suites.test_specs.pool_drop_spec import TestPoolDropDeployed
from tests.test_suites.test_specs.pool_get_reserve_address_by_id_spec import (
    TestPoolGetReserveAddressByIdDeployed,
)
from tests.test_suites.test_specs.pool_supply_withdraw_spec import TestPoolSupplyWithdrawDeployed
from tests.test_suites.test_specs.price_oracle_sentinel_spec import (
    GRACE_PERIOD,
    PRANK_OWNER,
    TestPriceOracleSentinel,
)
from tests.test_suites.test_specs.stable_debt_token_spec import TestStableDebtTokenDeployed

// @notice setup hook for the test execution. It deploys the contracts
// saves the Starknet state at the end of this function. All test cases will be executed
// from this saved state.
@external
func __setup__{syscall_ptr: felt*, range_check_ptr}() {
    alloc_locals;
    let (deployer) = get_contract_address();
    %{
        def str_to_felt(text):
            MAX_LEN_FELT = 31
            if len(text) > MAX_LEN_FELT:
                raise Exception("Text length too long to convert to felt.")

            return int.from_bytes(text.encode(), "big")

        # deploy DAI/DAI, owner is deployer, supply is 0
        context.dai = deploy_contract("./lib/cairo_contracts/src/openzeppelin/token/erc20/presets/ERC20Mintable.cairo",
            {"name":str_to_felt("DAI"),"symbol":str_to_felt("DAI"),"decimals":18,"initial_supply":{"low":0,"high":0},"recipient":ids.deployer,"owner": ids.deployer}).contract_address

        # deploy WETH/WETH, owner is deployer, supply is 0
        context.weth = deploy_contract("./lib/cairo_contracts/src/openzeppelin/token/erc20/presets/ERC20Mintable.cairo",  {"name":str_to_felt("WETH"),"symbol":str_to_felt("WETH"),"decimals":18,"initial_supply":{"low":0,"high":0},"recipient":ids.deployer,"owner": ids.deployer}).contract_address

        # deploy aDai/aDAI, owner is pool, supply is 0
        context.aDAI = deploy_contract("./contracts/protocol/tokenization/a_token.cairo").contract_address

        # deploy aWETH/aWETH, owner is pool, supply is 0
        context.aWETH = deploy_contract("./contracts/protocol/tokenization/a_token.cairo").contract_address

        # declare class implementation of Pool
        context.implementation_hash = declare("./contracts/protocol/pool/pool.cairo").class_hash
        # declare class implementation of mock_pool_v2
        context.new_implementation_hash = declare("./tests/mocks/mock_pool_v2.cairo").class_hash

        # declare proxy_class_hash so that starknet knows about it. It's required to deploy proxies from PoolAddressesProvider
        declared_proxy = declare("./contracts/protocol/libraries/aave_upgradeability/initializable_immutable_admin_upgradeability_proxy.cairo")
        context.proxy_class_hash = declared_proxy.class_hash

        # deploy Aave proxy contract, admin is deployer. Implementation hash is pool upon deployment.
        prepared_proxy = prepare(declared_proxy, {"proxy_admin": ids.deployer})
        context.proxy = deploy(prepared_proxy).contract_address

        # deploy poolAddressesProvider, market_id = 1, prank get_caller_address so that it returns deployer and we can set deployer as the owner.
        # We have proxy_class_hash as an argument because we store it to be able to deploy proxies from the pool_addresses_provider
        # We need a cheatcode to mock the deployer address, so we declare->prepare->mock_caller->deploy
        declared_pool_addresses_provider = declare("./contracts/protocol/configuration/pool_addresses_provider.cairo")
        prepared_pool_addresses_provider = prepare(declared_pool_addresses_provider, {"market_id":1,"owner":ids.deployer,"proxy_class_hash":context.proxy_class_hash})
        stop_prank = start_prank(0, target_contract_address=prepared_pool_addresses_provider.contract_address)
        context.pool_addresses_provider = deploy(prepared_pool_addresses_provider).contract_address
        stop_prank()

        # To declare acl_manager, we need pool_addresses_provider. We use the one declared above
        stop_mock_admin = mock_call(context.pool_addresses_provider, "get_ACL_admin", [ids.PRANK_ADMIN_ADDRESS])
        context.acl_manager = deploy_contract("./contracts/protocol/configuration/acl_manager.cairo", {"provider":context.pool_addresses_provider}).contract_address
        stop_mock_admin()

        # declare sequencer oracle
        declared_seq_oracle = declare("./contracts/mocks/oracle/sequencer_oracle.cairo")
        prepared_seq_oracle = prepare(declared_seq_oracle, {"owner": ids.PRANK_OWNER})
        stop_prank = start_prank(ids.PRANK_OWNER, target_contract_address = prepared_seq_oracle.contract_address)
        context.sequencer_oracle = deploy(prepared_seq_oracle).contract_address
        stop_prank()

        # deploy price oracle sentinel
        declared_price_oracle_sentinel = declare("./contracts/protocol/configuration/price_oracle_sentinel.cairo")
        prepared_price_oracle_sentinel = prepare(declared_price_oracle_sentinel, {"addresses_provider": context.pool_addresses_provider, "oracle_sentinel":context.sequencer_oracle, "grace_period":ids.GRACE_PERIOD})
        context.price_oracle_sentinel = deploy(prepared_price_oracle_sentinel).contract_address

        # deploy pool contract
        context.pool = deploy_contract("./contracts/protocol/pool/pool.cairo").contract_address

        context.stable_debt_impl = declare("./contracts/protocol/tokenization/stable_debt_token.cairo").class_hash
        context.dai_stable_debt = deploy_contract("./contracts/protocol/libraries/aave_upgradeability/initializable_immutable_admin_upgradeability_proxy.cairo",{"proxy_admin": ids.deployer}).contract_address
        context.weth_stable_debt = deploy_contract("./contracts/protocol/libraries/aave_upgradeability/initializable_immutable_admin_upgradeability_proxy.cairo",{"proxy_admin": ids.deployer}).contract_address

        context.variable_debt_impl = declare("./contracts/protocol/tokenization/variable_debt_token.cairo").class_hash
        context.dai_variable_debt = deploy_contract("./contracts/protocol/libraries/aave_upgradeability/initializable_immutable_admin_upgradeability_proxy.cairo",{"proxy_admin": ids.deployer}).contract_address

        context.deployer = ids.deployer
    %}
    local pool;
    local pool_addresses_provider;
    local dai;
    local weth;
    local aDAI;
    local aWETH;
    local stable_debt_impl;
    local dai_stable_debt;
    local weth_stable_debt;
    local variable_debt_impl;
    local dai_variable_debt;
    local proxy;
    local acl_manager;
    local price_oracle_sentinel;
    local sequencer_oracle;
    local pool_addresses_provider;
    %{
        ids.pool = context.pool
        ids.pool_addresses_provider = context.pool_addresses_provider
        ids.dai = context.dai
        ids.weth= context.weth
        ids.aDAI = context.aDAI
        ids.aWETH = context.aWETH
        ids.proxy = context.proxy
        ids.acl_manager = context.acl_manager
        ids.stable_debt_impl = context.stable_debt_impl
        ids.dai_stable_debt = context.dai_stable_debt
        ids.weth_stable_debt = context.weth_stable_debt
        ids.variable_debt_impl = context.variable_debt_impl
        ids.dai_variable_debt = context.dai_variable_debt
        ids.pool_addresses_provider = context.pool_addresses_provider
        ids.sequencer_oracle = context.sequencer_oracle
        ids.price_oracle_sentinel = context.price_oracle_sentinel
    %}

    IPool.initialize(pool, pool_addresses_provider);

    IPoolAddressesProvider.set_address(pool_addresses_provider, 'ACL_MANAGER', acl_manager);

    IAToken.initialize(aDAI, pool, 1631863113, dai, 43232, 18, 123, 456);
    IAToken.initialize(aWETH, pool, 1631863113, weth, 43232, 18, 321, 654);

    // TODO replace this mock with a call from poolConfigurator
    %{ stop_mock_configurator = mock_call(context.pool_addresses_provider,"get_address",[ids.deployer]) %}
    IPool.init_reserve(pool, dai, aDAI, dai_stable_debt, dai_variable_debt, 0);
    IPool.init_reserve(pool, weth, aWETH, weth_stable_debt, 0, 0);
    // sets the pool config with a reserve_active set to true to be able to excute the supply & withdraw logic
    IPool.set_configuration(
        pool,
        dai,
        DataTypes.ReserveConfiguration(0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    );
    IPool.set_configuration(
        pool,
        weth,
        DataTypes.ReserveConfiguration(0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    );
    %{
        stop_mock_configurator()
        stop_mock_pool_admin = mock_call(ids.acl_manager,"is_pool_admin",[ids.TRUE])
    %}
    // Initialize proxies for stable debt tokens
    let (dai_calldata: felt*) = alloc();
    IProxy.initialize(
        dai_stable_debt,
        stable_debt_impl,
        INITIALIZE_SELECTOR,
        7,
        new (pool, dai, 0, 18, 'DAI Stable Debt Token', 'sDAI', ''),
    );
    IProxy.initialize(
        weth_stable_debt,
        stable_debt_impl,
        INITIALIZE_SELECTOR,
        7,
        new (pool, weth, 0, 18, 'WETH Stable Debt Token', 'sWETH', ''),
    );
    IProxy.initialize(
        dai_variable_debt,
        variable_debt_impl,
        INITIALIZE_SELECTOR,
        7,
        new (pool, weth, 0, 18, 'DAI Variable Debt Token', 'vDAI', ''),
    );
    %{ stop_mock_pool_admin() %}
    return ();
}

//
// Test cases imported from test specifications
//

// # Test fails because AToken.balanceOf is not implemented
// @external
// func test_user_1_deposits_DAI_user_2_borrow_DAI_stable_and_variable_should_fail_to_drop_DAI_reserve{
//     syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
// }():
//     TestPoolDropDeployed.test_user_1_deposits_DAI_user_2_borrow_DAI_stable_and_variable_should_fail_to_drop_DAI_reserve(
//         )
//     return ()
// end

@external
func test_user_2_repays_debts_drop_DAI_reserve_should_fail{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    TestPoolDropDeployed.test_user_2_repays_debts_drop_DAI_reserve_should_fail();
    return ();
}

// test_pool_drop_3
@external
func test_user_1_withdraw_DAI_drop_DAI_reserve_should_succeed{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    TestPoolDropDeployed.test_user_1_withdraw_DAI_drop_DAI_reserve_should_succeed();
    return ();
}

@external
func test_drop_an_asset_that_is_not_a_listed_reserve_should_fail{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    TestPoolDropDeployed.test_drop_an_asset_that_is_not_a_listed_reserve_should_fail();
    return ();
}

@external
func test_dropping_zero_address_should_fail{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    TestPoolDropDeployed.test_dropping_zero_address_should_fail();
    return ();
}

@external
func test_get_address_of_reserve_by_id{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    TestPoolGetReserveAddressByIdDeployed.test_get_address_of_reserve_by_id();
    return ();
}

@external
func test_get_max_number_reserves{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) {
    TestPoolGetReserveAddressByIdDeployed.test_get_address_of_reserve_by_id();
    return ();
}

// PoolSuppplyWithdraw : 4 test cases

@external
func test_pool_supply_withdraw_1{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) {
    TestPoolSupplyWithdrawDeployed.test_pool_supply_withdraw_spec_1();
    return ();
}

@external
func test_pool_supply_withdraw_2{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) {
    TestPoolSupplyWithdrawDeployed.test_pool_supply_withdraw_spec_2();
    return ();
}

@external
func test_pool_supply_withdraw_3{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) {
    TestPoolSupplyWithdrawDeployed.test_pool_supply_withdraw_spec_3();
    return ();
}

@external
func test_pool_supply_withdraw_4{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) {
    TestPoolSupplyWithdrawDeployed.test_pool_supply_withdraw_spec_4();
    return ();
}

//
// PoolAddressesProvider : 8 test cases
//

@external
func test_owner_adds_a_new_address_as_proxy{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    TestPoolAddressesProviderDeployed.test_owner_adds_a_new_address_as_proxy();
    return ();
}

@external
func test_owner_adds_a_new_address_with_no_proxy_and_turns_it_into_a_proxy_1{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    TestPoolAddressesProviderDeployed.test_owner_adds_a_new_address_with_no_proxy_and_turns_it_into_a_proxy_1(
        );
    return ();
}

@external
func test_owner_adds_a_new_address_with_no_proxy_and_turns_it_into_a_proxy_2{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    TestPoolAddressesProviderDeployed.test_owner_adds_a_new_address_with_no_proxy_and_turns_it_into_a_proxy_2(
        );
    return ();
}

@external
func test_unregister_a_proxy_address{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    TestPoolAddressesProviderDeployed.test_unregister_a_proxy_address();
    return ();
}

@external
func test_owner_adds_a_new_address_with_proxy_and_turns_it_into_a_no_proxy{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    TestPoolAddressesProviderDeployed.test_owner_adds_a_new_address_with_proxy_and_turns_it_into_a_no_proxy(
        );
    return ();
}

@external
func test_unregister_a_no_proxy_address{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    TestPoolAddressesProviderDeployed.test_unregister_a_no_proxy_address();
    return ();
}

@external
func test_owner_registers_an_existing_contract_with_proxy_and_upgrade_it{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    TestPoolAddressesProviderDeployed.test_owner_registers_an_existing_contract_with_proxy_and_upgrade_it(
        );
    return ();
}

@external
func test_owner_updates_the_implementation_of_a_proxy_which_is_already_initialized{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    TestPoolAddressesProviderDeployed.test_owner_updates_the_implementation_of_a_proxy_which_is_already_initialized(
        );
    return ();
}

//
// ATokenModifier : 4 test cases
//

@external
func test_owner_updates_the_pool_configurator{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    TestPoolAddressesProviderDeployed.test_owner_updates_the_pool_configurator();
    return ();
}

@external
func test_burn_wrong_pool{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    ATokenModifier.test_burn_wrong_pool();
    return ();
}

@external
func test_transfer_on_liquidation_wrong_pool{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    ATokenModifier.test_transfer_on_liquidation_wrong_pool();
    return ();
}

@external
func test_transfer_underlying_wrong_pool{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    ATokenModifier.test_transfer_underlying_wrong_pool();
    return ();
}

//
// ACLManager 18 test cases
//

@external
func test_default_admin_role{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    TestACLManager.test_default_admin_role();
    return ();
}

@external
func test_grant_flash_borrow_admin_role{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    TestACLManager.test_grant_flash_borrow_admin_role();
    return ();
}

@external
func test_grant_flash_borrow_admin_role_2{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    TestACLManager.test_grant_flash_borrow_admin_role_2();
    return ();
}

@external
func test_grant_flash_borrow_admin_role_3{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    TestACLManager.test_grant_flash_borrow_admin_role_3();
    return ();
}

@external
func test_grant_flash_borrow_admin_role_4{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    TestACLManager.test_grant_flash_borrow_admin_role_4();
    return ();
}

@external
func test_revoke_flash_borrow_admin_role{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    TestACLManager.test_revoke_flash_borrow_admin_role();
    return ();
}

@external
func test_grant_pool_admin_role{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    TestACLManager.test_grant_pool_admin_role();
    return ();
}

@external
func test_grant_emergency_admin_role{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    TestACLManager.test_grant_emergency_admin_role();
    return ();
}

@external
func test_grant_risk_admin_role{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    TestACLManager.test_grant_risk_admin_role();
    return ();
}

@external
func test_grant_bridge_role{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    TestACLManager.test_grant_bridge_role();
    return ();
}

@external
func test_grant_asset_listing_admin_role{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    TestACLManager.test_grant_asset_listing_admin_role();
    return ();
}

@external
func test_revoke_flash_borrower{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    TestACLManager.test_revoke_flash_borrower();
    return ();
}

@external
func test_revoke_flash_borrow_admin{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    TestACLManager.test_revoke_flash_borrow_admin();
    return ();
}

@external
func test_revoke_pool_admin_role{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) {
    TestACLManager.test_revoke_pool_admin_role();
    return ();
}

@external
func test_revoke_emergency_admin_role{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    TestACLManager.test_revoke_emergency_admin_role();
    return ();
}

@external
func test_revoke_risk_admin_role{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) {
    TestACLManager.test_revoke_risk_admin_role();
    return ();
}

@external
func test_revoke_bridge_role{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    TestACLManager.test_revoke_bridge_role();
    return ();
}

@external
func test_revoke_asset_listing_admin_role{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    TestACLManager.test_revoke_asset_listing_admin_role();
    return ();
}

//
// StableDebtTokenSpec tests : 7 test cases
//

@external
func test_initialization{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    return TestStableDebtTokenDeployed.test_initialization();
}

@external
func test_mint_not_pool_revert{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    return TestStableDebtTokenDeployed.test_mint_not_pool_revert();
}

@external
func test_burn_not_pool_revert{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    return TestStableDebtTokenDeployed.test_burn_not_pool_revert();
}

// TODO test_mint_transfer_events_on_behalf when borrowing is implemented
@external
func test_mint_transfer_events_on_behalf{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    return TestStableDebtTokenDeployed.test_mint_transfer_events_on_behalf();
}

@external
func test_burn_debt_term2_ge_term1{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) {
    return TestStableDebtTokenDeployed.test_burn_debt_term2_ge_term1();
}

@external
func test_set_incentives_controller{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    return TestStableDebtTokenDeployed.test_set_incentives_controller();
}

@external
func test_set_incentives_controller_not_pool_admin_revert{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    return TestStableDebtTokenDeployed.test_set_incentives_controller_not_pool_admin_revert();
}

@external
func test_activate_sentinel{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    TestPriceOracleSentinel.test_activate_sentinel();
    return ();
}

@external
func test_update_grace_period{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    TestPriceOracleSentinel.test_update_grace_period();
    return ();
}

@external
func test_risk_admin_update_grace_period{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    TestPriceOracleSentinel.test_risk_admin_update_grace_period();
    return ();
}

@external
func test_update_grace_period_with_not_admin{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    TestPriceOracleSentinel.test_update_grace_period_with_not_admin();
    return ();
}

@external
func test_pool_admin_update_sequencer_oracle{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    TestPriceOracleSentinel.test_pool_admin_update_sequencer_oracle();
    return ();
}

@external
func test_update_sequence_oracle_with_not_admin{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    TestPriceOracleSentinel.test_update_sequence_oracle_with_not_admin();
    return ();
}
