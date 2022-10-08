%lang starknet

from starkware.cairo.common.uint256 import Uint256

@contract_interface
namespace IAToken {
    func initialize(
        pool: felt,
        treasury: felt,
        underlying_asset: felt,
        incentives_controller: felt,
        a_token_decimals: felt,
        a_token_name: felt,
        a_token_symbol: felt,
    ) {
    }

    func name() -> (name: felt) {
    }

    func symbol() -> (symbol: felt) {
    }

    func totalSupply() -> (totalSupply: Uint256) {
    }

    func decimals() -> (decimals: felt) {
    }

    func balanceOf(account: felt) -> (balance: Uint256) {
    }

    func scaled_balance_of(account: felt) -> (balance: Uint256) {
    }

    func allowance(owner: felt, spender: felt) -> (remaining: Uint256) {
    }

    func RESERVE_TREASURY_ADDRESS() -> (res: felt) {
    }

    func UNDERLYING_ASSET_ADDRESS() -> (res: felt) {
    }

    func POOL() -> (res: felt) {
    }

    func transfer(recipient: felt, amount: Uint256) -> (success: felt) {
    }

    func transferFrom(sender: felt, recipient: felt, amount: Uint256) -> (success: felt) {
    }

    func approve(spender: felt, amount: Uint256) -> (success: felt) {
    }

    func increaseAllowance(spender: felt, added_value: Uint256) -> (success: felt) {
    }

    func decreaseAllowance(spender: felt, subtracted_value: Uint256) -> (success: felt) {
    }

    func mint(caller: felt, on_behalf_of: felt, amount: Uint256, index: Uint256) -> (
        success: felt
    ) {
    }

    func burn(from_: felt, receiver_or_underlying: felt, amount: Uint256, index: Uint256) -> (
        success: felt
    ) {
    }

    func mint_to_treasury(amount: Uint256, index: Uint256) -> (success: felt) {
    }

    func transfer_on_liquidation(from_: felt, to: felt, value: Uint256) {
    }

    func transfer_underlying_to(target: felt, amount: Uint256) {
    }

    func handle_repayment(token: felt, to: felt, amount: Uint256) {
    }

    func permit(token: felt, to: felt, amount: Uint256) {
    }

    func rescue_tokens(token: felt, to: felt, amount: Uint256) {
    }

    func scaled_total_supply() -> (total_supply: Uint256) {
    }

    func get_incentives_controller() -> (controller: felt) {
    }
}
