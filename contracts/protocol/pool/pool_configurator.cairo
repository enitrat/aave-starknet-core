%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin

from contracts.protocol.libraries.types.configurator_input_types import ConfiguratorInputTypes
from contracts.protocol.pool.pool_configurator_library import PoolConfigurator

#
# View
#

@view
func get_revision{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    revision : felt
):
    let (revision) = PoolConfigurator.get_revision()
    return (revision)
end

#
# Externals
#

@external
func initialize{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(provider : felt):
    PoolConfigurator.initialize(provider)
    return ()
end

@external
func init_reserves{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    input_len : felt, input : ConfiguratorInputTypes.InitReserveInput*
):
    PoolConfigurator.init_reserves(input_len, input)
    return ()
end

@external
func drop_reserve{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(asset : felt):
    PoolConfigurator.drop_reserve(asset)
    return ()
end

@external
func update_a_token{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    input : ConfiguratorInputTypes.UpdateATokenInput
):
    PoolConfigurator.update_a_token(input)
    return ()
end

@external
func update_stable_debt_token{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    input : ConfiguratorInputTypes.UpdateDebtTokenInput
):
    PoolConfigurator.update_stable_debt_token(input)
    return ()
end

@external
func update_variable_debt_token{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    input : ConfiguratorInputTypes.UpdateDebtTokenInput
):
    PoolConfigurator.update_variable_debt_token(input)
    return ()
end

@external
func set_reserve_borrowing{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    asset : felt, enabled : felt
):
    PoolConfigurator.set_reserve_borrowing(asset, enabled)
    return ()
end
