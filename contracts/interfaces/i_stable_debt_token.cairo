%lang starknet

from starkware.cairo.common.uint256 import Uint256

@contract_interface
namespace IStableDebtToken {
    func initialize(
        initializing_pool: felt,
        underlying_asset: felt,
        incentives_controller: felt,
        debt_token_decimals: felt,
        debt_token_name: felt,
        debt_token_symbol: felt,
        params: felt,
    ) {
    }

    //
    // Inherited from DebtTokenBase
    //

    func approve_delegation(delegatee: felt, amount: Uint256) {
    }

    func borrow_allowance(from_user: felt, to_user: felt) -> (allowance: Uint256) {
    }

    func UNDERLYING_ASSET_ADDRESS() -> (underlying: felt) {
    }

    //
    // Inherited from IncentivizedERC20
    //

    func name() -> (name: felt) {
    }

    func symbol() -> (symbol: felt) {
    }

    func decimals() -> (decimals: felt) {
    }

    func get_incentives_controller() -> (incentives_controller: felt) {
    }

    func set_incentives_controller(incentives_controller: felt) {
    }

    func principal_balance_of(user: felt) -> (balance: Uint256) {
    }

    func POOL() -> (pool: felt) {
    }

    //
    // StableDebtToken
    //

    func get_revision() -> (revision: felt) {
    }

    func get_average_stable_rate() -> (avg_stable_rate: felt) {
    }

    func get_user_last_updated(user: felt) -> (timestamp: felt) {
    }

    func get_user_stable_rate(user: felt) -> (stable_rate: felt) {
    }

    func balance_of(account: felt) -> (balance: Uint256) {
    }

    func mint(user: felt, on_behalf_of: felt, amount: Uint256, rate: felt) -> (
        is_first_borrow: felt, total_stable_debt: Uint256, avg_stable_borrow_rate: felt
    ) {
    }

    func burn(address_from: felt, amount: Uint256) -> (
        next_supply: Uint256, next_avg_stable_rate: felt
    ) {
    }

    func get_supply_data() -> (
        principal_supply: Uint256,
        total_supply: Uint256,
        avg_stable_rate: felt,
        total_supply_timestamp: felt,
    ) {
    }

    func get_total_supply_and_avg_rate() -> (total_supply: Uint256, avg_rate: felt) {
    }

    func total_supply() -> (total_supply: Uint256) {
    }

    func get_total_supply_last_updated() -> (timestamp: felt) {
    }
}
