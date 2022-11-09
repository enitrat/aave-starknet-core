%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from starkware.starknet.common.syscalls import get_contract_address

from contracts.interfaces.i_pool import IPool
from contracts.interfaces.i_stable_debt_token import IStableDebtToken
from contracts.protocol.libraries.helpers.errors import Errors

from tests.utils.constants import USER_1

const MOCK_INCENTIVES_CONTROLLER = 11235813;
const MOCK_ACL_MANAGER = 1248163264;

func get_contract_addresses() -> (pool_address: felt, token: felt, stable_debt: felt) {
    tempvar pool;
    tempvar dai;
    tempvar dai_stable_debt;
    %{ ids.pool = context.pool %}
    %{ ids.dai = context.dai %}
    %{ ids.dai_stable_debt = context.dai_stable_debt %}
    return (pool, dai, dai_stable_debt);
}

// 13 test cases
namespace TestStableDebtTokenDeployed {
    // Check initialization
    func test_initialization{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
        let (pool, dai, dai_stable_debt) = get_contract_addresses();

        // Check that the dai stable_debt_token is our dai_stable_debt
        let (reserve) = IPool.get_reserve_data(pool, dai);
        assert reserve.stable_debt_token_address = dai_stable_debt;

        // We need to prank pool to mint tokens
        %{ stop_prank_pool = start_prank(ids.pool,target_contract_address=ids.dai_stable_debt) %}
        IStableDebtToken.mint(dai_stable_debt, USER_1, USER_1, Uint256(1, 0), 1);
        %{ stop_prank_pool() %}

        // We need to have a non-admin caller to call the implementation functions
        // TODO this is an error from the proxy implementation that we should fix
        %{ stop_prank_user1 = start_prank(ids.USER_1,target_contract_address=ids.dai_stable_debt) %}
        // Verify that the reserve is correctly initialized
        let (underlying_asset) = IStableDebtToken.UNDERLYING_ASSET_ADDRESS(dai_stable_debt);
        assert underlying_asset = dai;
        let (initialized_pool) = IStableDebtToken.POOL(dai_stable_debt);
        assert initialized_pool = pool;
        let (incentives_controller) = IStableDebtToken.get_incentives_controller(dai_stable_debt);
        assert incentives_controller = 0;  // Incentives controller is out of scope for now

        let (total_supply, avg_rate) = IStableDebtToken.get_total_supply_and_avg_rate(
            dai_stable_debt
        );
        assert total_supply = Uint256(1, 0);
        assert avg_rate = 0;

        // TODO Create debt for the user by depositing to the pool and borrowing funds
        // Required the borrowing logic to be implemented
        %{ stop_prank_user1() %}
        return ();
    }

    // Tries to mint not being the Pool (revert expected)
    func test_mint_not_pool_revert{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        ) {
        let (pool, dai, dai_stable_debt) = get_contract_addresses();
        %{
            stop_prank_user1 = start_prank(ids.USER_1,target_contract_address=ids.dai_stable_debt) 
            expect_revert(error_message=f"{ids.Errors.CALLER_MUST_BE_POOL}")
        %}
        IStableDebtToken.mint(dai_stable_debt, USER_1, USER_1, Uint256(1, 0), 1);
        %{ stop_prank_user1() %}
        return ();
    }

    // Tries to burn not being the Pool (revert expected)
    func test_burn_not_pool_revert{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        ) {
        let (pool, dai, dai_stable_debt) = get_contract_addresses();
        %{
            stop_prank_user1 = start_prank(ids.USER_1,target_contract_address=ids.dai_stable_debt) 
            expect_revert(error_message=f"{ids.Errors.CALLER_MUST_BE_POOL}")
        %}
        IStableDebtToken.burn(dai_stable_debt, USER_1, Uint256(1, 0));
        %{ stop_prank_user1() %}

        return ();
    }

    // Check Mint and Transfer events when borrowing on behalf
    func test_mint_transfer_events_on_behalf{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }() {
        // TODO once borrow/supply mechanism are implemented
        return ();
    }

    // Burn stable debt tokens such that `secondTerm >= firstTerm
    func test_burn_debt_term2_ge_term1{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }() {
        let (pool, dai, dai_stable_debt) = get_contract_addresses();
        %{
            stop_prank_pool = start_prank(ids.pool, target_contract_address=ids.dai_stable_debt)
            # Our goal is to have secondTerm (userStableRate * burnAmount) >= averageRate * supply
            # We prank the storage values, with a higher userStableRate than averageRate. This way, when calculating supply,
            # we have firstTerm = 55e9, secondTerm = 100e9
            # USER_1 has 10 tokens and a rate of 10 ray
            store(ids.dai_stable_debt, "IncentivizedERC20_user_state", [10,10*10**27],key=[ids.USER_1])
            # Average stable rate is 5 ray
            store(ids.dai_stable_debt, "StableDebtToken_avg_stable_rate", [5*10**27])
            # total supply is 11 tokens
            store(ids.dai_stable_debt, "IncentivizedERC20_total_supply", [11,0])
        %}
        IStableDebtToken.burn(dai_stable_debt, USER_1, Uint256(10, 0));
        let (total_supply, avg_rate) = IStableDebtToken.get_total_supply_and_avg_rate(
            dai_stable_debt
        );

        // Since secondTerm>=firstTerm, the average rate and total supply are reset to 0
        assert total_supply = Uint256(0, 0);
        assert avg_rate = 0;
        %{ stop_prank_pool() %}
        return ();
    }

    func test_set_incentives_controller{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }() {
        let (pool, dai, dai_stable_debt) = get_contract_addresses();
        %{ stop_prank_user1 = start_prank(ids.USER_1, target_contract_address=ids.dai_stable_debt) %}
        let (incentives_controller) = IStableDebtToken.get_incentives_controller(dai_stable_debt);
        assert incentives_controller = 0;
        %{
            stop_mock_is_pool_admin_1 = mock_call(context.pool_addresses_provider, "get_ACL_manager", [ids.MOCK_ACL_MANAGER])
            stop_mock_is_pool_admin_2 = mock_call(ids.MOCK_ACL_MANAGER, "is_pool_admin", [1])
        %}
        IStableDebtToken.set_incentives_controller(dai_stable_debt, MOCK_INCENTIVES_CONTROLLER);
        let (incentives_controller) = IStableDebtToken.get_incentives_controller(dai_stable_debt);
        assert incentives_controller = MOCK_INCENTIVES_CONTROLLER;
        %{
            stop_prank_user1()
            stop_mock_is_pool_admin_1()
            stop_mock_is_pool_admin_2()
        %}
        return ();
    }

    func test_set_incentives_controller_not_pool_admin_revert{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }() {
        let (pool, dai, dai_stable_debt) = get_contract_addresses();
        %{
            stop_prank_user1 = start_prank(ids.USER_1, target_contract_address=ids.dai_stable_debt)
            stop_mock_is_pool_admin_1 = mock_call(context.pool_addresses_provider, "get_ACL_manager", [ids.MOCK_ACL_MANAGER])
            stop_mock_is_pool_admin_2 = mock_call(ids.MOCK_ACL_MANAGER, "is_pool_admin", [0])
            expect_revert(error_message=f"{ids.Errors.CALLER_NOT_POOL_ADMIN}")
        %}
        IStableDebtToken.set_incentives_controller(dai_stable_debt, MOCK_INCENTIVES_CONTROLLER);
        %{
            stop_prank_user1()
            stop_mock_is_pool_admin_1()
            stop_mock_is_pool_admin_2()
        %}
        return ();
    }
}
