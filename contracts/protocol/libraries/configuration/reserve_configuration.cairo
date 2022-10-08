%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.math import assert_le_felt

from contracts.protocol.libraries.helpers.bool_cmp import BoolCmp
from contracts.protocol.pool.pool_storage import PoolStorage
from contracts.protocol.libraries.helpers.helpers import update_struct
from contracts.protocol.libraries.types.data_types import DataTypes
from contracts.protocol.libraries.helpers.errors import Errors

const MAX_VALID_LTV = 65535;
const MAX_VALID_LIQUIDATION_THRESHOLD = 65535;
const MAX_VALID_LIQUIDATION_BONUS = 65535;
const MAX_VALID_DECIMALS = 255;
const MAX_VALID_RESERVE_FACTOR = 65535;
const MAX_VALID_BORROW_CAP = 68719476735;
const MAX_VALID_SUPPLY_CAP = 68719476735;
const MAX_VALID_LIQUIDATION_PROTOCOL_FEE = 65535;
const MAX_VALID_EMODE_CATEGORY = 255;
const MAX_VALID_UNBACKED_MINT_CAP = 68719476735;
const MAX_VALID_DEBT_CEILING = 1099511627775;

namespace ReserveConfiguration {
    const DEBT_CEILING_DECIMALS = 2;
    const MAX_RESERVES_COUNT = 128;

    // @notice Sets the Loan to Value of the reserve
    // @param reserve_asset underlying asset of the reserve
    // @param value The new ltv
    func set_ltv{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        reserve_asset: felt, value: felt
    ) {
        alloc_locals;
        let error_code = Errors.INVALID_LTV;
        with_attr error_message("{error_code}") {
            assert_le_felt(value, MAX_VALID_LTV);
        }

        let (__fp__, _) = get_fp_and_pc();

        let (local current_reserves_config) = PoolStorage.reserves_config_read(reserve_asset);

        let (local updated_reserves_config: DataTypes.ReserveConfiguration*) = update_struct(
            &current_reserves_config,
            DataTypes.ReserveConfiguration.SIZE,
            &value,
            DataTypes.ReserveConfiguration.ltv,
        );

        PoolStorage.reserves_config_write(reserve_asset, [updated_reserves_config]);

        return ();
    }

    // @notice Gets the Loan to Value of the reserve
    // @return The loan to value
    func get_ltv{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        reserve_asset: felt
    ) -> (value: felt) {
        let (current_reserves_config) = PoolStorage.reserves_config_read(reserve_asset);

        let res = current_reserves_config.ltv;

        return (res,);
    }

    // @notice Sets the liquidation threshold of the reserve
    // @param value The new liquidation threshold
    func set_liquidation_threshold{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        reserve_asset: felt, value: felt
    ) {
        alloc_locals;

        let error_code = Errors.INVALID_LIQ_THRESHOLD;
        with_attr error_message("{error_code}") {
            assert_le_felt(value, MAX_VALID_LIQUIDATION_THRESHOLD);
        }

        let (__fp__, _) = get_fp_and_pc();

        let (local current_reserves_config) = PoolStorage.reserves_config_read(reserve_asset);

        let (local updated_reserves_config: DataTypes.ReserveConfiguration*) = update_struct(
            &current_reserves_config,
            DataTypes.ReserveConfiguration.SIZE,
            &value,
            DataTypes.ReserveConfiguration.liquidation_threshold,
        );

        PoolStorage.reserves_config_write(reserve_asset, [updated_reserves_config]);

        return ();
    }

    // @notice Gets the liquidation threshold of the reserve
    // @return The liquidation threshold
    func get_liquidation_threshold{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        reserve_asset: felt
    ) -> (value: felt) {
        let (current_reserves_config) = PoolStorage.reserves_config_read(reserve_asset);

        let res = current_reserves_config.liquidation_threshold;

        return (res,);
    }

    // @notice Sets the liquidation bonus of the reserve
    // @param value The new liquidation bonus
    func set_liquidation_bonus{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        reserve_asset: felt, value: felt
    ) {
        alloc_locals;

        let error_code = Errors.INVALID_LIQ_BONUS;
        with_attr error_message("{error_code}") {
            assert_le_felt(value, MAX_VALID_LIQUIDATION_BONUS);
        }

        let (__fp__, _) = get_fp_and_pc();

        let (local current_reserves_config) = PoolStorage.reserves_config_read(reserve_asset);

        let (local updated_reserves_config: DataTypes.ReserveConfiguration*) = update_struct(
            &current_reserves_config,
            DataTypes.ReserveConfiguration.SIZE,
            &value,
            DataTypes.ReserveConfiguration.liquidation_bonus,
        );

        PoolStorage.reserves_config_write(reserve_asset, [updated_reserves_config]);

        return ();
    }

    // @notice Gets the liquidation bonus of the reserve
    // @return The liquidation bonus
    func get_liquidation_bonus{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        reserve_asset: felt
    ) -> (value: felt) {
        let (current_reserves_config) = PoolStorage.reserves_config_read(reserve_asset);

        let res = current_reserves_config.liquidation_bonus;

        return (res,);
    }

    // @notice Sets the decimals of the underlying asset of the reserve
    // @param value The decimals
    func set_decimals{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        reserve_asset: felt, value: felt
    ) {
        alloc_locals;

        let error_code = Errors.INVALID_DECIMALS;
        with_attr error_message("{error_code}") {
            assert_le_felt(value, MAX_VALID_DECIMALS);
        }

        let (__fp__, _) = get_fp_and_pc();

        let (local current_reserves_config) = PoolStorage.reserves_config_read(reserve_asset);

        let (local updated_reserves_config: DataTypes.ReserveConfiguration*) = update_struct(
            &current_reserves_config,
            DataTypes.ReserveConfiguration.SIZE,
            &value,
            DataTypes.ReserveConfiguration.decimals,
        );

        PoolStorage.reserves_config_write(reserve_asset, [updated_reserves_config]);

        return ();
    }

    // @notice Gets the decimals of the underlying asset of the reserve
    // @return The decimals of the asset
    func get_decimals{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        reserve_asset: felt
    ) -> (value: felt) {
        // let (res) = ReserveConfiguration_decimals.read(reserve_asset)

        let (current_reserves_config) = PoolStorage.reserves_config_read(reserve_asset);

        let res = current_reserves_config.decimals;

        return (res,);
    }

    // @notice Sets the active state of the reserve
    // @param active The active state
    func set_active{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        reserve_asset: felt, active: felt
    ) {
        alloc_locals;

        BoolCmp.is_valid(active);

        let (__fp__, _) = get_fp_and_pc();

        let (local current_reserves_config) = PoolStorage.reserves_config_read(reserve_asset);

        let (local updated_reserves_config: DataTypes.ReserveConfiguration*) = update_struct(
            &current_reserves_config,
            DataTypes.ReserveConfiguration.SIZE,
            &active,
            DataTypes.ReserveConfiguration.reserve_active,
        );

        PoolStorage.reserves_config_write(reserve_asset, [updated_reserves_config]);

        return ();
    }

    // @notice Gets the active state of the reserve
    // @return The active state
    func get_active{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        reserve_asset: felt
    ) -> (value: felt) {
        // let (res) = ReserveConfiguration_reserve_active.read(reserve_asset)

        let (current_reserves_config) = PoolStorage.reserves_config_read(reserve_asset);

        let res = current_reserves_config.reserve_active;

        return (res,);
    }

    // @notice Sets the frozen state of the reserve
    // @param frozen The frozen state
    func set_frozen{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        reserve_asset: felt, frozen: felt
    ) {
        alloc_locals;

        BoolCmp.is_valid(frozen);

        let (__fp__, _) = get_fp_and_pc();

        let (local current_reserves_config) = PoolStorage.reserves_config_read(reserve_asset);

        let (local updated_reserves_config: DataTypes.ReserveConfiguration*) = update_struct(
            &current_reserves_config,
            DataTypes.ReserveConfiguration.SIZE,
            &frozen,
            DataTypes.ReserveConfiguration.reserve_frozen,
        );

        PoolStorage.reserves_config_write(reserve_asset, [updated_reserves_config]);

        return ();
    }

    // @notice Gets the frozen state of the reserve
    // @return The frozen state
    func get_frozen{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        reserve_asset: felt
    ) -> (value: felt) {
        let (current_reserves_config) = PoolStorage.reserves_config_read(reserve_asset);

        let res = current_reserves_config.reserve_frozen;

        return (res,);
    }

    // @notice Sets the paused state of the reserve
    // @param value The paused state
    func set_paused{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        reserve_asset: felt, paused: felt
    ) {
        alloc_locals;

        BoolCmp.is_valid(paused);

        let (__fp__, _) = get_fp_and_pc();

        let (local current_reserves_config) = PoolStorage.reserves_config_read(reserve_asset);

        let (local updated_reserves_config: DataTypes.ReserveConfiguration*) = update_struct(
            &current_reserves_config,
            DataTypes.ReserveConfiguration.SIZE,
            &paused,
            DataTypes.ReserveConfiguration.asset_paused,
        );

        PoolStorage.reserves_config_write(reserve_asset, [updated_reserves_config]);

        return ();
    }

    // @notice Gets the paused state of the reserve
    // @return The paused state
    func get_paused{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        reserve_asset: felt
    ) -> (value: felt) {
        let (current_reserves_config) = PoolStorage.reserves_config_read(reserve_asset);

        let res = current_reserves_config.asset_paused;

        return (res,);
    }

    // @notice Sets the borrowable in isolation flag for the reserve
    // @dev When this flag is set to true, the asset will be borrowable against isolated collaterals and the borrowed
    // amount will be accumulated in the isolated collateral's total debt exposure.
    // @dev Only assets of the same family (eg USD stablecoins) should be borrowable in isolation mode to keep
    // consistency in the debt ceiling calculations.
    // @param borrowable True if the asset is borrowable
    func set_borrowable_in_isolation{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }(reserve_asset: felt, borrowable: felt) {
        alloc_locals;

        BoolCmp.is_valid(borrowable);

        let (__fp__, _) = get_fp_and_pc();

        let (local current_reserves_config) = PoolStorage.reserves_config_read(reserve_asset);

        let (local updated_reserves_config: DataTypes.ReserveConfiguration*) = update_struct(
            &current_reserves_config,
            DataTypes.ReserveConfiguration.SIZE,
            &borrowable,
            DataTypes.ReserveConfiguration.borrowable_in_isolation,
        );

        PoolStorage.reserves_config_write(reserve_asset, [updated_reserves_config]);

        return ();
    }

    // @notice Gets the borrowable in isolation flag for the reserve.
    // @dev If the returned flag is true, the asset is borrowable against isolated collateral. Assets borrowed with
    // isolated collateral is accounted for in the isolated collateral's total debt exposure.
    // @dev Only assets of the same family (eg USD stablecoins) should be borrowable in isolation mode to keep
    // consistency in the debt ceiling calculations.
    // @return The borrowable in isolation flag
    func get_borrowable_in_isolation{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }(reserve_asset: felt) -> (value: felt) {
        let (current_reserves_config) = PoolStorage.reserves_config_read(reserve_asset);

        let res = current_reserves_config.borrowable_in_isolation;

        return (res,);
    }

    // @notice Sets the siloed borrowing flag for the reserve.
    // @dev When this flag is set to true, users borrowing this asset will not be allowed to borrow any other asset.
    // @param siloed True if the asset is siloed
    func set_siloed_borrowing{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        reserve_asset: felt, siloed: felt
    ) {
        alloc_locals;

        BoolCmp.is_valid(siloed);

        let (__fp__, _) = get_fp_and_pc();

        let (local current_reserves_config) = PoolStorage.reserves_config_read(reserve_asset);

        let (local updated_reserves_config: DataTypes.ReserveConfiguration*) = update_struct(
            &current_reserves_config,
            DataTypes.ReserveConfiguration.SIZE,
            &siloed,
            DataTypes.ReserveConfiguration.siloed_borrowing,
        );

        PoolStorage.reserves_config_write(reserve_asset, [updated_reserves_config]);

        return ();
    }

    // @notice Gets the siloed borrowing flag for the reserve.
    // @dev When this flag is set to true, users borrowing this asset will not be allowed to borrow any other asset.
    // @return The siloed borrowing flag
    func get_siloed_borrowing{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        reserve_asset: felt
    ) -> (value: felt) {
        let (current_reserves_config) = PoolStorage.reserves_config_read(reserve_asset);

        let res = current_reserves_config.siloed_borrowing;

        return (res,);
    }

    // @notice Enables or disables borrowing on the reserve
    // @param enabled True if the borrowing needs to be enabled, false otherwise
    func set_borrowing_enabled{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        reserve_asset: felt, enabled: felt
    ) {
        alloc_locals;

        BoolCmp.is_valid(enabled);

        let (__fp__, _) = get_fp_and_pc();

        let (local current_reserves_config) = PoolStorage.reserves_config_read(reserve_asset);

        let (local updated_reserves_config: DataTypes.ReserveConfiguration*) = update_struct(
            &current_reserves_config,
            DataTypes.ReserveConfiguration.SIZE,
            &enabled,
            DataTypes.ReserveConfiguration.borrowing_enabled,
        );

        PoolStorage.reserves_config_write(reserve_asset, [updated_reserves_config]);

        return ();
    }

    // @notice Gets the borrowing state of the reserve
    // @return The borrowing state
    func get_borrowing_enabled{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        reserve_asset: felt
    ) -> (value: felt) {
        let (current_reserves_config) = PoolStorage.reserves_config_read(reserve_asset);

        let res = current_reserves_config.borrowing_enabled;

        return (res,);
    }

    // @notice Enables or disables stable rate borrowing on the reserve
    // @param enabled True if the stable rate borrowing needs to be enabled, false otherwise
    func set_stable_rate_borrowing_enabled{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }(reserve_asset: felt, enabled: felt) {
        alloc_locals;

        BoolCmp.is_valid(enabled);

        let (__fp__, _) = get_fp_and_pc();

        let (local current_reserves_config) = PoolStorage.reserves_config_read(reserve_asset);

        let (local updated_reserves_config: DataTypes.ReserveConfiguration*) = update_struct(
            &current_reserves_config,
            DataTypes.ReserveConfiguration.SIZE,
            &enabled,
            DataTypes.ReserveConfiguration.stable_rate_borrowing_enabled,
        );

        PoolStorage.reserves_config_write(reserve_asset, [updated_reserves_config]);

        return ();
    }

    // @notice Gets the stable rate borrowing state of the reserve
    // @return The stable rate borrowing state
    func get_stable_rate_borrowing_enabled{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }(reserve_asset: felt) -> (value: felt) {
        let (current_reserves_config) = PoolStorage.reserves_config_read(reserve_asset);

        let res = current_reserves_config.stable_rate_borrowing_enabled;

        return (res,);
    }

    // @notice Sets the reserve factor of the reserve
    // @param reserveFactor The reserve factor
    func set_reserve_factor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        reserve_asset: felt, value: felt
    ) {
        alloc_locals;

        let error_code = Errors.INVALID_RESERVE_FACTOR;
        with_attr error_message("{error_code}") {
            assert_le_felt(value, MAX_VALID_RESERVE_FACTOR);
        }

        let (__fp__, _) = get_fp_and_pc();

        let (local current_reserves_config) = PoolStorage.reserves_config_read(reserve_asset);

        let (local updated_reserves_config: DataTypes.ReserveConfiguration*) = update_struct(
            &current_reserves_config,
            DataTypes.ReserveConfiguration.SIZE,
            &value,
            DataTypes.ReserveConfiguration.reserve_factor,
        );

        PoolStorage.reserves_config_write(reserve_asset, [updated_reserves_config]);

        return ();
    }

    // @notice Gets the reserve factor of the reserve
    // @return The reserve factor
    func get_reserve_factor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        reserve_asset: felt
    ) -> (value: felt) {
        let (current_reserves_config) = PoolStorage.reserves_config_read(reserve_asset);

        let res = current_reserves_config.reserve_factor;

        return (res,);
    }

    // @notice Sets the borrow cap of the reserve
    // @param borrowCap The borrow cap

    func set_borrow_cap{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        reserve_asset: felt, value: felt
    ) {
        alloc_locals;

        let error_code = Errors.INVALID_BORROW_CAP;
        with_attr error_message("{error_code}") {
            assert_le_felt(value, MAX_VALID_BORROW_CAP);
        }

        let (__fp__, _) = get_fp_and_pc();

        let (local current_reserves_config) = PoolStorage.reserves_config_read(reserve_asset);

        let (local updated_reserves_config: DataTypes.ReserveConfiguration*) = update_struct(
            &current_reserves_config,
            DataTypes.ReserveConfiguration.SIZE,
            &value,
            DataTypes.ReserveConfiguration.borrow_cap,
        );

        PoolStorage.reserves_config_write(reserve_asset, [updated_reserves_config]);

        return ();
    }

    // @notice Gets the borrow cap of the reserve
    // @return The borrow cap

    func get_borrow_cap{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        reserve_asset: felt
    ) -> (value: felt) {
        let (current_reserves_config) = PoolStorage.reserves_config_read(reserve_asset);

        let res = current_reserves_config.borrow_cap;

        return (res,);
    }

    // @notice Sets the supply cap of the reserve
    // @param supplyCap The supply cap

    func set_supply_cap{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        reserve_asset: felt, value: felt
    ) {
        alloc_locals;

        let error_code = Errors.INVALID_SUPPLY_CAP;
        with_attr error_message("{error_code}") {
            assert_le_felt(value, MAX_VALID_SUPPLY_CAP);
        }

        let (__fp__, _) = get_fp_and_pc();

        let (local current_reserves_config) = PoolStorage.reserves_config_read(reserve_asset);

        let (local updated_reserves_config: DataTypes.ReserveConfiguration*) = update_struct(
            &current_reserves_config,
            DataTypes.ReserveConfiguration.SIZE,
            &value,
            DataTypes.ReserveConfiguration.supply_cap,
        );

        PoolStorage.reserves_config_write(reserve_asset, [updated_reserves_config]);

        return ();
    }

    // @notice Gets the supply cap of the reserve
    // @return The supply cap

    func get_supply_cap{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        reserve_asset: felt
    ) -> (value: felt) {
        let (current_reserves_config) = PoolStorage.reserves_config_read(reserve_asset);

        let res = current_reserves_config.supply_cap;

        return (res,);
    }

    // @notice Sets the debt ceiling in isolation mode for the asset
    // @param ceiling The maximum debt ceiling for the asset
    func set_debt_ceiling{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        reserve_asset: felt, ceiling: felt
    ) {
        alloc_locals;

        let error_code = Errors.INVALID_DEBT_CEILING;
        with_attr error_message("{error_code}") {
            assert_le_felt(ceiling, MAX_VALID_DEBT_CEILING);
        }

        let (__fp__, _) = get_fp_and_pc();

        let (local current_reserves_config) = PoolStorage.reserves_config_read(reserve_asset);

        let (local updated_reserves_config: DataTypes.ReserveConfiguration*) = update_struct(
            &current_reserves_config,
            DataTypes.ReserveConfiguration.SIZE,
            &ceiling,
            DataTypes.ReserveConfiguration.debt_ceiling,
        );

        PoolStorage.reserves_config_write(reserve_asset, [updated_reserves_config]);

        return ();
    }

    // @notice Gets the debt ceiling for the asset if the asset is in isolation mode
    // @return The debt ceiling (0 = isolation mode disabled)
    func get_debt_ceiling{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        reserve_asset: felt
    ) -> (value: felt) {
        let (current_reserves_config) = PoolStorage.reserves_config_read(reserve_asset);

        let res = current_reserves_config.debt_ceiling;

        return (res,);
    }

    // @notice Sets the liquidation protocol fee of the reserve
    // @param value The liquidation protocol fee
    func set_liquidation_protocol_fee{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }(reserve_asset: felt, value: felt) {
        alloc_locals;

        let error_code = Errors.INVALID_LIQUIDATION_PROTOCOL_FEE;
        with_attr error_message("{error_code}") {
            assert_le_felt(value, MAX_VALID_LIQUIDATION_PROTOCOL_FEE);
        }

        let (__fp__, _) = get_fp_and_pc();

        let (local current_reserves_config) = PoolStorage.reserves_config_read(reserve_asset);

        let (local updated_reserves_config: DataTypes.ReserveConfiguration*) = update_struct(
            &current_reserves_config,
            DataTypes.ReserveConfiguration.SIZE,
            &value,
            DataTypes.ReserveConfiguration.liquidation_protocol_fee,
        );

        PoolStorage.reserves_config_write(reserve_asset, [updated_reserves_config]);

        return ();
    }

    // @dev Gets the liquidation protocol fee
    // @return The liquidation protocol fee
    func get_liquidation_protocol_fee{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }(reserve_asset: felt) -> (value: felt) {
        let (current_reserves_config) = PoolStorage.reserves_config_read(reserve_asset);

        let res = current_reserves_config.liquidation_protocol_fee;

        return (res,);
    }

    // @notice Sets the unbacked mint cap of the reserve
    // @param value The unbacked mint cap
    func set_unbacked_mint_cap{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        reserve_asset: felt, value: felt
    ) {
        alloc_locals;

        let error_code = Errors.INVALID_UNBACKED_MINT_CAP;
        with_attr error_message("{error_code}") {
            assert_le_felt(value, MAX_VALID_UNBACKED_MINT_CAP);
        }

        let (__fp__, _) = get_fp_and_pc();

        let (local current_reserves_config) = PoolStorage.reserves_config_read(reserve_asset);

        let (local updated_reserves_config: DataTypes.ReserveConfiguration*) = update_struct(
            &current_reserves_config,
            DataTypes.ReserveConfiguration.SIZE,
            &value,
            DataTypes.ReserveConfiguration.unbacked_mint_cap,
        );

        PoolStorage.reserves_config_write(reserve_asset, [updated_reserves_config]);

        return ();
    }

    // @dev Gets the unbacked mint cap of the reserve
    // @return The unbacked mint cap
    func get_unbacked_mint_cap{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        reserve_asset: felt
    ) -> (value: felt) {
        let (current_reserves_config) = PoolStorage.reserves_config_read(reserve_asset);

        let res = current_reserves_config.unbacked_mint_cap;

        return (res,);
    }

    // @notice Sets the e_mode asset category
    // @param category The asset category when the user selects the e_mode
    func set_e_mode_category{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        reserve_asset: felt, category: felt
    ) {
        alloc_locals;

        let error_code = Errors.INVALID_EMODE_CATEGORY_ASSIGNMENT;
        with_attr error_message("{error_code}") {
            assert_le_felt(category, MAX_VALID_EMODE_CATEGORY);
        }

        let (__fp__, _) = get_fp_and_pc();

        let (local current_reserves_config) = PoolStorage.reserves_config_read(reserve_asset);

        let (local updated_reserves_config: DataTypes.ReserveConfiguration*) = update_struct(
            &current_reserves_config,
            DataTypes.ReserveConfiguration.SIZE,
            &category,
            DataTypes.ReserveConfiguration.e_mode_category,
        );

        PoolStorage.reserves_config_write(reserve_asset, [updated_reserves_config]);

        return ();
    }

    // @dev Gets the e_mode asset category
    // @return The e_mode category for the asset
    func get_e_mode_category{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        reserve_asset: felt
    ) -> (value: felt) {
        let (current_reserves_config) = PoolStorage.reserves_config_read(reserve_asset);

        let res = current_reserves_config.e_mode_category;

        return (res,);
    }
    // @notice Gets the configuration flags of the reserve
    // @return The state flag representing active
    // @return The state flag representing frozen
    // @return The state flag representing borrowing enabled
    // @return The state flag representing stableRateBorrowing enabled
    // @return The state flag representing paused
    func get_flags{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        reserve_asset: felt
    ) -> (
        is_active: felt,
        is_frozen: felt,
        is_borrowing_enabled: felt,
        is_stable_rate_borrowing_enabled: felt,
        is_paused: felt,
    ) {
        let (reserves_config) = PoolStorage.reserves_config_read(reserve_asset);

        let is_active = reserves_config.reserve_active;
        let is_frozen = reserves_config.reserve_frozen;
        let is_borrowing_enabled = reserves_config.borrowing_enabled;
        let is_stable_rate_borrowing_enabled = reserves_config.stable_rate_borrowing_enabled;
        let is_paused = reserves_config.asset_paused;

        return (
            is_active, is_frozen, is_borrowing_enabled, is_stable_rate_borrowing_enabled, is_paused
        );
    }
    // @notice Gets the configuration parameters of the reserve from storage
    // @return The state param representing ltv
    // @return The state param representing liquidation threshold
    // @return The state param representing liquidation bonus
    // @return The state param representing reserve decimals
    // @return The state param representing reserve factor
    // @return The state param representing e_mode category
    func get_params{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        reserve_asset: felt
    ) -> (
        ltv_value: felt,
        liquidation_threshold_value: felt,
        liquidation_bonus_value: felt,
        decimals_value: felt,
        reserve_factor_value: felt,
        e_mode_category_value: felt,
    ) {
        let (reserves_config) = PoolStorage.reserves_config_read(reserve_asset);

        let ltv_value = reserves_config.ltv;
        let liquidation_threshold_value = reserves_config.liquidation_threshold;
        let liquidation_bonus_value = reserves_config.liquidation_bonus;
        let decimals_value = reserves_config.decimals;
        let reserve_factor_value = reserves_config.reserve_factor;
        let e_mode_category_value = reserves_config.e_mode_category;

        return (
            ltv_value,
            liquidation_threshold_value,
            liquidation_bonus_value,
            decimals_value,
            reserve_factor_value,
            e_mode_category_value,
        );
    }
    // @notice Gets the caps parameters of the reserve from storage
    // @return The state param representing borrow cap
    // @return The state param representing supply cap.
    func get_caps{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        reserve_asset: felt
    ) -> (borrow_cap: felt, supply_cap: felt) {
        let (reserves_config) = PoolStorage.reserves_config_read(reserve_asset);

        let borrow_cap_value = reserves_config.borrow_cap;
        let supply_cap_value = reserves_config.supply_cap;

        return (borrow_cap_value, supply_cap_value);
    }
}
