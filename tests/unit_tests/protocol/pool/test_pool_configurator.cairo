%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.bool import TRUE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math_cmp import is_not_zero
from starkware.starknet.common.syscalls import get_contract_address

from contracts.interfaces.i_a_token import IAToken
from contracts.interfaces.i_pool import IPool
from contracts.interfaces.i_stable_debt_token import IStableDebtToken
from contracts.interfaces.i_variable_debt_token import IVariableDebtToken
from contracts.protocol.libraries.types.configurator_input_types import ConfiguratorInputTypes
from contracts.protocol.pool.pool_configurator_library import PoolConfigurator

from tests.utils.constants import (
    DECIMALS_1,
    DECIMALS_2,
    INCENTIVES_CONTROLLER,
    INCENTIVES_CONTROLLER_2,
    MOCK_ACL_MANAGER,
    MOCK_ASSET_1,
    MOCK_ASSET_2,
    MOCK_POOL_ADDRESSES_PROVIDER,
    MOCK_POOL_CONFIGURATOR,
    NAME_1,
    NAME_2,
    POOL,
    SYMBOL_1,
    SYMBOL_2,
    TREASURY_1,
    TREASURY_2,
    USER_1,
)

@external
func __setup__{syscall_ptr: felt*, range_check_ptr}() {
    alloc_locals;
    local proxy_hash;
    local a_token_impl;
    local stable_debt_impl;
    local variable_debt_impl;
    local pool;
    %{
        context.proxy_hash = declare("./contracts/protocol/libraries/aave_upgradeability/initializable_immutable_admin_upgradeability_proxy.cairo").class_hash
        context.a_token_impl = declare("./contracts/protocol/tokenization/a_token.cairo").class_hash
        context.stable_debt_impl = declare("./contracts/protocol/tokenization/stable_debt_token.cairo").class_hash
        context.variable_debt_impl = declare("./contracts/protocol/tokenization/variable_debt_token.cairo").class_hash
        context.pool = deploy_contract("./contracts/protocol/pool/pool.cairo").contract_address
    %}
    return ();
}

@view
func test_initializer{syscall_ptr: felt*, range_check_ptr, pedersen_ptr: HashBuiltin*}() {
    let (pool_before) = PoolConfigurator.get_pool();
    assert pool_before = 0;
    let (addresses_provider_before) = PoolConfigurator.get_addresses_provider();
    assert addresses_provider_before = 0;

    %{ stop_mock = mock_call(ids.MOCK_POOL_ADDRESSES_PROVIDER, "get_pool", [ids.POOL]) %}
    PoolConfigurator.initialize(MOCK_POOL_ADDRESSES_PROVIDER);
    %{ stop_mock() %}

    let (pool_after) = PoolConfigurator.get_pool();
    assert pool_after = POOL;
    let (addresses_provider_after) = PoolConfigurator.get_addresses_provider();
    assert addresses_provider_after = MOCK_POOL_ADDRESSES_PROVIDER;
    return ();
}

@view
func test_init_reserves{syscall_ptr: felt*, range_check_ptr, pedersen_ptr: HashBuiltin*}() {
    alloc_locals;

    %{ stop_mock = mock_call(ids.MOCK_POOL_ADDRESSES_PROVIDER, "get_pool", [context.pool]) %}
    PoolConfigurator.initialize(MOCK_POOL_ADDRESSES_PROVIDER);
    %{ stop_mock() %}

    local proxy_hash;
    local a_token_impl;
    local stable_debt_impl;
    local variable_debt_impl;
    local pool;
    %{
        ids.proxy_hash = context.proxy_hash
        ids.a_token_impl = context.a_token_impl
        ids.stable_debt_impl = context.stable_debt_impl
        ids.variable_debt_impl = context.variable_debt_impl
        ids.pool = context.pool

        # following mocks are needed to call IncentivizedERC20.set_incentives_controller while initializing StableDebtToken
        stop_mock_pool = mock_call(ids.pool, "get_addresses_provider", [ids.MOCK_POOL_ADDRESSES_PROVIDER])
        stop_mock_provider_1 = mock_call(ids.MOCK_POOL_ADDRESSES_PROVIDER, "get_ACL_manager", [ids.MOCK_ACL_MANAGER])
        stop_mock_acl_1 = mock_call(ids.MOCK_ACL_MANAGER, "is_pool_admin", [ids.TRUE])
        stop_mock_acl_2 = mock_call(ids.MOCK_ACL_MANAGER, "is_asset_listing_admin", [ids.TRUE])

        # following mocks are needed to call as pool configurator
        store(ids.pool, "PoolStorage_addresses_provider", [ids.MOCK_POOL_ADDRESSES_PROVIDER])
        stop_mock_provider_2 = mock_call(ids.MOCK_POOL_ADDRESSES_PROVIDER, "get_address", [ids.MOCK_POOL_CONFIGURATOR])
        stop_prank_configurator = start_prank(ids.MOCK_POOL_CONFIGURATOR, target_contract_address = ids.pool)
    %}
    let (local input: ConfiguratorInputTypes.InitReserveInput*) = alloc();
    assert input[0] = ConfiguratorInputTypes.InitReserveInput(a_token_impl, stable_debt_impl, variable_debt_impl, DECIMALS_1, 0, MOCK_ASSET_1, TREASURY_1, INCENTIVES_CONTROLLER, NAME_1, SYMBOL_1, NAME_1, SYMBOL_1, NAME_1, SYMBOL_1, 0, proxy_hash, 1, 2, 3);
    assert input[1] = ConfiguratorInputTypes.InitReserveInput(a_token_impl, stable_debt_impl, variable_debt_impl, DECIMALS_2, 0, MOCK_ASSET_2, TREASURY_2, INCENTIVES_CONTROLLER_2, NAME_2, SYMBOL_2, NAME_2, SYMBOL_2, NAME_2, SYMBOL_2, 0, proxy_hash, 4, 5, 6);

    let (assets_len, _) = IPool.get_reserves_list(pool);
    assert assets_len = 0;

    PoolConfigurator.init_reserves(2, input);

    let (assets_len, assets) = IPool.get_reserves_list(pool);
    assert assets_len = 2;

    %{
        stop_prank_configurator()
        stop_mock_provider_2()

        stop_mock_acl_2()
        stop_mock_acl_1()
        stop_mock_provider_1()
        stop_mock_pool()
    %}

    //
    // Reserve 1
    //

    let (reserve_1) = IPool.get_reserve_data(pool, MOCK_ASSET_1);
    let a_token_1 = reserve_1.a_token_address;
    let stable_debt_token_1 = reserve_1.stable_debt_token_address;
    let variable_debt_token_1 = reserve_1.variable_debt_token_address;

    // AToken

    %{ stop_prank_user_a_token_1 = start_prank(ids.USER_1, target_contract_address=ids.a_token_1) %}

    let (pool_1) = IAToken.POOL(a_token_1);
    assert pool_1 = pool;

    let (treasury_1) = IAToken.RESERVE_TREASURY_ADDRESS(a_token_1);
    assert treasury_1 = TREASURY_1;

    let (asset_1) = IAToken.UNDERLYING_ASSET_ADDRESS(a_token_1);
    assert asset_1 = MOCK_ASSET_1;

    let (controller_1) = IAToken.get_incentives_controller(a_token_1);
    assert controller_1 = INCENTIVES_CONTROLLER;

    let (decimals_1) = IAToken.decimals(a_token_1);
    assert decimals_1 = DECIMALS_1;

    let (name_1) = IAToken.name(a_token_1);
    assert name_1 = NAME_1;

    let (symbol_1) = IAToken.symbol(a_token_1);
    assert symbol_1 = SYMBOL_1;

    %{ stop_prank_user_a_token_1() %}

    // StableDebtToken

    %{ stop_prank_user_stable_debt_token_1 = start_prank(ids.USER_1, target_contract_address=ids.stable_debt_token_1) %}

    let (pool_1) = IStableDebtToken.POOL(stable_debt_token_1);
    assert pool_1 = pool;

    let (asset_1) = IStableDebtToken.UNDERLYING_ASSET_ADDRESS(stable_debt_token_1);
    assert asset_1 = MOCK_ASSET_1;

    let (controller_1) = IStableDebtToken.get_incentives_controller(stable_debt_token_1);
    assert controller_1 = INCENTIVES_CONTROLLER;

    let (decimals_1) = IStableDebtToken.decimals(stable_debt_token_1);
    assert decimals_1 = DECIMALS_1;

    let (name_1) = IStableDebtToken.name(stable_debt_token_1);
    assert name_1 = NAME_1;

    let (symbol_1) = IStableDebtToken.symbol(stable_debt_token_1);
    assert symbol_1 = SYMBOL_1;

    %{ stop_prank_user_stable_debt_token_1() %}

    // VariableDebtToken

    %{ stop_prank_user_variable_debt_token_1 = start_prank(ids.USER_1, target_contract_address=ids.variable_debt_token_1) %}

    let (pool_1) = IVariableDebtToken.POOL(variable_debt_token_1);
    assert pool_1 = pool;

    let (asset_1) = IVariableDebtToken.UNDERLYING_ASSET_ADDRESS(variable_debt_token_1);
    assert asset_1 = MOCK_ASSET_1;

    let (controller_1) = IVariableDebtToken.get_incentives_controller(variable_debt_token_1);
    assert controller_1 = INCENTIVES_CONTROLLER;

    let (decimals_1) = IVariableDebtToken.decimals(variable_debt_token_1);
    assert decimals_1 = DECIMALS_1;

    let (name_1) = IVariableDebtToken.name(variable_debt_token_1);
    assert name_1 = NAME_1;

    let (symbol_1) = IVariableDebtToken.symbol(variable_debt_token_1);
    assert symbol_1 = SYMBOL_1;

    %{ stop_prank_user_variable_debt_token_1() %}

    //
    // Reserve 2
    //

    let (reserve_2) = IPool.get_reserve_data(pool, MOCK_ASSET_2);
    let a_token_2 = reserve_2.a_token_address;
    let stable_debt_token_2 = reserve_2.stable_debt_token_address;
    let variable_debt_token_2 = reserve_2.variable_debt_token_address;

    // AToken

    %{ stop_prank_user_a_token_2 = start_prank(ids.USER_1, target_contract_address=ids.a_token_2) %}

    let (pool_2) = IAToken.POOL(a_token_2);
    assert pool_2 = pool;

    let (treasury_2) = IAToken.RESERVE_TREASURY_ADDRESS(a_token_2);
    assert treasury_2 = TREASURY_2;

    let (asset_2) = IAToken.UNDERLYING_ASSET_ADDRESS(a_token_2);
    assert asset_2 = MOCK_ASSET_2;

    let (controller_2) = IAToken.get_incentives_controller(a_token_2);
    assert controller_2 = INCENTIVES_CONTROLLER_2;

    let (decimals_2) = IAToken.decimals(a_token_2);
    assert decimals_2 = DECIMALS_2;

    let (name_2) = IAToken.name(a_token_2);
    assert name_2 = NAME_2;

    let (symbol_2) = IAToken.symbol(a_token_2);
    assert symbol_2 = SYMBOL_2;

    %{ stop_prank_user_a_token_2() %}

    // StableDebtToken

    %{ stop_prank_user_stable_debt_token_2 = start_prank(ids.USER_1, target_contract_address=ids.stable_debt_token_2) %}

    let (pool_2) = IStableDebtToken.POOL(stable_debt_token_2);
    assert pool_2 = pool;

    let (asset_2) = IStableDebtToken.UNDERLYING_ASSET_ADDRESS(stable_debt_token_2);
    assert asset_2 = MOCK_ASSET_2;

    let (controller_2) = IStableDebtToken.get_incentives_controller(stable_debt_token_2);
    assert controller_2 = INCENTIVES_CONTROLLER_2;

    let (decimals_2) = IStableDebtToken.decimals(stable_debt_token_2);
    assert decimals_2 = DECIMALS_2;

    let (name_2) = IStableDebtToken.name(stable_debt_token_2);
    assert name_2 = NAME_2;

    let (symbol_2) = IStableDebtToken.symbol(stable_debt_token_2);
    assert symbol_2 = SYMBOL_2;

    %{ stop_prank_user_stable_debt_token_2() %}

    // VariableDebtToken

    %{ stop_prank_user_variable_debt_token_2 = start_prank(ids.USER_1, target_contract_address=ids.variable_debt_token_2) %}

    let (pool_2) = IVariableDebtToken.POOL(variable_debt_token_2);
    assert pool_2 = pool;

    let (asset_2) = IVariableDebtToken.UNDERLYING_ASSET_ADDRESS(variable_debt_token_2);
    assert asset_2 = MOCK_ASSET_2;

    let (controller_2) = IVariableDebtToken.get_incentives_controller(variable_debt_token_2);
    assert controller_2 = INCENTIVES_CONTROLLER_2;

    let (decimals_2) = IVariableDebtToken.decimals(variable_debt_token_2);
    assert decimals_2 = DECIMALS_2;

    let (name_2) = IVariableDebtToken.name(variable_debt_token_2);
    assert name_2 = NAME_2;

    let (symbol_2) = IVariableDebtToken.symbol(variable_debt_token_2);
    assert symbol_2 = SYMBOL_2;

    %{ stop_prank_user_variable_debt_token_2() %}

    return ();
}

@view
func test_drop_reserve{syscall_ptr: felt*, range_check_ptr, pedersen_ptr: HashBuiltin*}() {
    alloc_locals;

    %{ stop_mock = mock_call(ids.MOCK_POOL_ADDRESSES_PROVIDER, "get_pool", [context.pool]) %}
    PoolConfigurator.initialize(MOCK_POOL_ADDRESSES_PROVIDER);
    %{ stop_mock() %}

    local proxy_hash;
    local a_token_impl;
    local stable_debt_impl;
    local variable_debt_impl;
    local pool;
    %{
        ids.proxy_hash = context.proxy_hash
        ids.a_token_impl = context.a_token_impl
        ids.stable_debt_impl = context.stable_debt_impl
        ids.variable_debt_impl = context.variable_debt_impl
        ids.pool = context.pool

        # following mocks are needed to call IncentivizedERC20.set_incentives_controller while initializing StableDebtToken
        stop_mock_pool = mock_call(ids.pool, "get_addresses_provider", [ids.MOCK_POOL_ADDRESSES_PROVIDER])
        stop_mock_provider_1 = mock_call(ids.MOCK_POOL_ADDRESSES_PROVIDER, "get_ACL_manager", [ids.MOCK_ACL_MANAGER])
        stop_mock_acl_1 = mock_call(ids.MOCK_ACL_MANAGER, "is_pool_admin", [ids.TRUE])
        stop_mock_acl_2 = mock_call(ids.MOCK_ACL_MANAGER, "is_asset_listing_admin", [ids.TRUE])

        # following mocks are needed to call as pool configurator
        store(ids.pool, "PoolStorage_addresses_provider", [ids.MOCK_POOL_ADDRESSES_PROVIDER])
        stop_mock_provider_2 = mock_call(ids.MOCK_POOL_ADDRESSES_PROVIDER, "get_address", [ids.MOCK_POOL_CONFIGURATOR])
        stop_prank_configurator = start_prank(ids.MOCK_POOL_CONFIGURATOR, target_contract_address = ids.pool)
    %}

    let (local input: ConfiguratorInputTypes.InitReserveInput*) = alloc();
    assert input[0] = ConfiguratorInputTypes.InitReserveInput(a_token_impl, stable_debt_impl, variable_debt_impl, DECIMALS_1, 0, MOCK_ASSET_1, TREASURY_1, INCENTIVES_CONTROLLER, NAME_1, SYMBOL_1, NAME_1, SYMBOL_1, NAME_1, SYMBOL_1, 0, proxy_hash, 11, 22, 33);
    assert input[1] = ConfiguratorInputTypes.InitReserveInput(a_token_impl, stable_debt_impl, variable_debt_impl, DECIMALS_2, 0, MOCK_ASSET_2, TREASURY_2, INCENTIVES_CONTROLLER_2, NAME_2, SYMBOL_2, NAME_2, SYMBOL_2, NAME_2, SYMBOL_2, 0, proxy_hash, 44, 55, 66);

    PoolConfigurator.init_reserves(2, input);

    let (reserve_2) = IPool.get_reserve_data(pool, MOCK_ASSET_2);
    let a_token_2_not_zero = is_not_zero(reserve_2.a_token_address);
    assert a_token_2_not_zero = TRUE;

    PoolConfigurator.drop_reserve(MOCK_ASSET_2);

    let (assets_len, assets) = IPool.get_reserves_list(pool);
    assert assets_len = 1;

    let (reserve_2) = IPool.get_reserve_data(pool, MOCK_ASSET_2);
    assert reserve_2.a_token_address = 0;

    %{
        stop_prank_configurator()
        stop_mock_provider_2()

        stop_mock_acl_2()
        stop_mock_acl_1()
        stop_mock_provider_1()
        stop_mock_pool()
    %}
    return ();
}
