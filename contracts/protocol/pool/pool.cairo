%lang starknet

from starkware.cairo.common.bool import TRUE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_not_zero
from starkware.cairo.common.math_cmp import is_not_zero
from starkware.cairo.common.uint256 import Uint256
from starkware.starknet.common.syscalls import get_caller_address

from contracts.interfaces.i_acl_manager import IACLManager
from contracts.interfaces.i_pool_addresses_provider import IPoolAddressesProvider
from contracts.protocol.libraries.aave_upgradeability.versioned_initializable_library import (
    VersionedInitializable,
)
from contracts.protocol.libraries.helpers.bool_cmp import BoolCmp
from contracts.protocol.libraries.helpers.errors import Errors
from contracts.protocol.libraries.helpers.helpers import is_zero
from contracts.protocol.libraries.logic.pool_logic import PoolLogic
from contracts.protocol.libraries.logic.reserve_configuration import ReserveConfiguration
from contracts.protocol.libraries.logic.reserve_logic import ReserveLogic
from contracts.protocol.libraries.logic.supply_logic import SupplyLogic
from contracts.protocol.libraries.types.data_types import DataTypes
from contracts.protocol.pool.pool_library import Pool
from contracts.protocol.pool.pool_storage import PoolStorage

const REVISION = 1;

func assert_only_pool_configurator{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) {
    let (caller) = get_caller_address();
    let (addresses_provider) = PoolStorage.addresses_provider_read();
    let (pool_configurator) = IPoolAddressesProvider.get_address(
        addresses_provider, 'POOL_CONFIGURATOR'
    );
    let error_code = Errors.CALLER_NOT_POOL_CONFIGURATOR;
    with_attr error_message("{error_code}") {
        assert caller = pool_configurator;
    }
    return ();
}

func assert_only_pool_admin{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    let (caller) = get_caller_address();
    let (addresses_provider) = PoolStorage.addresses_provider_read();
    let (acl_manager_address) = IPoolAddressesProvider.get_ACL_manager(
        contract_address=addresses_provider
    );
    let (is_pool_admin) = IACLManager.is_pool_admin(
        contract_address=acl_manager_address, admin_address=caller
    );
    let error_code = Errors.CALLER_NOT_ASSET_LISTING_OR_POOL_ADMIN;
    with_attr error_message("{error_code}") {
        assert is_pool_admin = TRUE;
    }
    return ();
}

@view
func get_revision{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    revision: felt
) {
    return (REVISION,);
}

// @notice Initializes the Pool.
// @dev Function is invoked by the proxy contract when the Pool contract is added to the
// PoolAddressesProvider of the market.
// @param provider The address of the PoolAddressesProvider
@external
func initialize{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(provider: felt) {
    VersionedInitializable.initializer(REVISION);
    PoolStorage.addresses_provider_write(provider);
    PoolStorage.max_stable_rate_borrow_size_percent_write(25 * 10 ** 2);  // 0.25e4 bps
    PoolStorage.flash_loan_premium_total_write(9);  // 9bps
    PoolStorage.flash_loan_premium_to_protocol_write(0);
    return ();
}

// Supplies an `amount` of underlying asset into the reserve, receiving in return overlying aTokens.
// - E.g. User supplies 100 USDC and gets in return 100 aUSDC
// @param asset The address of the underlying asset to supply
// @param amount The amount to be supplied
// @param on_behalf_of The address that will receive the aTokens, same as caller_address if the user
// wants to receive them on his own wallet, or a different address if the beneficiary of aTokens
// is a different wallet.
// @param referral_code Code used to register the integrator originating the operation, for potential rewards.
// 0 if the action is executed directly by the user, without any middle-man.
@external
func supply{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    asset: felt, amount: Uint256, on_behalf_of: felt, referral_code: felt
) {
    // TODO user configuration bitmask
    SupplyLogic.execute_supply(
        user_config=DataTypes.UserConfigurationMap(0, 0),
        params=DataTypes.ExecuteSupplyParams(
        asset=asset,
        amount=amount,
        on_behalf_of=on_behalf_of,
        referral_code=referral_code,
        ),
    );
    return ();
}

// @notice Withdraws an `amount` of underlying asset from the reserve, burning the equivalent aTokens owned
// E.g. User has 100 aUSDC, calls withdraw() and receives 100 USDC, burning the 100 aUSDC
// @param asset The address of the underlying asset to withdraw
// @param amount The underlying amount to be withdrawn
//   - Send the value type(uint256).max in order to withdraw the whole aToken balance
// @param to The address that will receive the underlying, same as msg.sender if the user
//   wants to receive it on his own wallet, or a different address if the beneficiary is a
//   different wallet
// @return The final amount withdrawn
@external
func withdraw{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    asset: felt, amount: Uint256, to: felt
) {
    let (reserves_count) = PoolStorage.reserves_count_read();
    SupplyLogic.execute_withdraw(
        user_config=DataTypes.UserConfigurationMap(0, 0),
        params=DataTypes.ExecuteWithdrawParams(
        asset=asset,
        amount=amount,
        to=to,
        reserves_count=reserves_count,
        ),
    );

    return ();
}

// @notice Initializes a reserve, activating it, assigning an aToken and debt tokens and an
// interest rate strategy
// @dev Only callable by the PoolConfigurator contract
// @param asset The address of the underlying asset of the reserve
// @param a_token_address The address of the aToken that will be assigned to the reserve
@external
func init_reserve{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    asset: felt,
    a_token_address: felt,
    stable_debt_token_address: felt,
    variable_debt_token_address: felt,
    interest_rate_strategy_address: felt,
) {
    alloc_locals;
    assert_only_pool_configurator();
    let (local reserves_count) = PoolStorage.reserves_count_read();
    let (appended) = PoolLogic.execute_init_reserve(
        params=DataTypes.InitReserveParams(
        asset=asset,
        a_token_address=a_token_address,
        stable_debt_token_address=stable_debt_token_address,
        variable_debt_token_address=variable_debt_token_address,
        interest_rate_strategy_address=interest_rate_strategy_address,
        reserves_count=reserves_count,
        max_number_reserves=128
        ),
    );
    if (appended == TRUE) {
        PoolStorage.reserves_count_write(reserves_count + 1);
        tempvar syscall_ptr = syscall_ptr;
        tempvar pedersen_ptr = pedersen_ptr;
        tempvar range_check_ptr = range_check_ptr;
    } else {
        tempvar syscall_ptr = syscall_ptr;
        tempvar pedersen_ptr = pedersen_ptr;
        tempvar range_check_ptr = range_check_ptr;
    }
    return ();
}

// @notice Drop a reserve
// @dev Only callable by the PoolConfigurator contract
// @param asset The address of the underlying asset of the reserve
@external
func drop_reserve{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(asset: felt) {
    PoolLogic.execute_drop_reserve(asset);
    return ();
}

// @notice Set pool configuration
// @dev Only callable by the PoolConfigurator contract
// @param asset The address of the underlying asset of the reserve
// @param configuration The configuration to set for the reserve
@external
func set_configuration{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    asset: felt, configuration: DataTypes.ReserveConfiguration
) {
    alloc_locals;
    assert_only_pool_configurator();
    let error_code = Errors.ZERO_ADDRESS_NOT_VALID;
    with_attr error_message("{error_code}") {
        assert_not_zero(asset);
    }
    let (reserve) = PoolStorage.reserves_read(asset);
    let is_id_not_zero = is_not_zero(reserve.id);
    let (first_asset) = Pool.get_reserve_address_by_id(0);
    let (is_first_asset) = is_zero(first_asset - asset);
    let is_asset_listed = BoolCmp.either(is_id_not_zero, is_first_asset);
    let error_code = Errors.ASSET_NOT_LISTED;
    with_attr error_message("{error_code}") {
        assert is_asset_listed = TRUE;
    }
    PoolStorage.reserves_config_write(asset, configuration);
    return ();
}

@view
func get_addresses_provider{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    provider: felt
) {
    let (provider) = PoolStorage.addresses_provider_read();
    return (provider,);
}

@view
func get_reserve_data{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    asset: felt
) -> (reserve_data: DataTypes.ReserveData) {
    let (reserve) = PoolStorage.reserves_read(asset);
    return (reserve,);
}

@view
func get_configuration{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    asset: felt
) -> (config: DataTypes.ReserveConfiguration) {
    let (reserve) = PoolStorage.reserves_read(asset);
    let config = reserve.configuration;
    return (config,);
}

@view
func get_reserve_normalized_variable_debt{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}(asset: felt) -> (normalized_variable_debt: felt) {
    return ReserveLogic.get_normalized_debt(asset);
}

@view
func get_reserve_normalized_income(asset: felt) -> (res: Uint256) {
    // TODO
    return (res=Uint256(0, 0));
}

@view
func get_reserves_list{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    assets_len: felt, assets: felt*
) {
    let (assets, assets_len) = Pool.get_reserves_list();
    return (assets, assets_len);
}

@view
func get_reserve_address_by_id{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    reserve_id: felt
) -> (address: felt) {
    let (address: felt) = Pool.get_reserve_address_by_id(reserve_id);
    return (address,);
}

@view
func MAX_NUMBER_RESERVES{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    max_number: felt
) {
    let max_number = ReserveConfiguration.MAX_RESERVES_COUNT;
    return (max_number,);
}

@external
func finalize_transfer(
    asset: felt,
    sender: felt,
    recipient: felt,
    amount: Uint256,
    sender_balance: Uint256,
    recipient_balance: Uint256,
) {
    // TODO
    return ();
}
