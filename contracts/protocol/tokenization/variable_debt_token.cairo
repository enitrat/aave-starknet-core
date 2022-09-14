%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256

from openzeppelin.token.erc20.library import ERC20

from contracts.protocol.tokenization.base.incentivized_erc20_library import IncentivizedERC20
from contracts.protocol.tokenization.base.debt_token_base_library import DebtTokenBase
from contracts.protocol.tokenization.base.scaled_balance_token_library import ScaledBalanceToken
from contracts.protocol.tokenization.variable_debt_token_library import VariableDebtToken

@external
func initialize{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    initializing_pool: felt,
    underlying_asset: felt,
    incentives_controller: felt,
    debt_token_decimals: felt,
    debt_token_name: felt,
    debt_token_symbol: felt,
    params: felt,
) {
    return VariableDebtToken.initialize(
        initializing_pool,
        underlying_asset,
        incentives_controller,
        debt_token_decimals,
        debt_token_name,
        debt_token_symbol,
        params,
    );
}

//
// Inherited from DebtTokenBase
//

@external
func approve_delegation{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    delegatee: felt, amount: Uint256
) {
    return DebtTokenBase.approve_delegation(delegatee, amount);
}

@view
func borrow_allowance{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    from_user: felt, to_user: felt
) -> (allowance: Uint256) {
    return DebtTokenBase.borrow_allowance(from_user, to_user);
}

@view
func UNDERLYING_ASSET_ADDRESS{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) -> (underlying: felt) {
    return DebtTokenBase.get_underlying_asset();
}

//
// Inherited from IncentivizedERC20
//

@view
func name{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (name: felt) {
    return ERC20.name();
}

@view
func symbol{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (symbol: felt) {
    return ERC20.symbol();
}

@view
func decimals{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    decimals: felt
) {
    return ERC20.decimals();
}

@view
func get_incentives_controller{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) -> (incentives_controller: felt) {
    return IncentivizedERC20.get_incentives_controller();
}

@external
func set_incentives_controller{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    incentives_controller: felt
) {
    return IncentivizedERC20.set_incentives_controller(incentives_controller);
}

@view
func POOL{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (pool: felt) {
    return IncentivizedERC20.get_pool();
}

//
// Inherited from ScaledBalanceToken
//

@view
func scaled_balance_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    user: felt
) -> (balance: Uint256) {
    return IncentivizedERC20.balance_of(user);
}

@view
func scaled_total_supply{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    total_supply: Uint256
) {
    return IncentivizedERC20.total_supply();
}

@view
func get_scaled_user_balance_and_supply{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}(user: felt) -> (balance: Uint256, supply: Uint256) {
    return ScaledBalanceToken.get_scaled_user_balance_and_supply(user);
}

@view
func get_previous_index{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    user: felt
) -> (index: felt) {
    return ScaledBalanceToken.get_previous_index(user);
}

//
// VariableDebtToken
//

@view
func get_revision() -> (revision: felt) {
    return VariableDebtToken.get_revision();
}

@view
func balance_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(user: felt) -> (
    balance: Uint256
) {
    return VariableDebtToken.balance_of(user);
}

@view
func total_supply{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    total_supply: Uint256
) {
    return VariableDebtToken.total_supply();
}

@external
func mint{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    user: felt, on_behalf_of: felt, amount: Uint256, index: felt
) -> (is_scaled_balance_null: felt, total_supply: Uint256) {
    return VariableDebtToken.mint(user, on_behalf_of, amount, index);
}

@external
func burn{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    address_from: felt, amount: Uint256, index: felt
) -> (total_supply: Uint256) {
    return VariableDebtToken.burn(address_from, amount, index);
}
