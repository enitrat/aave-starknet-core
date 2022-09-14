%lang starknet

from starkware.cairo.common.uint256 import Uint256

from contracts.protocol.libraries.types.data_types import DataTypes

@contract_interface
namespace IPool {
    func initialize(provider: felt) {
    }

    func supply(asset: felt, amount: Uint256, on_behalf_of: felt, referral_code: felt) {
    }

    func withdraw(asset: felt, amount: Uint256, to: felt) {
    }

    func init_reserve(
        asset: felt,
        a_token_address: felt,
        stable_debt_token_address: felt,
        variable_debt_token_address: felt,
        interest_rate_strategy_address: felt,
    ) {
    }

    func drop_reserve(asset: felt) {
    }

    func set_configuration(asset: felt, configuration: DataTypes.ReserveConfiguration) {
    }

    func get_configuration(asset: felt) -> (reserve_config: DataTypes.ReserveConfiguration) {
    }

    func get_reserve_data(asset: felt) -> (reserve_data: DataTypes.ReserveData) {
    }

    func get_reserves_list() -> (assets_len: felt, assets: felt*) {
    }

    func get_reserve_address_by_id(reserve_id: felt) -> (address: felt) {
    }

    func MAX_NUMBER_RESERVES() -> (max_number: felt) {
    }

    func get_reserve_normalized_income(asset: felt) -> (res: Uint256) {
    }

    func get_reserve_normalized_variable_debt(asset: felt) -> (res: felt) {
    }

    func finalize_transfer(
        asset: felt,
        sender: felt,
        recipient: felt,
        amount: Uint256,
        sender_balance: Uint256,
        recipient_balance: Uint256,
    ) {
    }

    func get_addresses_provider() -> (provider: felt) {
    }

    func get_revision() -> (val: felt) {
    }
}
