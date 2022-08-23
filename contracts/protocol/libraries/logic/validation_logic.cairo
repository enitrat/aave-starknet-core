%lang starknet
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.math import assert_not_zero
from starkware.cairo.common.math_cmp import is_not_zero
from starkware.cairo.common.uint256 import Uint256, uint256_eq, uint256_le, uint256_check

from openzeppelin.token.erc20.IERC20 import IERC20

from contracts.protocol.libraries.types.data_types import DataTypes
from contracts.protocol.libraries.helpers.helpers import is_zero
from contracts.protocol.libraries.helpers.bool_cmp import BoolCompare
from contracts.protocol.pool.pool_storage import PoolStorage
from contracts.protocol.libraries.configuration.reserve_configuration import ReserveConfiguration
from contracts.interfaces.i_a_token import IAToken
from contracts.interfaces.i_variable_debt_token import IVariableDebtToken

namespace ValidationLogic:
    # @notice Validates a supply action.
    # @param reserve The data of the reserve
    # @param amount The amount to be supplied
    func validate_supply{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        reserve : DataTypes.ReserveData, amount : Uint256
    ):
        uint256_check(amount)
        with_attr error_message("INVALID_AMOUNT"):
            let (is_zero) = uint256_eq(amount, Uint256(0, 0))
            assert is_zero = FALSE
        end

        let (is_active, is_frozen, _, _, is_paused) = ReserveConfiguration.get_flags(
            reserve.a_token_address
        )

        with_attr error_message("RESERVE_INACTIVE"):
            assert is_active = TRUE
        end
        with_attr error_message("RESERVE_PAUSED"):
            assert is_paused = FALSE
        end
        with_attr error_message("RESERVE_FROZEN"):
            assert is_frozen = FALSE
        end

        let (supply_cap) = ReserveConfiguration.get_supply_cap(reserve.a_token_address)

        # let (scaled_total_supply) = IAToken.scaled_total_supply(reserve.a_token_address)
        # let (reserve_cache)=ReserveConfiguration.get_cache(reserve.a_token_address)
        # let (supply_mul_liq_index)=ray_mul(Ray(scaled_total_supply), Ray(reserve_cache.next_liquidity_index))

        return ()
    end

    # @notice Validates a withdraw action.
    # @param reserve the data of the reserve
    # @param amount The amount to be withdrawn
    # @param user_balance The balance of the user
    func validate_withdraw{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        reserve : DataTypes.ReserveData, amount : Uint256, user_balance : Uint256
    ):
        alloc_locals
        uint256_check(amount)

        with_attr error_message("Amount must be greater than 0"):
            let (is_zero) = uint256_eq(amount, Uint256(0, 0))
            assert is_zero = FALSE
        end

        # Revert if withdrawing too much. Verify that amount<=balance
        with_attr error_message("User cannot withdraw more than the available balance"):
            let (is_le : felt) = uint256_le(amount, user_balance)
            assert is_le = TRUE
        end
        let (is_active, _, _, _, is_paused) = ReserveConfiguration.get_flags(
            reserve.a_token_address
        )
        with_attr error_message("RESERVE_INACTIVE"):
            assert is_active = TRUE
        end
        with_attr error_message("RESERVE_PAUSED"):
            assert is_paused = FALSE
        end
        return ()
    end

    # @notice Validates a drop reserve action.
    # @param reserve The reserve object
    # @param asset The address of the reserve's underlying asset
    func validate_drop_reserve{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        reserve : DataTypes.ReserveData, asset : felt
    ):
        with_attr error_message("Zero address not valid"):
            assert_not_zero(asset)
        end

        with_attr error_message("Asset is not listed"):
            let (is_id_not_zero) = is_not_zero(reserve.id)
            let (reserve_list_first) = PoolStorage.reserves_list_read(0)
            let (is_first_asset) = is_zero(reserve_list_first - asset)
            let (asset_listed) = BoolCompare.either(is_id_not_zero, is_first_asset)
            assert asset_listed = TRUE
        end

        # TODO verify that stable debt is zero

        let (variable_debt_supply) = IVariableDebtToken.total_supply(
            contract_address=reserve.variable_debt_token_address
        )
        with_attr error_message("Variable debt supply is not zero"):
            assert variable_debt_supply = Uint256(0, 0)
        end

        let (a_token_supply) = IERC20.totalSupply(contract_address=reserve.a_token_address)
        with_attr error_message("AToken supply is not zero"):
            assert a_token_supply = Uint256(0, 0)
        end
        return ()
    end

    # @notice Validates a flashloan action.
    # @param reserves_data The state of all the reserves
    # @param assets The assets being flash-borrowed
    # @param amounts The amounts for each asset being borrowed

    func validate_flashloan{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        reserves_data : DataTypes.ReserveData,
        assets_len : felt,
        assets : felt*,
        amounts_len : felt,
        amounts : felt*,
    ):
        # TO DO
    end
end
