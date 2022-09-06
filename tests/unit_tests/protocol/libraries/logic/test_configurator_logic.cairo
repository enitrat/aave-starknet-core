%lang starknet

from starkware.cairo.common.bool import TRUE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_contract_address

from contracts.interfaces.i_a_token import IAToken
from contracts.interfaces.i_stable_debt_token import IStableDebtToken
from contracts.protocol.libraries.helpers.constants import INITIALIZE_SELECTOR
from contracts.protocol.libraries.logic.configurator_logic import ConfiguratorLogic
from contracts.protocol.libraries.types.configurator_input_types import ConfiguratorInputTypes
from tests.utils.constants import (
    USER_1,
    INCENTIVES_CONTROLLER,
    INCENTIVES_CONTROLLER_2,
    POOL,
    POOL_2,
    MOCK_ASSET_1,
    MOCK_ASSET_2,
    TREASURY_1,
    TREASURY_2,
    NAME_1,
    NAME_2,
    SYMBOL_1,
    SYMBOL_2,
    DECIMALS_1,
    DECIMALS_2,
    MOCK_ACL_MANAGER,
    MOCK_POOL_ADDRESSES_PROVIDER,
    MOCK_POOL_CONFIGURATOR,
)

const PRANK_SALT_A_TOKEN = 81
const PRANK_SALT_STABLE_DEBT_TOKEN = 82
const PRANK_SALT_VARIABLE_DEBT_TOKEN = 83

@external
func __setup__{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    tempvar a_token_hash
    tempvar stable_debt_hash
    tempvar proxy_hash
    tempvar pool
    %{
        context.proxy_hash = declare("./contracts/protocol/libraries/aave_upgradeability/initializable_immutable_admin_upgradeability_proxy.cairo").class_hash
        context.a_token_hash = declare("./contracts/protocol/tokenization/a_token.cairo").class_hash
        context.stable_debt_hash = declare("./contracts/protocol/tokenization/stable_debt_token.cairo").class_hash
        context.variable_debt_hash = declare("./contracts/protocol/tokenization/variable_debt_token.cairo").class_hash
        context.pool = deploy_contract("./contracts/protocol/pool/pool.cairo").contract_address
    %}
    return ()
end

@view
func test_init_token_with_proxy{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    ):
    alloc_locals
    tempvar a_token_hash
    tempvar proxy_hash
    %{
        ids.a_token_hash = context.a_token_hash
        ids.proxy_hash = context.proxy_hash
    %}

    let (proxy) = ConfiguratorLogic._init_token_with_proxy(
        a_token_hash,
        proxy_hash,
        PRANK_SALT_A_TOKEN,
        7,
        cast(new (POOL, TREASURY_1, MOCK_ASSET_1, INCENTIVES_CONTROLLER, DECIMALS_1, NAME_1, SYMBOL_1), felt*),
    )

    %{ stop_prank_user = start_prank(ids.USER_1, target_contract_address=ids.proxy) %}

    let (pool) = IAToken.POOL(proxy)
    assert pool = POOL

    let (treasury) = IAToken.RESERVE_TREASURY_ADDRESS(proxy)
    assert treasury = TREASURY_1

    let (asset) = IAToken.UNDERLYING_ASSET_ADDRESS(proxy)
    assert asset = MOCK_ASSET_1

    let (controller) = IAToken.get_incentives_controller(proxy)
    assert controller = INCENTIVES_CONTROLLER

    let (decimals) = IAToken.decimals(proxy)
    assert decimals = DECIMALS_1

    let (name) = IAToken.name(proxy)
    assert name = NAME_1

    let (symbol) = IAToken.symbol(proxy)
    assert symbol = SYMBOL_1

    %{ stop_prank_user() %}

    return ()
end

@view
func test_upgrade_token_implementation{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}():
    alloc_locals
    local a_token_hash
    tempvar proxy_hash
    %{
        ids.a_token_hash = context.a_token_hash
        ids.proxy_hash = context.proxy_hash
    %}

    let (proxy) = ConfiguratorLogic._init_token_with_proxy(
        a_token_hash,
        proxy_hash,
        PRANK_SALT_A_TOKEN,
        7,
        cast(new (POOL, TREASURY_1, MOCK_ASSET_1, INCENTIVES_CONTROLLER, DECIMALS_1, NAME_1, SYMBOL_1), felt*),
    )

    ConfiguratorLogic._upgrade_token_implementation(
        proxy,
        a_token_hash,
        INITIALIZE_SELECTOR,
        7,
        cast(new (POOL_2, TREASURY_2, MOCK_ASSET_2, INCENTIVES_CONTROLLER_2, DECIMALS_2, NAME_2, SYMBOL_2), felt*),
    )

    %{ stop_prank_user = start_prank(ids.USER_1, target_contract_address=ids.proxy) %}

    let (pool) = IAToken.POOL(proxy)
    assert pool = POOL_2

    let (treasury) = IAToken.RESERVE_TREASURY_ADDRESS(proxy)
    assert treasury = TREASURY_2

    let (asset) = IAToken.UNDERLYING_ASSET_ADDRESS(proxy)
    assert asset = MOCK_ASSET_2

    let (controller) = IAToken.get_incentives_controller(proxy)
    assert controller = INCENTIVES_CONTROLLER_2

    let (decimals) = IAToken.decimals(proxy)
    assert decimals = DECIMALS_2

    let (name) = IAToken.name(proxy)
    assert name = NAME_2

    let (symbol) = IAToken.symbol(proxy)
    assert symbol = SYMBOL_2

    %{ stop_prank_user() %}

    return ()
end

@view
func test_execute_init_reserve{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals
    local pool
    tempvar a_token_hash
    tempvar stable_debt_hash
    tempvar variable_debt_hash
    tempvar proxy_hash
    %{
        ids.a_token_hash = context.a_token_hash
        ids.stable_debt_hash = context.stable_debt_hash
        ids.variable_debt_hash = context.variable_debt_hash
        ids.proxy_hash = context.proxy_hash
        ids.pool = context.pool
    %}

    let reserve_input = ConfiguratorInputTypes.InitReserveInput(
        a_token_hash,
        stable_debt_hash,
        variable_debt_hash,
        DECIMALS_1,
        0,
        MOCK_ASSET_1,
        TREASURY_1,
        INCENTIVES_CONTROLLER,
        NAME_1,
        SYMBOL_1,
        NAME_1,
        SYMBOL_1,
        NAME_1,
        SYMBOL_1,
        0,
        proxy_hash,
        PRANK_SALT_A_TOKEN,
        PRANK_SALT_STABLE_DEBT_TOKEN,
        PRANK_SALT_VARIABLE_DEBT_TOKEN,
    )

    %{
        # following mocks are needed to call IncentivizedERC20.set_incentives_controller while initializing StableDebtToken
        stop_pool = mock_call(ids.pool, "get_addresses_provider", [ids.MOCK_POOL_ADDRESSES_PROVIDER])
        stop_provider = mock_call(ids.MOCK_POOL_ADDRESSES_PROVIDER, "get_ACL_manager", [ids.MOCK_ACL_MANAGER])
        stop_acl = mock_call(ids.MOCK_ACL_MANAGER, "is_pool_admin", [ids.TRUE])
        # following mocks are needed to call as pool configurator
        store(ids.pool, "PoolStorage_addresses_provider", [ids.MOCK_POOL_ADDRESSES_PROVIDER])
        stop_configurator = mock_call(ids.MOCK_POOL_ADDRESSES_PROVIDER, "get_address", [ids.MOCK_POOL_CONFIGURATOR])
        stop_prank_configurator = start_prank(ids.MOCK_POOL_CONFIGURATOR, target_contract_address = ids.pool)
    %}
    let (a_token, stable_debt_token, variable_debt_token) = ConfiguratorLogic.execute_init_reserve(
        pool, reserve_input
    )
    %{
        stop_prank_configurator()
        stop_configurator()
        stop_acl()
        stop_provider()
        stop_pool()
    %}

    # AToken

    %{ stop_prank_user_a_token = start_prank(ids.USER_1, target_contract_address=ids.a_token) %}

    let (pool_) = IAToken.POOL(a_token)
    assert pool_ = pool

    let (treasury) = IAToken.RESERVE_TREASURY_ADDRESS(a_token)
    assert treasury = TREASURY_1

    let (asset) = IAToken.UNDERLYING_ASSET_ADDRESS(a_token)
    assert asset = MOCK_ASSET_1

    let (controller) = IAToken.get_incentives_controller(a_token)
    assert controller = INCENTIVES_CONTROLLER

    let (decimals) = IAToken.decimals(a_token)
    assert decimals = DECIMALS_1

    let (name) = IAToken.name(a_token)
    assert name = NAME_1

    let (symbol) = IAToken.symbol(a_token)
    assert symbol = SYMBOL_1

    %{ stop_prank_user_a_token() %}

    # StableDebtToken

    %{ stop_prank_user_stable_debt_token = start_prank(ids.USER_1, target_contract_address=ids.stable_debt_token) %}

    let (pool_) = IStableDebtToken.POOL(stable_debt_token)
    assert pool_ = pool

    let (asset) = IStableDebtToken.UNDERLYING_ASSET_ADDRESS(stable_debt_token)
    assert asset = MOCK_ASSET_1

    let (controller) = IStableDebtToken.get_incentives_controller(stable_debt_token)
    assert controller = INCENTIVES_CONTROLLER

    let (decimals) = IStableDebtToken.decimals(stable_debt_token)
    assert decimals = DECIMALS_1

    let (name) = IStableDebtToken.name(stable_debt_token)
    assert name = NAME_1

    let (symbol) = IStableDebtToken.symbol(stable_debt_token)
    assert symbol = SYMBOL_1

    %{ stop_prank_user_stable_debt_token() %}

    # VariableDebtToken

    # TODO: to be checked once interface is available

    return ()
end

@view
func test_execute_update_a_token{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    ):
    alloc_locals
    local pool
    local a_token_hash
    tempvar stable_debt_hash
    tempvar variable_debt_hash
    tempvar proxy_hash
    %{
        ids.a_token_hash = context.a_token_hash
        ids.stable_debt_hash = context.stable_debt_hash
        ids.variable_debt_hash = context.variable_debt_hash
        ids.proxy_hash = context.proxy_hash
        ids.pool = context.pool
    %}

    let reserve_input = ConfiguratorInputTypes.InitReserveInput(
        a_token_hash,
        stable_debt_hash,
        variable_debt_hash,
        DECIMALS_1,
        0,
        MOCK_ASSET_1,
        TREASURY_1,
        INCENTIVES_CONTROLLER,
        NAME_1,
        SYMBOL_1,
        NAME_1,
        SYMBOL_1,
        NAME_1,
        SYMBOL_1,
        0,
        proxy_hash,
        PRANK_SALT_A_TOKEN,
        PRANK_SALT_STABLE_DEBT_TOKEN,
        PRANK_SALT_VARIABLE_DEBT_TOKEN,
    )

    %{
        # following mocks are needed to call IncentivizedERC20.set_incentives_controller while initializing StableDebtToken
        stop_pool = mock_call(ids.pool, "get_addresses_provider", [ids.MOCK_POOL_ADDRESSES_PROVIDER])
        stop_provider = mock_call(ids.MOCK_POOL_ADDRESSES_PROVIDER, "get_ACL_manager", [ids.MOCK_ACL_MANAGER])
        stop_acl = mock_call(ids.MOCK_ACL_MANAGER, "is_pool_admin", [ids.TRUE])
        # following mocks are needed to call as pool configurator
        store(ids.pool, "PoolStorage_addresses_provider", [ids.MOCK_POOL_ADDRESSES_PROVIDER])
        stop_configurator = mock_call(ids.MOCK_POOL_ADDRESSES_PROVIDER, "get_address", [ids.MOCK_POOL_CONFIGURATOR])
        stop_prank_configurator = start_prank(ids.MOCK_POOL_CONFIGURATOR, target_contract_address = ids.pool)
    %}
    let (a_token, stable_debt_token, variable_debt_token) = ConfiguratorLogic.execute_init_reserve(
        pool, reserve_input
    )
    %{
        stop_prank_configurator()
        stop_configurator()
        stop_acl()
        stop_provider()
        stop_pool()
    %}

    let update_input = ConfiguratorInputTypes.UpdateATokenInput(
        MOCK_ASSET_1, TREASURY_2, INCENTIVES_CONTROLLER_2, NAME_2, SYMBOL_2, a_token_hash, 0
    )

    ConfiguratorLogic.execute_update_a_token(pool, update_input)

    %{ stop_prank_user = start_prank(ids.USER_1, target_contract_address=ids.a_token) %}

    let (treasury) = IAToken.RESERVE_TREASURY_ADDRESS(a_token)
    assert treasury = TREASURY_2

    let (asset) = IAToken.UNDERLYING_ASSET_ADDRESS(a_token)
    assert asset = MOCK_ASSET_1

    let (controller) = IAToken.get_incentives_controller(a_token)
    assert controller = INCENTIVES_CONTROLLER_2

    let (name) = IAToken.name(a_token)
    assert name = NAME_2

    let (symbol) = IAToken.symbol(a_token)
    assert symbol = SYMBOL_2

    %{ stop_prank_user() %}

    return ()
end
