%lang starknet

from starkware.cairo.common.uint256 import Uint256

@contract_interface
namespace IVariableDebtToken {
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

    func POOL() -> (pool: felt) {
    }

    //
    // Inherited from ScaledBalanceToken
    //

    func scaled_balance_of(user: felt) -> (balance: Uint256) {
    }

    func scaled_total_supply() -> (total_supply: Uint256) {
    }

    func get_scaled_user_balance_and_supply(user: felt) -> (balance: Uint256, supply: Uint256) {
    }

    func get_previous_index(user: felt) -> (index: felt) {
    }

    func get_revision() -> (revision: felt) {
    }

    func balance_of(user: felt) -> (balance: Uint256) {
    }

    func total_supply() -> (total_supply: Uint256) {
    }

    func mint(user: felt, on_behalf_of: felt, amount: Uint256, index: felt) -> (
        is_scaled_balance_null: felt, total_supply: Uint256
    ) {
    }

    func burn(address_from: felt, amount: Uint256, index: felt) -> (total_supply: Uint256) {
    }
}
