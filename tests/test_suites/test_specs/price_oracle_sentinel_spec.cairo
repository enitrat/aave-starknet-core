%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_contract_address

from contracts.interfaces.i_acl_manager import IACLManager
from contracts.interfaces.i_pool_addresses_provider import IPoolAddressesProvider
from contracts.interfaces.i_sequencer_oracle import ISequencerOracle
from contracts.interfaces.i_price_oracle_sentinel import IPriceOracleSentinel
from contracts.protocol.libraries.helpers.errors import Errors

const PRANK_ADMIN_ADDRESS = 2222
const POOL_ADMIN_ADDRESS = 5555
const RISK_ADMIN_ADDRESS = 6666
const ZERO_ADDRESS = 0
const PRANK_OWNER = 10
const PRANK_SEQUENCER_ORACLE_ADDRESS = 1111
const PRANK_PRICE_ORACLE_SENTINEL_ADDRESS = 3333
const USER_1 = 33
const GRACE_PERIOD = 3600

# Utils funcitons
func get_context{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    acl_address : felt,
    pool_addresses_provider : felt,
    sequencer_oracle : felt,
    price_oracle_sentinel : felt,
):
    alloc_locals
    local deployer
    local acl_manager
    local pool_addresses_provider
    local sequencer_oracle
    local price_oracle_sentinel
    %{
        ids.deployer = context.deployer
        ids.acl_manager = context.acl_manager
        ids.pool_addresses_provider = context.pool_addresses_provider
        ids.sequencer_oracle = context.sequencer_oracle
        ids.price_oracle_sentinel = context.price_oracle_sentinel
    %}

    %{ stop_prank = start_prank(ids.deployer, target_contract_address= ids.pool_addresses_provider) %}
    IPoolAddressesProvider.set_ACL_manager(pool_addresses_provider, acl_manager)
    let (acl_manager) = IPoolAddressesProvider.get_ACL_manager(pool_addresses_provider)
    assert acl_manager = acl_manager
    %{ stop_prank() %}
    return (acl_manager, pool_addresses_provider, sequencer_oracle, price_oracle_sentinel)
end

namespace TestPriceOracleSentinel:
    func test_activate_sentinel{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        ):
        # Init Context and states
        alloc_locals
        let (
            local acl,
            local pool_addresses_provider,
            local sequencer_oracle,
            local price_oracle_sentinel,
        ) = get_context()

        # Set Pool Admin
        %{ stop_prank = start_prank(ids.PRANK_ADMIN_ADDRESS, target_contract_address = ids.acl) %}
        IACLManager.add_pool_admin(acl, POOL_ADMIN_ADDRESS)
        %{ stop_prank() %}

        # Set price oracle sentinel
        IPoolAddressesProvider.set_price_oracle_sentinel(
            pool_addresses_provider, price_oracle_sentinel
        )

        # Check Sentinel
        let (test_price_oracle_sentinel) = IPoolAddressesProvider.get_price_oracle_sentinel(
            pool_addresses_provider
        )
        assert test_price_oracle_sentinel = price_oracle_sentinel

        let (_, isDown, _, last_timestamp, _) = ISequencerOracle.latest_round_data(sequencer_oracle)
        assert isDown = 0
        assert last_timestamp = 0
        return ()
    end

    # Pooladmin updates grace period for sentinel
    func test_update_grace_period{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }():
        # Init context and states
        alloc_locals
        let (
            local acl,
            local pool_addresses_provider,
            local sequencer_oracle,
            local price_oracle_sentinel,
        ) = get_context()

        let new_grace_period = 0
        let (grace_period_before) = IPriceOracleSentinel.get_grace_period(price_oracle_sentinel)
        assert grace_period_before = GRACE_PERIOD

        # Set Pool Admin
        %{ stop_prank = start_prank(ids.PRANK_ADMIN_ADDRESS, target_contract_address = ids.acl) %}
        IACLManager.add_pool_admin(acl, POOL_ADMIN_ADDRESS)
        %{ stop_prank() %}

        %{ stop_prank = start_prank(ids.POOL_ADMIN_ADDRESS, target_contract_address = ids.price_oracle_sentinel) %}
        IPriceOracleSentinel.set_grace_period(price_oracle_sentinel, new_grace_period)
        %{ stop_prank() %}

        let (grace_period_after) = IPriceOracleSentinel.get_grace_period(price_oracle_sentinel)
        assert grace_period_after = new_grace_period

        return ()
    end

    # Risk admin updates grace period for sentinel
    func test_risk_admin_update_grace_period{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }():
        # Init context and states
        alloc_locals
        let (
            local acl,
            local pool_addresses_provider,
            local sequencer_oracle,
            local price_oracle_sentinel,
        ) = get_context()

        let new_grace_period = 0
        let (grace_period_before) = IPriceOracleSentinel.get_grace_period(price_oracle_sentinel)
        assert grace_period_before = GRACE_PERIOD

        # Set Risk Admin
        %{ stop_prank = start_prank(ids.PRANK_ADMIN_ADDRESS, target_contract_address = ids.acl) %}
        IACLManager.add_risk_admin(acl, RISK_ADMIN_ADDRESS)
        %{ stop_prank() %}

        %{ stop_prank = start_prank(ids.RISK_ADMIN_ADDRESS, target_contract_address = ids.price_oracle_sentinel) %}
        IPriceOracleSentinel.set_grace_period(price_oracle_sentinel, new_grace_period)
        %{ stop_prank() %}

        let (grace_period_after) = IPriceOracleSentinel.get_grace_period(price_oracle_sentinel)
        assert grace_period_after = new_grace_period

        return ()
    end

    func test_update_grace_period_with_not_admin{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }():
        # Init context and states
        alloc_locals
        let (
            local acl,
            local pool_addresses_provider,
            local sequencer_oracle,
            local price_oracle_sentinel,
        ) = get_context()

        let new_grace_period = 0
        let (grace_period_before) = IPriceOracleSentinel.get_grace_period(price_oracle_sentinel)
        assert grace_period_before = GRACE_PERIOD

        # Try to change grace period with not admin
        %{ stop_prank = start_prank(ids.USER_1, target_contract_address = ids.price_oracle_sentinel) %}
        %{ expect_revert(error_message=f"{ids.Errors.CALLER_NOT_RISK_OR_POOL_ADMIN}") %}
        IPriceOracleSentinel.set_grace_period(price_oracle_sentinel, new_grace_period)
        %{ stop_prank() %}
        return ()
    end

    # Pooladmin updates sequencer oracle for sentinel
    func test_pool_admin_update_sequencer_oracle{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }():
        # Init context and states
        alloc_locals
        let (
            local acl,
            local pool_addresses_provider,
            local sequencer_oracle,
            local price_oracle_sentinel,
        ) = get_context()

        let new_sequencer_oracle = ZERO_ADDRESS
        let (sequencer_oracle_before) = IPriceOracleSentinel.get_sequencer_oracle(
            price_oracle_sentinel
        )
        assert sequencer_oracle_before = sequencer_oracle

        # Set Pool Admin
        %{ stop_prank = start_prank(ids.PRANK_ADMIN_ADDRESS, target_contract_address = ids.acl) %}
        IACLManager.add_pool_admin(acl, POOL_ADMIN_ADDRESS)
        %{ stop_prank() %}

        %{ stop_prank = start_prank(ids.POOL_ADMIN_ADDRESS, target_contract_address = ids.price_oracle_sentinel) %}
        IPriceOracleSentinel.set_sequencer_oracle(price_oracle_sentinel, new_sequencer_oracle)
        %{ stop_prank() %}

        let (sequencer_oracle_after) = IPriceOracleSentinel.get_sequencer_oracle(
            price_oracle_sentinel
        )
        assert sequencer_oracle_after = new_sequencer_oracle

        return ()
    end

    # User tries to update sequence oracle
    func test_update_sequence_oracle_with_not_admin{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }():
        # Init context and states
        alloc_locals
        let (
            local acl,
            local pool_addresses_provider,
            local sequencer_oracle,
            local price_oracle_sentinel,
        ) = get_context()

        let new_sequencer_oracle = ZERO_ADDRESS
        let (sequencer_oracle_before) = IPriceOracleSentinel.get_sequencer_oracle(
            price_oracle_sentinel
        )
        assert sequencer_oracle_before = sequencer_oracle

        # Try to change grace period with not admin
        %{ stop_prank = start_prank(ids.USER_1, target_contract_address = ids.price_oracle_sentinel) %}
        %{ expect_revert(error_message=f"{ids.Errors.CALLER_NOT_POOL_ADMIN}") %}
        IPriceOracleSentinel.set_sequencer_oracle(price_oracle_sentinel, new_sequencer_oracle)
        %{ stop_prank() %}
        return ()
    end
end
