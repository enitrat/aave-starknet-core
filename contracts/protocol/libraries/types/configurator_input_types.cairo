%lang starknet

namespace ConfiguratorInputTypes {
    struct InitReserveInput {
        a_token_impl: felt,
        stable_debt_token_impl: felt,
        variable_debt_token_impl: felt,
        underlying_asset_decimals: felt,
        interest_rate_strategy_address: felt,
        underlying_asset: felt,
        treasury: felt,
        incentives_controller: felt,
        a_token_name: felt,
        a_token_symbol: felt,
        variable_debt_token_name: felt,
        variable_debt_token_symbol: felt,
        stable_debt_token_name: felt,
        stable_debt_token_symbol: felt,
        params: felt,
        proxy_class_hash: felt,
        salt_a_token: felt,
        salt_stable_debt_token: felt,
        salt_variable_debt_token: felt,
    }

    struct UpdateATokenInput {
        asset: felt,
        treasury: felt,
        incentives_controller: felt,
        name: felt,
        symbol: felt,
        implementation_hash: felt,
        params: felt,
    }

    struct UpdateDebtTokenInput {
        asset: felt,
        incentives_controller: felt,
        name: felt,
        symbol: felt,
        implementation_hash: felt,
        params: felt,
    }
}
