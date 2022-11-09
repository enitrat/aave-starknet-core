%lang starknet

from contracts.protocol.libraries.types.configurator_input_types import ConfiguratorInputTypes

@contract_interface
namespace IPoolConfigurator {
    func get_revision() -> (revision: felt) {
    }

    func initialize(provider: felt) {
    }

    func init_reserves(input_len: felt, input: ConfiguratorInputTypes.InitReserveInput*) {
    }

    func drop_reserve(asset: felt) {
    }

    func update_a_token(input: ConfiguratorInputTypes.UpdateATokenInput) {
    }

    func update_stable_debt_token(input: ConfiguratorInputTypes.UpdateDebtTokenInput) {
    }

    func update_variable_debt_token(input: ConfiguratorInputTypes.UpdateDebtTokenInput) {
    }

    func set_reserve_borrowing(asset: felt, enabled: felt) {
    }
}
