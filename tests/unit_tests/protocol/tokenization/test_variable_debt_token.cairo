%lang starknet

from starkware.cairo.common.bool import FALSE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from starkware.starknet.common.syscalls import get_contract_address

from contracts.protocol.libraries.math.wad_ray_math import WadRayMath
from contracts.protocol.tokenization.variable_debt_token_library import VariableDebtToken
from contracts.protocol.tokenization.base.scaled_balance_token_library import ScaledBalanceToken
from contracts.protocol.tokenization.base.debt_token_base_library import DebtTokenBase
from contracts.protocol.tokenization.base.incentivized_erc20_library import IncentivizedERC20
from contracts.protocol.libraries.helpers.errors import Errors
from tests.utils.constants import (
    POOL,
    MOCK_TOKEN_1,
    INCENTIVES_CONTROLLER,
    USER_1,
    POOL_ADDRESSES_PROVIDER,
    ACL_MANAGER,
)

const DECIMALS = 18
const NAME = 'Variable Debt Token'
const SYMBOL = 'VDT'

@external
func test_initializer{syscall_ptr : felt*, range_check_ptr, pedersen_ptr : HashBuiltin*}():
    let (test) = get_contract_address()
    %{
        stop_mock_1 = mock_call(ids.POOL,"get_addresses_provider", [ids.POOL_ADDRESSES_PROVIDER])
        stop_mock_is_pool_admin_1 = mock_call(ids.POOL_ADDRESSES_PROVIDER, "get_ACL_manager", [ids.ACL_MANAGER])
        stop_mock_is_pool_admin_2 = mock_call(ids.ACL_MANAGER, "is_pool_admin", [1])
    %}
    VariableDebtToken.initialize(
        POOL, MOCK_TOKEN_1, INCENTIVES_CONTROLLER, DECIMALS, NAME, SYMBOL, ''
    )

    let (asset_after) = DebtTokenBase.get_underlying_asset()
    assert asset_after = MOCK_TOKEN_1
    let (pool_after) = IncentivizedERC20.get_pool()
    assert pool_after = POOL
    let (incentives_controller_after) = IncentivizedERC20.get_incentives_controller()
    assert incentives_controller_after = INCENTIVES_CONTROLLER
    let (scaled_balance, scaled_supply) = ScaledBalanceToken.get_scaled_user_balance_and_supply(
        USER_1
    )
    assert scaled_balance = Uint256(0, 0)
    assert scaled_supply = Uint256(0, 0)

    # TODO Deposit tokens and borrow some in variable mode. Eventually move this test case in a variable_debt_token_spec for integration with deployed contracts.

    %{ stop_mock_1() %}
    return ()
end

# Tries to mint not being the Pool (revert expected)
@external
func test_mint_not_pool_revert{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    let (test) = get_contract_address()
    %{
        # store a different pool address than our test address
        store(ids.test, "IncentivizedERC20_pool",[ids.POOL])  
        expect_revert(error_message=f"{ids.Errors.CALLER_MUST_BE_POOL}")
    %}
    VariableDebtToken.mint(USER_1, USER_1, Uint256(1, 0), 1)
    return ()
end

# Tries to burn not being the Pool (revert expected)
@external
func test_burn_not_pool_revert{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    let (test) = get_contract_address()
    %{
        store(ids.test, "IncentivizedERC20_pool",[ids.POOL])  
        expect_revert(error_message=f"{ids.Errors.CALLER_MUST_BE_POOL}")
    %}
    VariableDebtToken.burn(USER_1, Uint256(1, 0), 1)
    return ()
end

# Tries to mint with amountScaled == 0 (revert expected)
@external
func test_mint_amount_null{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    let (test) = get_contract_address()
    %{
        # mock pool
        store(ids.test, "IncentivizedERC20_pool",[ids.POOL])  
        stop_prank_pool = start_prank(ids.POOL)
        expect_revert(error_message=f"{ids.Errors.INVALID_AMOUNT}")
    %}
    VariableDebtToken.mint(USER_1, USER_1, Uint256(0, 0), 1)
    return ()
end

# Tries to mint with amountScaled == 0 (revert expected)
@external
func test_burn_amount_null{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    let (test) = get_contract_address()

    %{
        # mock pool
        store(ids.test, "IncentivizedERC20_pool",[ids.POOL])
        stop_prank_pool = start_prank(ids.POOL)
        expect_revert(error_message=f"{ids.Errors.INVALID_AMOUNT}")
    %}
    VariableDebtToken.burn(USER_1, Uint256(0, 0), 1)
    return ()
end

# TODO Write a testcase for on_behalf borrowing behavior (see aave-v3 codebase). Eventually, write it in a variable_debt_token_spec for integration with deployed contracts.
