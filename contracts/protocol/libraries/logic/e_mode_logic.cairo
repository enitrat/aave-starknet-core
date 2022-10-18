%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math_cmp import is_not_zero
from starkware.cairo.common.bool import TRUE

from contracts.protocol.libraries.helpers.helpers import is_zero
from contracts.protocol.libraries.helpers.bool_cmp import BoolCmp
from contracts.interfaces.i_price_oracle_getter import IPriceOracleGetter
from contracts.protocol.libraries.types.data_types import DataTypes

@event
func UserEModeSet(user: felt, category_id: felt) {
}

// Implements the base logic for all the actions related to the e_mode
namespace EModeLogic {
    // TODO when GenericLogic is tested and merged
    func execute_set_user_emode{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
        return ();
    }

    func get_e_mode_configuration{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        e_mode_category: DataTypes.EModeCategory, oracle: felt
    ) -> (ltv: felt, liquidation_threshold: felt, price: felt) {
        let price_source = e_mode_category.price_source;
        let is_price_source_not_zero = is_not_zero(price_source);
        if (is_price_source_not_zero == TRUE) {
            let (asset_price) = IPriceOracleGetter.get_asset_price(oracle, price_source);
            return (e_mode_category.ltv, e_mode_category.liquidation_threshold, asset_price);
        } else {
            return (e_mode_category.ltv, e_mode_category.liquidation_threshold, 0);
        }
    }

    func is_in_e_mode_category{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        e_mode_user_category: felt, e_mode_asset_category: felt
    ) -> (is_in_e_mode: felt) {
        let is_not_zero_e_mode_user_category = is_not_zero(e_mode_user_category);
        let (same_category) = is_zero(e_mode_user_category - e_mode_asset_category);
        let is_in_e_mode = BoolCmp.both(is_not_zero_e_mode_user_category, same_category);
        return (is_in_e_mode,);
    }
}
