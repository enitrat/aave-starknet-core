%lang starknet
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256

from contracts.protocol.libraries.logic.validation_logic import ValidationLogic
from contracts.protocol.libraries.types.data_types import DataTypes
from contracts.protocol.libraries.configuration.reserve_configuration import ReserveConfiguration

from tests.utils.constants import (
    MOCK_A_TOKEN_1,
    BASE_LIQUIDITY_INDEX,
    STABLE_DEBT_TOKEN_ADDRESS,
    VARIABLE_DEBT_TOKEN_ADDRESS,
    INTEREST_RATE_STRATEGY_ADDRESS,
    VARIABLE_BORROW_INDEX,
)

func get_test_reserve{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    reserve : DataTypes.ReserveData
):
    return (
        DataTypes.ReserveData(BASE_LIQUIDITY_INDEX, 0, VARIABLE_BORROW_INDEX, 0, 0, 0, 0, MOCK_A_TOKEN_1, STABLE_DEBT_TOKEN_ADDRESS, VARIABLE_DEBT_TOKEN_ADDRESS, INTEREST_RATE_STRATEGY_ADDRESS, 0, 0, 0),
    )
end

@view
func test_validate_supply_when_reserve_is_inactive{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}():
    let (reserve) = get_test_reserve()
    %{ expect_revert(error_message="RESERVE_INACTIVE") %}
    ValidationLogic.validate_supply(reserve, Uint256(100, 0))
    return ()
end

@view
func test_validate_withdraw_when_reserve_is_inactive{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}():
    let (reserve) = get_test_reserve()
    %{ expect_revert(error_message="RESERVE_INACTIVE") %}
    ValidationLogic.validate_withdraw(reserve, Uint256(100, 0), Uint256(1000, 0))
    return ()
end

# TODO update test once reserves have active/frozen attributes
@view
func test_validate_supply_when_reserve_is_active{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}():
    alloc_locals
    let (reserve) = get_test_reserve()
    ReserveConfiguration.set_active(MOCK_A_TOKEN_1, 1)
    ValidationLogic.validate_supply(reserve, Uint256(100, 0))
    return ()
end

@view
func test_validate_withdraw_when_reserve_is_active{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}():
    alloc_locals
    let (reserve) = get_test_reserve()
    ReserveConfiguration.set_active(MOCK_A_TOKEN_1, 1)
    ValidationLogic.validate_withdraw(reserve, Uint256(100, 0), Uint256(1000, 0))
    return ()
end

@view
func test_validate_supply_amount_null{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}():
    let (reserve) = get_test_reserve()
    %{ expect_revert(error_message="INVALID_AMOUNT") %}
    ValidationLogic.validate_supply(reserve, Uint256(0, 0))
    return ()
end

@view
func test_validate_withdraw_amount_null{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}():
    let (reserve) = get_test_reserve()
    %{ expect_revert(error_message="Amount must be greater than 0") %}
    ValidationLogic.validate_withdraw(reserve, Uint256(0, 0), Uint256(100, 0))

    return ()
end

@view
func test_validate_withdraw_amount_greater_than_balance{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}():
    let (reserve) = get_test_reserve()
    %{ expect_revert() %}
    ValidationLogic.validate_withdraw(reserve, Uint256(1000, 0), Uint256(100, 0))

    return ()
end

# TODO test_validate_drop_reserve once storage cheatcode is available
