%lang starknet

from starkware.cairo.common.bool import TRUE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_caller_address
from starkware.cairo.common.math_cmp import is_le
from starkware.starknet.common.syscalls import get_block_timestamp

from contracts.protocol.libraries.helpers.bool_cmp import BoolCmp
from contracts.interfaces.i_pool_addresses_provider import IPoolAddressesProvider
from contracts.interfaces.i_acl_manager import IACLManager
from contracts.interfaces.i_sequencer_oracle import ISequencerOracle
from contracts.protocol.libraries.helpers.errors import Errors

# store address of IPoolAddressesProvider here
@storage_var
func PriceOracleSentinel_addresses_provider() -> (provider : felt):
end

# store address of Sequencer oracle here
@storage_var
func PriceOracleSentinel_sequencer_oracle() -> (sequencer_address : felt):
end

# store period of grace here
@storage_var
func PriceOracleSentinel_grace_period() -> (grace_period : felt):
end

@event
func SequencerOracleUpdated(new_sequencer_oracle : felt):
end

@event
func GracePeriodUpdated(new_grace_period : felt):
end

func assert_only_pool_admin{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals
    let (l_addresses_provider) = PriceOracleSentinel_addresses_provider.read()
    let (acl) = IPoolAddressesProvider.get_ACL_manager(l_addresses_provider)
    let (caller_address) = get_caller_address()
    let (is_admin) = IACLManager.is_pool_admin(acl, caller_address)
    let error_code = Errors.CALLER_NOT_POOL_ADMIN
    with_attr error_message("{error_code}"):
        assert is_admin = TRUE
    end
    return ()
end

func assert_only_risk_or_pool_admin{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}():
    alloc_locals
    let (l_addresses_provider) = PriceOracleSentinel_addresses_provider.read()
    let (acl) = IPoolAddressesProvider.get_ACL_manager(l_addresses_provider)
    let (caller_address) = get_caller_address()
    let (is_pool_admin) = IACLManager.is_pool_admin(acl, caller_address)
    let (is_risk_admin) = IACLManager.is_risk_admin(acl, caller_address)
    let (allowance) = BoolCmp.either(is_pool_admin, is_risk_admin)
    let error_code = Errors.CALLER_NOT_RISK_OR_POOL_ADMIN
    with_attr error_message("{error_code}"):
        assert allowance = TRUE
    end
    return ()
end

namespace PriceOracleSentinel:
    func initializer{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        addresses_provider : felt, oracle_sentinel : felt, grace_period : felt
    ):
        PriceOracleSentinel_addresses_provider.write(addresses_provider)
        PriceOracleSentinel_sequencer_oracle.write(oracle_sentinel)
        PriceOracleSentinel_grace_period.write(grace_period)
        return ()
    end

    func is_borrow_allowed{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
        bool : felt
    ):
        return _is_up_and_grace_period_passed()
    end

    func is_liquidation_allowed{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        ) -> (bool : felt):
        return _is_up_and_grace_period_passed()
    end

    func _is_up_and_grace_period_passed{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }() -> (bool : felt):
        alloc_locals
        let (sequencer_oracle) = PriceOracleSentinel_sequencer_oracle.read()
        let (_, answer, _, last_updated_timestamp, _) = ISequencerOracle.latest_round_data(
            sequencer_oracle
        )
        let (block_timestamp) = get_block_timestamp()
        let (grace_period) = PriceOracleSentinel_grace_period.read()
        let (is_grace_period_over) = is_le(
            grace_period + 1, block_timestamp - last_updated_timestamp
        )
        let (both) = BoolCmp.both(answer, is_grace_period_over)
        return (both)
    end

    func set_sequencer_oracle{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        new_sequencer_oracle : felt
    ) -> ():
        assert_only_pool_admin()
        PriceOracleSentinel_sequencer_oracle.write(new_sequencer_oracle)
        SequencerOracleUpdated.emit(new_sequencer_oracle)
        return ()
    end

    func set_grace_period{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        new_grace_period : felt
    ) -> ():
        assert_only_risk_or_pool_admin()
        PriceOracleSentinel_grace_period.write(new_grace_period)
        GracePeriodUpdated.emit(new_grace_period)
        return ()
    end

    func get_sequencer_oracle{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        ) -> (sequencer_oracle : felt):
        let (sequencer) = PriceOracleSentinel_sequencer_oracle.read()
        return (sequencer)
    end

    func get_grace_period{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
        grace_period : felt
    ):
        let (grace_period) = PriceOracleSentinel_grace_period.read()
        return (grace_period)
    end

    func ADDRESSES_PROVIDER{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        ) -> (addresses_provider : felt):
        let (addresses_provider) = PriceOracleSentinel_addresses_provider.read()
        return (addresses_provider)
    end
end
