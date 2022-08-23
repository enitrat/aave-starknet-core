%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from starkware.starknet.common.syscalls import get_contract_address

from contracts.interfaces.i_pool import IPool
from contracts.protocol.libraries.helpers.constants import UINT128_MAX
from contracts.protocol.libraries.math.wad_ray_math import WadRayMath

from tests.interfaces.IERC20_Mintable import IERC20_Mintable
from tests.utils.utils import array_includes, parse_ether
from tests.utils.constants import UNDEPLOYED_RESERVE, USER_1

# TODO test should integrate pool_configurator when implemented

namespace TestPoolDropDeployed:
    # User 1 deposits DAI, User 2 borrow DAI stable and variable, should fail to drop DAI reserve
    func test_user_1_deposits_DAI_user_2_borrow_DAI_stable_and_variable_should_fail_to_drop_DAI_reserve{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }():
        alloc_locals
        local dai
        local weth
        local pool
        %{
            ids.dai = context.dai
            ids.weth = context.weth
            ids.pool = context.pool
        %}

        deposit_funds_and_borrow(dai, weth, pool)
        %{ expect_revert(error_message="AToken supply is not zero") %}
        IPool.drop_reserve(pool, dai)

        # TODO Tests should implement drop_reserves while borrowing verification once implemented

        return ()
    end

    # TODO once borrowing/lending is implemented
    # User 2 repays debts, drop DAI reserve should fail
    func test_user_2_repays_debts_drop_DAI_reserve_should_fail{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }():
        return ()
    end

    # User 1 withdraw DAI, drop DAI reserve should succeed
    func test_user_1_withdraw_DAI_drop_DAI_reserve_should_succeed{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }():
        alloc_locals
        local dai
        local aDAI
        local weth
        local pool
        local deployer
        local dai_variable_debt
        %{
            ids.dai = context.dai
            ids.aDAI = context.aDAI
            ids.weth = context.weth
            ids.pool = context.pool
            ids.deployer = context.deployer
            ids.dai_variable_debt = context.dai_variable_debt
        %}

        deposit_funds_and_borrow(dai, weth, pool)

        %{ stop_mock = mock_call(ids.pool, "get_reserve_normalized_income", [ids.WadRayMath.RAY, 0]) %}
        IPool.withdraw(pool, dai, Uint256(UINT128_MAX, UINT128_MAX), deployer)
        %{ stop_mock() %}
        let (reserves_count, reserves_list) = IPool.get_reserves_list(pool)
        %{
            stop_mock = mock_call(ids.aDAI, "totalSupply", [0,0])
            stop_mock_debt = mock_call(ids.dai_variable_debt, "total_supply", [0,0])
        %}
        IPool.drop_reserve(pool, dai)
        %{
            stop_mock()
            stop_mock_debt()
        %}
        let (new_count, new_reserves) = IPool.get_reserves_list(pool)
        assert new_count = reserves_count - 1
        let (is_dai_in_array) = array_includes(new_count, new_reserves, dai)
        assert is_dai_in_array = 0
        # TODO complete test once reserve pause/active/freezing is implemented

        return ()
    end

    # 'Drop an asset that is not a listed reserve should fail'
    func test_drop_an_asset_that_is_not_a_listed_reserve_should_fail{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }():
        alloc_locals
        local dai
        local weth
        local pool
        %{
            ids.dai = context.dai
            ids.weth = context.weth
            ids.pool = context.pool
        %}
        %{ expect_revert(error_message="Asset is not listed") %}
        IPool.drop_reserve(pool, UNDEPLOYED_RESERVE)

        return ()
    end

    # 'Dropping zero address should fail'
    func test_dropping_zero_address_should_fail{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }():
        alloc_locals
        local dai
        local weth
        local pool
        %{
            ids.dai = context.dai
            ids.weth = context.weth
            ids.pool = context.pool
        %}
        %{ expect_revert(error_message="Zero address not valid") %}
        IPool.drop_reserve(pool, 0)

        return ()
    end
end

# @notice mints & approves pool spending for DAI/WETH, supplies DAI to the pool
# @param dai DAI token address
# @param weth WETH token address
# @param pool pool address
func deposit_funds_and_borrow{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    dai : felt, weth : felt, pool : felt
):
    alloc_locals
    local deployer
    %{ ids.deployer = context.deployer %}

    let (local deposited_amount : Uint256) = parse_ether(1000)
    let (local borrowed_amount : Uint256) = parse_ether(100)

    IERC20_Mintable.mint(dai, deployer, deposited_amount)
    IERC20_Mintable.approve(dai, pool, deposited_amount)

    IERC20_Mintable.mint(dai, USER_1, deposited_amount)
    %{ stop_prank_dai = start_prank(ids.USER_1, target_contract_address=ids.dai) %}
    IERC20_Mintable.approve(dai, pool, deposited_amount)
    %{ stop_prank_dai() %}

    IERC20_Mintable.mint(weth, USER_1, deposited_amount)
    %{ stop_prank_weth = start_prank(ids.USER_1, target_contract_address=ids.weth) %}
    IERC20_Mintable.approve(weth, pool, deposited_amount)
    %{ stop_prank_weth() %}

    IPool.supply(pool, dai, deposited_amount, deployer, 0)

    return ()
end
