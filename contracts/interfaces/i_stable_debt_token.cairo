%lang starknet

from starkware.cairo.common.uint256 import Uint256

@contract_interface
namespace IStableDebtToken:
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

    func principal_balance_of(user : felt) -> (balance : Uint256):
    end

    func POOL() -> (pool : felt):
    end

    #
    # StableDebtToken
    #

    func get_revision() -> (revision : felt):
    end

    func get_average_stable_rate() -> (avg_stable_rate : felt):
    end

    func get_user_last_updated(user : felt) -> (timestamp : felt):
    end

    func get_user_stable_rate(user : felt) -> (stable_rate : felt):
    end

    func balance_of(account : felt) -> (balance : Uint256):
    end

    func mint(user : felt, on_behalf_of : felt, amount : Uint256, rate : felt) -> (
        is_first_borrow : felt, total_stable_debt : Uint256, avg_stable_borrow_rate : felt
    ):
    end

    func burn(address_from : felt, amount : Uint256) -> (
        next_supply : Uint256, next_avg_stable_rate : felt
    ):
    end

    func get_supply_data() -> (
        principal_supply : Uint256,
        total_supply : Uint256,
        avg_stable_rate : felt,
        total_supply_timestamp : felt,
    ):
    end

    func get_total_supply_and_avg_rate() -> (total_supply : Uint256, avg_rate : felt):
    end

    func total_supply() -> (total_supply : Uint256):
    end

    func get_total_supply_last_updated() -> (timestamp : felt):
    end

    #
    # ERC20 disabled functions
    #

    func transfer(recipient : felt, amount : Uint256):
    end

    func transfer_from(sender : felt, recipient : felt, amount : Uint256):
    end

    func approve(spender : felt, amount : Uint256):
    end

    func allowance(owner : felt, spender : felt):
    end

    func increase_allowance(spender : felt, added_value : Uint256):
    end

    func decrease_allowance(spender : felt, subtracted_value : Uint256):
    end
end
