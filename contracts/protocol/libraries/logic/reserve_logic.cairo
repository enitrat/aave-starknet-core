%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_block_timestamp

from contracts.protocol.libraries.types.data_types import DataTypes
from contracts.protocol.pool.pool_storage import PoolStorage
from contracts.protocol.libraries.math.felt_math import to_felt, to_uint256
from contracts.protocol.libraries.math.wad_ray_math import WadRayMath
from contracts.protocol.libraries.math.math_utils import MathUtils
from contracts.protocol.libraries.helpers.errors import Errors
from contracts.protocol.libraries.helpers.constants import empty_reserve_configuration

namespace ReserveLogic {
    // @notice Initializes a reserve.
    // @param reserve The reserve object
    // @param a_token_address The address of the overlying atoken contract
    func init{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        reserve: DataTypes.ReserveData,
        a_token_address: felt,
        stable_debt_token_address: felt,
        variable_debt_token_address: felt,
        interest_rate_strategy_address: felt,
    ) -> (reserve: DataTypes.ReserveData) {
        let error_code = Errors.RESERVE_ALREADY_INITIALIZED;
        with_attr error_message("{error_code}") {
            assert reserve.a_token_address = 0;
        }

        // Write a_token_address in reserve
        let (empty_config) = empty_reserve_configuration();
        let new_reserve = DataTypes.ReserveData(
            configuration=empty_config,
            liquidity_index=WadRayMath.RAY,
            0,
            variable_borrow_index=WadRayMath.RAY,
            0,
            0,
            0,
            id=reserve.id,
            a_token_address=a_token_address,
            stable_debt_token_address=stable_debt_token_address,
            variable_debt_token_address=variable_debt_token_address,
            interest_rate_strategy_address=interest_rate_strategy_address,
            0,
            0,
            0,
        );
        PoolStorage.reserves_write(a_token_address, new_reserve);
        // TODO add other params such as liq index, debt tokens addresses, use RayMath library
        return (new_reserve,);
    }

    func get_normalized_debt{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        asset: felt
    ) -> (normalized_variable_debt: felt) {
        alloc_locals;
        let (reserve) = PoolStorage.reserves_read(asset);
        let reserve_timestamp = reserve.last_update_timestamp;
        let (cur_timestamp) = get_block_timestamp();
        if (cur_timestamp == reserve_timestamp) {
            return (reserve.variable_borrow_index,);
        } else {
            let (variable_rate_256) = to_uint256(reserve.current_variable_borrow_rate);
            let (variable_borrow_index_256) = to_uint256(reserve.variable_borrow_index);
            let (compound_interest) = MathUtils.calculate_compounded_interest(
                variable_rate_256, reserve_timestamp
            );
            let (result_256) = WadRayMath.ray_mul(compound_interest, variable_borrow_index_256);
            let (result_felt) = to_felt(result_256);
            return (result_felt,);
        }
    }

    // @notice Creates a cache object to avoid repeated storage reads and external contract calls when updating state and
    // interest rates.
    // @param reserve The reserve object for which the cache will be filled
    // @return The cache object

    // TODO implement the cache function that initializes and returns a new reserve cache
    // func get_cache{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}()->(DataTypes.ReserveCache):
    // end
}
