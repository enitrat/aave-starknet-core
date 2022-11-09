%lang starknet

from starkware.cairo.common.bool import FALSE, TRUE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import unsigned_div_rem
from starkware.cairo.common.uint256 import Uint256
from starkware.starknet.common.syscalls import get_contract_address

from contracts.interfaces.i_sequencer_oracle import ISequencerOracle
from contracts.protocol.libraries.logic.generic_logic import GenericLogic
from contracts.protocol.libraries.math.wad_ray_math import WadRayMath
from contracts.protocol.libraries.types.data_types import DataTypes
from contracts.protocol.pool.pool_storage import PoolStorage

const USER_1 = 1;
const USER_2 = 2;
const USER_3 = 3;

const EMODE_CATEGORY_ID_1 = 1;
const EMODE_CATEGORY_ID_2 = 0;
const EMODE_CATEGORY_ID_3 = 13;

const RESERVE_ASSET_1_ADDRESS = 111;
const RESERVE_ASSET_2_ADDRESS = 112;
const RESERVE_ASSET_3_ADDRESS = 0;

const RESERVE_ID_1 = 1;
const RESERVE_ID_2 = 2;
const RESERVE_ID_3 = 2;

const ORACLE = 12345;

@view
func test_calculate_intermediate_values{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    alloc_locals;
    let (user_1_params, user_2_params, user_3_params) = set_context();
    // let (user_1_e_mode_category) = PoolStorage.e_mode_categories_read(user_1_params.user_e_mode_category)
    // let (user_2_e_mode_category) = PoolStorage.e_mode_categories_read(user_2_params.user_e_mode_category)
    %{ stop_mock_asset_price = mock_call(ids.user_1_params.oracle, "get_asset_price", [234]) %}
    let (
        user_1_e_mode_ltv, user_1_e_mode_liq_threshold, user_1_e_mode_asset_price
    ) = GenericLogic._calculate_e_mode_account_data(
        user_1_params.user_e_mode_category, user_1_params.oracle
    );
    %{ stop_mock_asset_price() %}
    assert user_1_e_mode_ltv = 75;
    assert user_1_e_mode_liq_threshold = 80;
    assert user_1_e_mode_asset_price = 234;

    let (
        user_2_e_mode_ltv, user_2_e_mode_liq_threshold, user_2_e_mode_asset_price
    ) = GenericLogic._calculate_e_mode_account_data(
        user_2_params.user_e_mode_category, user_2_params.oracle
    );
    assert user_2_e_mode_ltv = 0;
    assert user_2_e_mode_liq_threshold = 0;
    assert user_2_e_mode_asset_price = 0;

    let (
        user_3_e_mode_ltv, user_3_e_mode_liq_threshold, user_3_e_mode_asset_price
    ) = GenericLogic._calculate_e_mode_account_data(
        user_3_params.user_e_mode_category, user_3_params.oracle
    );
    assert user_3_e_mode_ltv = 80;
    assert user_3_e_mode_liq_threshold = 85;
    assert user_3_e_mode_asset_price = 0;

    return ();
}

@view
func test_rec_sum_of_user_account_data{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    alloc_locals;
    let (user_1_params, user_2_params, user_3_params) = set_context();
    %{
        stop_mock_asset_price = mock_call(ids.user_1_params.oracle, "get_asset_price", [234])
        stop_mock_balance = mock_call(ids.RESERVE_ASSET_1_ADDRESS, "scaled_balance_of", [234, 0])
        stop_mock_a_token_balance_1 = mock_call(134567, "scaled_balance_of", [200, 0])
        stop_mock_variable_balance_1 = mock_call(134569, "scaled_balance_of", [200, 0])
        stop_mock_stable_balance_1   = mock_call(134568, "balanceOf", [200, 0])
        stop_mock_a_token_balance_2 = mock_call(234567, "scaled_balance_of", [200, 0])
        stop_mock_variable_balance_2 = mock_call(234569, "scaled_balance_of", [200, 0])
        stop_mock_stable_balance_2  = mock_call(234568, "balanceOf", [200, 0])
        stop_warp = warp(2)
    %}
    let (
        sum_of_collateral, sum_of_debt, sum_of_ltv, sum_of_liq_th, has_zero_ltv
    ) = GenericLogic._calculate_sum_of_user_account_data(user_1_params, 1, 1, 1, 2);
    %{
        stop_mock_asset_price() 
        stop_mock_balance()
        stop_mock_a_token_balance_1()
        stop_mock_variable_balance_1()
        stop_mock_stable_balance_1()   
        stop_mock_a_token_balance_2()
        stop_mock_variable_balance_2()
        stop_mock_stable_balance_2()
        stop_warp()
    %}

    return ();
}

func set_context{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    user_1_params: DataTypes.CalculateUserAccountDataParams,
    user_2_params: DataTypes.CalculateUserAccountDataParams,
    user_3_params: DataTypes.CalculateUserAccountDataParams,
) {
    // Create for each reserve, an object of type ReseveData and an object of type ReserveConfiguration

    let reserve_configuration_1 = DataTypes.ReserveConfiguration(
        ltv=75,
        liquidation_threshold=80,
        liquidation_bonus=5,
        decimals=2,
        reserve_active=1,
        reserve_frozen=1,
        borrowing_enabled=1,
        stable_rate_borrowing_enabled=1,
        asset_paused=1,
        borrowable_in_isolation=0,
        siloed_borrowing=1,
        reserve_factor=1,
        borrow_cap=1,
        supply_cap=1,
        liquidation_protocol_fee=1,
        e_mode_category=1,
        unbacked_mint_cap=1,
        debt_ceiling=1,
    );
    let reserve_data_1 = DataTypes.ReserveData(
        configuration=reserve_configuration_1,
        liquidity_index=2 * WadRayMath.RAY,
        current_liquidity_rate=1 * WadRayMath.RAY,
        variable_borrow_index=1 * WadRayMath.RAY,
        current_variable_borrow_rate=1 * WadRayMath.RAY,
        current_stable_borrow_rate=1 * WadRayMath.RAY,
        last_update_timestamp=1,
        id=1,
        a_token_address=134567,
        stable_debt_token_address=134568,
        variable_debt_token_address=134569,
        interest_rate_strategy_address=134570,
        accrued_to_treasury=1,
        unbacked=1,
        isolation_mode_total_debt=18543,
    );

    // Create for each reserve, an object of type ReseveData and an object of type ReserveConfiguration

    let reserve_configuration_2 = DataTypes.ReserveConfiguration(
        ltv=80,
        liquidation_threshold=85,
        liquidation_bonus=2,
        decimals=2,
        reserve_active=1,
        reserve_frozen=1,
        borrowing_enabled=1,
        stable_rate_borrowing_enabled=1,
        asset_paused=1,
        borrowable_in_isolation=1,
        siloed_borrowing=1,
        reserve_factor=1,
        borrow_cap=1,
        supply_cap=1,
        liquidation_protocol_fee=2,
        e_mode_category=2,
        unbacked_mint_cap=2,
        debt_ceiling=2,
    );

    let reserve_data_2 = DataTypes.ReserveData(
        configuration=reserve_configuration_2,
        liquidity_index=2 * WadRayMath.RAY,
        current_liquidity_rate=2 * WadRayMath.RAY,
        variable_borrow_index=1 * WadRayMath.RAY,
        current_variable_borrow_rate=2 * WadRayMath.RAY,
        current_stable_borrow_rate=1 * WadRayMath.RAY,
        last_update_timestamp=2,
        id=2,
        a_token_address=234567,
        stable_debt_token_address=234568,
        variable_debt_token_address=234569,
        interest_rate_strategy_address=234570,
        accrued_to_treasury=2,
        unbacked=2,
        isolation_mode_total_debt=18543,
    );

    // create object of type e_mode_category for each emode_category_id
    let e_mode_category_1 = DataTypes.EModeCategory(
        ltv=75, liquidation_threshold=80, liquidation_bonus=5, price_source=112345, label='LABEL1'
    );

    let e_mode_category_2 = DataTypes.EModeCategory(
        ltv=80, liquidation_threshold=85, liquidation_bonus=2, price_source=2, label='LABEL2'
    );

    let e_mode_category_3 = DataTypes.EModeCategory(
        ltv=80, liquidation_threshold=85, liquidation_bonus=2, price_source=0, label='LABEL3'
    );

    // create oject of type UserConfigMap
    let user_config_1 = DataTypes.UserConfigurationMap(TRUE, TRUE);
    let user_config_2 = DataTypes.UserConfigurationMap(TRUE, FALSE);

    // populate storage variable
    PoolStorage.reserves_write(RESERVE_ASSET_1_ADDRESS, reserve_data_1);
    PoolStorage.reserves_write(RESERVE_ASSET_2_ADDRESS, reserve_data_2);
    PoolStorage.reserves_config_write(RESERVE_ASSET_1_ADDRESS, reserve_configuration_1);
    PoolStorage.reserves_config_write(RESERVE_ASSET_2_ADDRESS, reserve_configuration_2);
    PoolStorage.reserves_list_write(RESERVE_ID_1, RESERVE_ASSET_1_ADDRESS);
    PoolStorage.reserves_list_write(RESERVE_ID_2, RESERVE_ASSET_2_ADDRESS);
    PoolStorage.reserves_list_write(RESERVE_ID_3, RESERVE_ASSET_3_ADDRESS);

    PoolStorage.e_mode_categories_write(EMODE_CATEGORY_ID_1, e_mode_category_1);
    PoolStorage.e_mode_categories_write(EMODE_CATEGORY_ID_2, e_mode_category_2);
    PoolStorage.e_mode_categories_write(EMODE_CATEGORY_ID_3, e_mode_category_3);

    PoolStorage.users_e_mode_category_write(USER_1, EMODE_CATEGORY_ID_1);
    PoolStorage.users_e_mode_category_write(USER_2, EMODE_CATEGORY_ID_2);
    PoolStorage.users_e_mode_category_write(USER_3, EMODE_CATEGORY_ID_3);

    PoolStorage.users_config_write(USER_1, RESERVE_ID_1, user_config_1);
    PoolStorage.users_config_write(USER_2, RESERVE_ID_2, user_config_2);
    PoolStorage.users_config_write(USER_3, RESERVE_ID_3, user_config_2);

    // create CalculateUserAccountDataParams
    let user_1_params = DataTypes.CalculateUserAccountDataParams(
        user_config=user_config_1,
        reserve_count=2,
        user=USER_1,
        oracle=ORACLE,
        user_e_mode_category=EMODE_CATEGORY_ID_1,
    );
    let user_2_params = DataTypes.CalculateUserAccountDataParams(
        user_config=user_config_2,
        reserve_count=1,
        user=USER_2,
        oracle=ORACLE,
        user_e_mode_category=EMODE_CATEGORY_ID_2,
    );

    let user_3_params = DataTypes.CalculateUserAccountDataParams(
        user_config=user_config_2,
        reserve_count=1,
        user=USER_3,
        oracle=ORACLE,
        user_e_mode_category=EMODE_CATEGORY_ID_3,
    );

    return (user_1_params, user_2_params, user_3_params);
}
