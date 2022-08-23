%lang starknet

from starkware.cairo.common.uint256 import Uint256

@contract_interface
namespace IVariableDebtToken:
    func initialize(
        initializing_pool : felt,
        underlying_asset : felt,
        incentives_controller : felt,
        debt_token_decimals : felt,
        debt_token_name : felt,
        debt_token_symbol : felt,
        params : felt,
    ):
    end

    #
    # Inherited from DebtTokenBase
    #

    func approve_delegation(delegatee : felt, amount : Uint256):
    end

    func borrow_allowance(from_user : felt, to_user : felt) -> (allowance : Uint256):
    end

    func UNDERLYING_ASSET_ADDRESS() -> (underlying : felt):
    end

    #
    # Inherited from IncentivizedERC20
    #

    func name() -> (name : felt):
    end

    func symbol() -> (symbol : felt):
    end

    func decimals() -> (decimals : felt):
    end

    func get_incentives_controller() -> (incentives_controller : felt):
    end

    func set_incentives_controller(incentives_controller : felt):
    end

    func POOL() -> (pool : felt):
    end

    #
    # Inherited from ScaledBalanceToken
    #

    func scaled_balance_of(user : felt) -> (balance : Uint256):
    end

    func scaled_total_supply() -> (total_supply : Uint256):
    end

    func get_scaled_user_balance_and_supply(user : felt) -> (balance : Uint256, supply : Uint256):
    end

    func get_previous_index() -> (index : Uint256):
    end

    func get_revision() -> (revision : felt):
    end

    func balance_of(user : felt) -> (balance : Uint256):
    end

    func total_supply() -> (total_supply : Uint256):
    end

    func mint(user : felt, on_behalf_of : felt, amount : felt, index : felt) -> (
        is_scaled_balance_null : felt, total_supply : Uint256
    ):
    end

    func burn(address_from : felt, amount : Uint256, index : felt) -> (total_supply : Uint256):
    end
end
