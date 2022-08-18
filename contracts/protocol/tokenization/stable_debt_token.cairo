%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256

from openzeppelin.token.erc20.library import ERC20

from contracts.protocol.tokenization.base.incentivized_erc20_library import IncentivizedERC20
from contracts.protocol.tokenization.base.debt_token_base_library import DebtTokenBase
from contracts.protocol.tokenization.stable_debt_token_library import StableDebtToken
from contracts.protocol.libraries.types.data_types import DataTypes

@external
func initialize{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    initializing_pool : felt,
    underlying_asset : felt,
    incentives_controller : felt,
    debt_token_decimals : felt,
    debt_token_name : felt,
    debt_token_symbol : felt,
    params : felt,
):
    return StableDebtToken.initialize(
        initializing_pool,
        underlying_asset,
        incentives_controller,
        debt_token_decimals,
        debt_token_name,
        debt_token_symbol,
        params,
    )
end

#
# Inherited from DebtTokenBase
#

@external
func approve_delegation{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    delegatee : felt, amount : Uint256
):
    return DebtTokenBase.approve_delegation(delegatee, amount)
end

@view
func borrow_allowance{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    from_user : felt, to_user : felt
) -> (allowance : Uint256):
    return DebtTokenBase.borrow_allowance(from_user, to_user)
end

@view
func UNDERLYING_ASSET_ADDRESS{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    ) -> (underlying : felt):
    return DebtTokenBase.get_underlying_asset()
end

#
# Inherited from IncentivizedERC20
#

@view
func name{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (name : felt):
    return ERC20.name()
end

@view
func symbol{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (symbol : felt):
    return ERC20.symbol()
end

@view
func decimals{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    decimals : felt
):
    return ERC20.decimals()
end

@view
func get_incentives_controller{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    ) -> (incentives_controller : felt):
    return IncentivizedERC20.get_incentives_controller()
end

@external
func set_incentives_controller{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    incentives_controller : felt
):
    return IncentivizedERC20.set_incentives_controller(incentives_controller)
end

@view
func principal_balance_of{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    user : felt
) -> (balance : Uint256):
    return IncentivizedERC20.balance_of(user)
end

@view
func POOL{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (pool : felt):
    return IncentivizedERC20.get_pool()
end

#
# StableDebtToken
#

@view
func get_revision() -> (revision : felt):
    return StableDebtToken.get_revision()
end

@view
func get_average_stable_rate{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    ) -> (avg_stable_rate : felt):
    return StableDebtToken.get_average_stable_rate()
end

@view
func get_user_last_updated{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    user : felt
) -> (timestamp : felt):
    return StableDebtToken.get_user_last_updated(user)
end

@view
func get_user_stable_rate{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    user : felt
) -> (stable_rate : felt):
    return StableDebtToken.get_user_stable_rate(user)
end

@view
func balance_of{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    account : felt
) -> (balance : Uint256):
    return StableDebtToken.balance_of(account)
end

@external
func mint{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    user : felt, on_behalf_of : felt, amount : Uint256, rate : felt
) -> (is_first_borrow : felt, total_stable_debt : Uint256, avg_stable_borrow_rate : felt):
    return StableDebtToken.mint(user, on_behalf_of, amount, rate)
end

@external
func burn{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    address_from : felt, amount : Uint256
) -> (next_supply : Uint256, next_avg_stable_rate : felt):
    return StableDebtToken.burn(address_from, amount)
end

@view
func get_supply_data{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    principal_supply : Uint256,
    total_supply : Uint256,
    avg_stable_rate : felt,
    total_supply_timestamp : felt,
):
    return StableDebtToken.get_supply_data()
end

@view
func get_total_supply_and_avg_rate{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}() -> (total_supply : Uint256, avg_rate : felt):
    return StableDebtToken.get_total_supply_and_avg_rate()
end

@view
func total_supply{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    total_supply : Uint256
):
    return StableDebtToken.total_supply()
end

@view
func get_total_supply_last_updated{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}() -> (timestamp : felt):
    return StableDebtToken.get_total_supply_last_updated()
end

#
# Other ERC20 functions are disabled
#
