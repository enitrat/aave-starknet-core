%lang starknet

from starkware.cairo.common.bool import FALSE, TRUE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_contract_address

from contracts.interfaces.i_sequencer_oracle import ISequencerOracle
from contracts.protocol.libraries.logic.e_mode_logic import EModeLogic
from contracts.protocol.libraries.types.data_types import DataTypes

const PRANK_LTV = 1;
const PRANK_LIQUIDIATION_TH = 1;
const PRANK_LIQUIDITION_BONUS = 1;
const PRANK_PRICE_SOURCE = 12356;
const PRANK_LABEL = 'LABEL';
const PRANK_ORACLE = 65421;
const PRANK_ASSET_PRICE = 12;

func set_user_e_mode{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    user_e_mode_category: DataTypes.EModeCategory
) {
    let user_e_mode_category = DataTypes.EModeCategory(
        PRANK_LTV, PRANK_LIQUIDIATION_TH, PRANK_LIQUIDITION_BONUS, PRANK_PRICE_SOURCE, PRANK_LABEL
    );
    return (user_e_mode_category,);
}

@view
func test_init_user_e_mode{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    let (user_e_mode_category) = set_user_e_mode();
    assert user_e_mode_category.ltv = PRANK_LTV;
    assert user_e_mode_category.liquidation_threshold = PRANK_LIQUIDIATION_TH;
    assert user_e_mode_category.liquidation_bonus = PRANK_LIQUIDITION_BONUS;
    assert user_e_mode_category.price_source = PRANK_PRICE_SOURCE;
    assert user_e_mode_category.label = PRANK_LABEL;
    return ();
}

@view
func test_e_mode_category{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    let (user_e_mode_category) = set_user_e_mode();
    // mock price source to be PRANK_ASSET_PRICE
    %{ stop_mock = mock_call(ids.PRANK_ORACLE, "get_asset_price", [ids.PRANK_ASSET_PRICE]) %}
    let (ltv, liquidation_threshold, asset_price) = EModeLogic.get_e_mode_configuration(
        user_e_mode_category, PRANK_ORACLE
    );
    assert ltv = PRANK_LTV;
    assert liquidation_threshold = PRANK_LIQUIDIATION_TH;
    assert asset_price = PRANK_ASSET_PRICE;
    %{ stop_mock() %}
    return ();
}

@view
func test_e_mode_category_with_zero_price_source{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    let user_e_mode_category = DataTypes.EModeCategory(
        PRANK_LTV, PRANK_LIQUIDIATION_TH, PRANK_LIQUIDITION_BONUS, 0, PRANK_LABEL
    );
    // mock price source to be PRANK_ASSET_PRICE
    let (ltv, liquidation_threshold, asset_price) = EModeLogic.get_e_mode_configuration(
        user_e_mode_category, PRANK_ORACLE
    );
    assert ltv = PRANK_LTV;
    assert liquidation_threshold = PRANK_LIQUIDIATION_TH;
    assert asset_price = 0;
    return ();
}

@view
func test_is_in_e_mode_category{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    let (same_categories) = EModeLogic.is_in_e_mode_category(1, 1);
    assert same_categories = TRUE;
    let (same_categories_but_zero) = EModeLogic.is_in_e_mode_category(0, 0);
    assert same_categories_but_zero = FALSE;
    let (different_categories) = EModeLogic.is_in_e_mode_category(1, 2);
    assert different_categories = FALSE;
    return ();
}
