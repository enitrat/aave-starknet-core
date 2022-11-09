%lang starknet

from starkware.cairo.common.bool import FALSE, TRUE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import deploy, get_contract_address

from contracts.interfaces.i_pool import IPool
from contracts.interfaces.i_proxy import IProxy
from contracts.protocol.libraries.helpers.constants import INITIALIZE_SELECTOR
from contracts.protocol.libraries.types.configurator_input_types import ConfiguratorInputTypes
from contracts.protocol.libraries.types.data_types import DataTypes

//
// Events
//

@event
func ReserveInitialized(
    asset: felt,
    a_token: felt,
    stable_debt_token: felt,
    variable_debt_token: felt,
    interest_rate_strategy_address: felt,
) {
}

@event
func ATokenUpgraded(asset: felt, proxy: felt, implementation: felt) {
}

@event
func StableDebtTokenUpgraded(asset: felt, proxy: felt, implementation: felt) {
}

@event
func VariableDebtTokenUpgraded(asset: felt, proxy: felt, implementation: felt) {
}

//
// Namespace
//

namespace ConfiguratorLogic {
    func execute_init_reserve{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        pool: felt, input: ConfiguratorInputTypes.InitReserveInput
    ) -> (a_token: felt, stable_debt_token: felt, variable_debt_token: felt) {
        alloc_locals;

        let (a_token_proxy_address) = _init_token_with_proxy(
            input.a_token_impl,
            input.proxy_class_hash,
            input.salt_a_token,
            7,
            cast(new (pool, input.treasury, input.underlying_asset, input.incentives_controller, input.underlying_asset_decimals, input.a_token_name, input.a_token_symbol), felt*),
        );

        let (stable_debt_token_proxy_address) = _init_token_with_proxy(
            input.stable_debt_token_impl,
            input.proxy_class_hash,
            input.salt_stable_debt_token,
            7,
            cast(new (pool, input.underlying_asset, input.incentives_controller, input.underlying_asset_decimals, input.stable_debt_token_name, input.stable_debt_token_symbol, input.params), felt*),
        );

        let (variable_debt_token_proxy_address) = _init_token_with_proxy(
            input.variable_debt_token_impl,
            input.proxy_class_hash,
            input.salt_variable_debt_token,
            7,
            cast(new (pool, input.underlying_asset, input.incentives_controller, input.underlying_asset_decimals, input.variable_debt_token_name, input.variable_debt_token_symbol, input.params), felt*),
        );

        // TODO: update this once we implement interest rate strategy
        IPool.init_reserve(
            pool,
            input.underlying_asset,
            a_token_proxy_address,
            stable_debt_token_proxy_address,
            variable_debt_token_proxy_address,
            0,
        );

        IPool.set_configuration(
            pool,
            input.underlying_asset,
            DataTypes.ReserveConfiguration(
            0, 0, 0, input.underlying_asset_decimals, TRUE, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
            ),
        );

        // TODO: update this once we implement interest rate strategy
        ReserveInitialized.emit(
            input.underlying_asset,
            a_token_proxy_address,
            stable_debt_token_proxy_address,
            variable_debt_token_proxy_address,
            0,
        );

        return (
            a_token_proxy_address,
            stable_debt_token_proxy_address,
            variable_debt_token_proxy_address,
        );
    }

    func execute_update_a_token{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        pool: felt, input: ConfiguratorInputTypes.UpdateATokenInput
    ) {
        alloc_locals;

        let (reserve) = IPool.get_reserve_data(pool, input.asset);

        let (config) = IPool.get_configuration(pool, input.asset);
        let decimals = config.decimals;

        _upgrade_token_implementation(
            reserve.a_token_address,
            input.implementation_hash,
            INITIALIZE_SELECTOR,
            7,
            cast(new (
            pool,
            input.treasury,
            input.asset,
            input.incentives_controller,
            decimals,
            input.name,
            input.symbol
            ), felt*),
        );

        ATokenUpgraded.emit(input.asset, reserve.a_token_address, input.implementation_hash);

        return ();
    }

    func execute_update_stable_debt_token{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }(pool: felt, input: ConfiguratorInputTypes.UpdateDebtTokenInput) {
        alloc_locals;

        let (reserve) = IPool.get_reserve_data(pool, input.asset);

        let (config) = IPool.get_configuration(pool, input.asset);

        _upgrade_token_implementation(
            reserve.stable_debt_token_address,
            input.implementation_hash,
            INITIALIZE_SELECTOR,
            7,
            cast(new (
            pool,
            input.asset,
            input.incentives_controller,
            config.decimals,
            input.name,
            input.symbol,
            input.params,
            ), felt*),
        );

        StableDebtTokenUpgraded.emit(
            input.asset, reserve.stable_debt_token_address, input.implementation_hash
        );

        return ();
    }

    func execute_update_variable_debt_token{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }(pool: felt, input: ConfiguratorInputTypes.UpdateDebtTokenInput) {
        alloc_locals;

        let (reserve) = IPool.get_reserve_data(pool, input.asset);

        let (config) = IPool.get_configuration(pool, input.asset);

        _upgrade_token_implementation(
            reserve.variable_debt_token_address,
            input.implementation_hash,
            INITIALIZE_SELECTOR,
            7,
            cast(new (
            pool,
            input.asset,
            input.incentives_controller,
            config.decimals,
            input.name,
            input.symbol,
            input.params,
            ), felt*),
        );

        VariableDebtTokenUpgraded.emit(
            input.asset, reserve.variable_debt_token_address, input.implementation_hash
        );

        return ();
    }

    func _init_token_with_proxy{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        implementation_class_hash: felt,
        proxy_class_hash: felt,
        salt: felt,
        params_len: felt,
        params: felt*,
    ) -> (proxy_address: felt) {
        alloc_locals;
        let (proxy_admin) = get_contract_address();
        let (proxy) = deploy(
            class_hash=proxy_class_hash,
            contract_address_salt=salt,
            constructor_calldata_size=1,
            constructor_calldata=cast(new (proxy_admin), felt*),
            deploy_from_zero=0,
        );
        IProxy.initialize(
            proxy, implementation_class_hash, INITIALIZE_SELECTOR, params_len, params
        );
        return (proxy,);
    }

    func _upgrade_token_implementation{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }(
        proxy_address: felt,
        implementation_class_hash: felt,
        selector: felt,
        params_len: felt,
        params: felt*,
    ) {
        IProxy.upgrade_to_and_call(
            proxy_address, implementation_class_hash, selector, params_len, params
        );
        return ();
    }
}
