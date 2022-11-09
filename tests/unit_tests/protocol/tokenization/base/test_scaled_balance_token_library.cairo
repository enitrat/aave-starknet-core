%lang starknet

from starkware.cairo.common.bool import FALSE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256, uint256_add, uint256_sub
from starkware.starknet.common.syscalls import get_contract_address

from contracts.protocol.libraries.math.felt_math import to_uint256
from contracts.protocol.libraries.math.helpers import assert_eq_uint256
from contracts.protocol.libraries.math.wad_ray_math import WadRayMath
from contracts.protocol.tokenization.base.incentivized_erc20_library import IncentivizedERC20
from contracts.protocol.tokenization.base.scaled_balance_token_library import ScaledBalanceToken

from tests.utils.constants import AMOUNT_1, AMOUNT_2, AMOUNT_3, USER_1, USER_2

// Calculated amounts over 1% of balance of 1000
// 1.01 * 1000, interest gained over initial balance
const EXPECTED_BALANCE_INCREASE = 10 * WadRayMath.WAD;
const EXPECTED_AMOUNT_TO_ANOUNCE_AS_MINTED = 110 * WadRayMath.WAD;
const MINT_EXPECTED_NEW_TOTAL_SUPPLY = 10099009900990099009901;
const MINT_EXPECTED_NEW_BALANCE = 1099009900990099009901;
const EXPECTED_BALANCE_DECREASE = 90 * WadRayMath.WAD;
const EXPECTED_AMOUNT_TO_ANOUNCE_AS_BURNED = 110 * WadRayMath.WAD;
const BURN_EXPECTED_NEW_TOTAL_SUPPLY = 9900990099009900990099;
const BURN_EXPECTED_NEW_BALANCE = 900990099009900990099;
// Calculated amounts over 20% of balance of 1000
// 1.2 * 1000, interest gained over initial balance
const EXPECTED_BALANCE_INCREASE_20 = (200) * WadRayMath.WAD;
const EXPECTED_AMOUNT_TO_ANOUNCE_AS_MINTED_20 = (200 - 100) * WadRayMath.WAD;
const BURN_EXPECTED_NEW_TOTAL_SUPPLY_20 = 9916666666666666666667;
const BURN_EXPECTED_NEW_BALANCE_20 = 916666666666666666667;

func mock_balances{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    user: felt, index: felt
) -> (total_supply: Uint256, user_balance: felt) {
    alloc_locals;
    let (local contract_address) = get_contract_address();

    let total_supply = to_uint256(AMOUNT_3 * WadRayMath.WAD);
    let user_balance = AMOUNT_2 * WadRayMath.WAD;

    // Mock total supply and balance
    %{ store(ids.contract_address, "IncentivizedERC20_total_supply", [ids.total_supply.low, ids.total_supply.high]) %}
    %{ store(ids.contract_address, "IncentivizedERC20_user_state", [ids.user_balance, ids.index], key=[ids.user]) %}

    return (total_supply, user_balance);
}

func load_new_balances{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    user: felt
) -> (new_total_supply: Uint256, new_balance: felt, new_additional_data: felt) {
    alloc_locals;
    let (local contract_address) = get_contract_address();

    tempvar new_total_supply: Uint256;
    %{ (ids.new_total_supply.low, ids.new_total_supply.high) = load(ids.contract_address, "IncentivizedERC20_total_supply", "Uint256") %}
    tempvar new_balance;
    tempvar new_additional_data;
    %{ (ids.new_balance, ids.new_additional_data) = load(ids.contract_address, "IncentivizedERC20_user_state", "UserState", key=[ids.user]) %}

    return (new_total_supply, new_balance, new_additional_data);
}

@external
func test_mint_scaled{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;
    let (local contract_address) = get_contract_address();
    let amount_1_wad = to_uint256(AMOUNT_1 * WadRayMath.WAD);
    tempvar index = 1 * WadRayMath.RAY;

    // Mock and mint
    let (local initial_total_supply, local initial_balance) = mock_balances(
        USER_2, 1 * WadRayMath.RAY
    );
    %{ expect_events({"name": "Transfer", "data": [0, ids.USER_2, ids.amount_1_wad.low, ids.amount_1_wad.high]}) %}
    %{ expect_events({"name": "Mint", "data": [ids.USER_1, ids.USER_2, ids.amount_1_wad.low, ids.amount_1_wad.high, 0, 0, ids.index]}) %}
    let (mint_result) = ScaledBalanceToken.mint_scaled(USER_1, USER_2, amount_1_wad, index);

    // Load and assert
    let (local new_total_supply, local new_balance, local new_additional_data) = load_new_balances(
        USER_2
    );

    let (expected_new_total_supply: Uint256, _) = uint256_add(initial_total_supply, amount_1_wad);
    tempvar expected_new_balance = (initial_balance + AMOUNT_1 * WadRayMath.WAD);

    assert_eq_uint256(expected_new_total_supply, new_total_supply);
    assert expected_new_balance = new_balance;
    assert mint_result = FALSE;

    return ();
}

@external
func test_mint_scaled_percent{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;
    let (local contract_address) = get_contract_address();
    let amount_1_wad = to_uint256(AMOUNT_1 * WadRayMath.WAD);
    // Augment interest by 1%
    tempvar index = 1 * WadRayMath.RAY + (1 * WadRayMath.RAY / 10 ** 2);
    let (local initial_total_supply, local initial_balance) = mock_balances(
        USER_2, 1 * WadRayMath.RAY
    );

    %{ expect_events({"name": "Transfer", "data": [0, ids.USER_2, ids.EXPECTED_AMOUNT_TO_ANOUNCE_AS_MINTED, 0]}) %}
    %{ expect_events({"name": "Mint", "data": [ids.USER_1, ids.USER_2, ids.EXPECTED_AMOUNT_TO_ANOUNCE_AS_MINTED, 0, ids.EXPECTED_BALANCE_INCREASE, 0, ids.index]}) %}
    let (mint_result) = ScaledBalanceToken.mint_scaled(USER_1, USER_2, amount_1_wad, index);

    // Load and assert
    let (local new_total_supply, local new_balance, local new_additional_data) = load_new_balances(
        USER_2
    );
    let expected_new_total_supply = to_uint256(MINT_EXPECTED_NEW_TOTAL_SUPPLY);
    assert_eq_uint256(expected_new_total_supply, new_total_supply);
    assert MINT_EXPECTED_NEW_BALANCE = new_balance;
    assert mint_result = FALSE;

    return ();
}

@external
func test_burn_scaled{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;
    let (local contract_address) = get_contract_address();

    let amount_1_wad = to_uint256(AMOUNT_1 * WadRayMath.WAD);
    local index = 1 * WadRayMath.RAY;

    let (local initial_total_supply, local initial_balance) = mock_balances(
        USER_1, 1 * WadRayMath.RAY
    );

    %{ expect_events({"name": "Transfer", "data": [ids.USER_1, 0, ids.amount_1_wad.low, ids.amount_1_wad.high]}) %}
    %{ expect_events({"name": "Burn", "data": [ids.USER_1, ids.USER_2, ids.amount_1_wad.low, ids.amount_1_wad.high, 0, 0, ids.index]}) %}
    ScaledBalanceToken.burn_scaled(USER_1, USER_2, amount_1_wad, index);

    let (local new_total_supply, local new_balance, local new_additional_data) = load_new_balances(
        USER_1
    );

    let (expected_new_total_supply: Uint256) = uint256_sub(initial_total_supply, amount_1_wad);
    tempvar expected_new_balance = (initial_balance - AMOUNT_1 * WadRayMath.WAD);

    assert_eq_uint256(expected_new_total_supply, new_total_supply);
    assert expected_new_balance = new_balance;

    return ();
}

@external
func test_burn_scaled_percent{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;
    let (local contract_address) = get_contract_address();

    let amount_1_wad = to_uint256(AMOUNT_1 * WadRayMath.WAD);
    // Augment interest by 1%
    tempvar index = 1 * WadRayMath.RAY + (1 * WadRayMath.RAY / 10 ** 2);

    let (local initial_total_supply, local initial_balance) = mock_balances(
        USER_1, 1 * WadRayMath.RAY
    );

    %{ expect_events({"name": "Transfer", "data": [ids.USER_1, 0, ids.EXPECTED_BALANCE_DECREASE, 0]}) %}
    %{ expect_events({"name": "Burn", "data": [ids.USER_1, ids.USER_2, ids.EXPECTED_BALANCE_DECREASE, 0, ids.EXPECTED_BALANCE_INCREASE, 0, ids.index]}) %}
    ScaledBalanceToken.burn_scaled(USER_1, USER_2, amount_1_wad, index);

    let (local new_total_supply, local new_balance, local new_additional_data) = load_new_balances(
        USER_1
    );

    let expected_new_total_supply = to_uint256(BURN_EXPECTED_NEW_TOTAL_SUPPLY);
    assert_eq_uint256(expected_new_total_supply, new_total_supply);
    assert BURN_EXPECTED_NEW_BALANCE = new_balance;

    return ();
}

@external
func test_burn_scaled_percent_mint{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) {
    alloc_locals;
    let (local contract_address) = get_contract_address();

    let amount_1_wad = to_uint256(AMOUNT_1 * WadRayMath.WAD);
    // Augment interest by 20%
    tempvar index = 1 * WadRayMath.RAY + (20 * WadRayMath.RAY / 10 ** 2);

    let (local initial_total_supply, local initial_balance) = mock_balances(
        USER_1, 1 * WadRayMath.RAY
    );

    %{ expect_events({"name": "Transfer", "data": [0, ids.USER_1, ids.EXPECTED_AMOUNT_TO_ANOUNCE_AS_MINTED_20, 0]}) %}
    %{ expect_events({"name": "Mint", "data": [ids.USER_1, ids.USER_1, ids.EXPECTED_AMOUNT_TO_ANOUNCE_AS_MINTED_20, 0, ids.EXPECTED_BALANCE_INCREASE_20, 0, ids.index]}) %}
    ScaledBalanceToken.burn_scaled(USER_1, USER_2, amount_1_wad, index);

    let (local new_total_supply, local new_balance, local new_additional_data) = load_new_balances(
        USER_1
    );

    let expected_new_total_supply = to_uint256(BURN_EXPECTED_NEW_TOTAL_SUPPLY_20);
    assert_eq_uint256(expected_new_total_supply, new_total_supply);
    assert BURN_EXPECTED_NEW_BALANCE_20 = new_balance;

    return ();
}
