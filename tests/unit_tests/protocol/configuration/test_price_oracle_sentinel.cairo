%lang starknet

from starkware.cairo.common.bool import FALSE, TRUE
from starkware.cairo.common.cairo_builtins import HashBuiltin

from contracts.protocol.configuration.price_oracle_sentinel_library import PriceOracleSentinel
from contracts.protocol.libraries.helpers.errors import Errors

const PROVIDER = 11111
const ACL_MANAGER = 123456
const ORACLE = 22222
const NEW_ORACLE = 22223
const GRACE_PERIOD = 1
const PRANK_USER_1 = 11

@view
func test_initializer{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    PriceOracleSentinel.initializer(PROVIDER, ORACLE, GRACE_PERIOD)
    let (local_provider) = PriceOracleSentinel.ADDRESSES_PROVIDER()
    let (local_oracle) = PriceOracleSentinel.get_sequencer_oracle()
    let (local_grace_period) = PriceOracleSentinel.get_grace_period()
    assert local_provider = PROVIDER
    assert local_oracle = ORACLE
    assert local_grace_period = GRACE_PERIOD
    return ()
end

@view
func test_setter_true{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    PriceOracleSentinel.initializer(PROVIDER, ORACLE, GRACE_PERIOD)

    mock_pool_admin_true()
    PriceOracleSentinel.set_grace_period(20)
    PriceOracleSentinel.set_sequencer_oracle(NEW_ORACLE)

    let (new_grace_period) = PriceOracleSentinel.get_grace_period()
    let (new_sequencer_oracle) = PriceOracleSentinel.get_sequencer_oracle()
    assert new_sequencer_oracle = NEW_ORACLE
    assert new_grace_period = 20
    return ()
end

@view
func test_setter_false{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    PriceOracleSentinel.initializer(PROVIDER, ORACLE, GRACE_PERIOD)
    mock_pool_admin_false()
    %{ expect_revert(error_message=f"{ids.Errors.CALLER_NOT_RISK_OR_POOL_ADMIN}") %}
    PriceOracleSentinel.set_grace_period(30)
    return ()
end

@view
func test_borrow_allowance{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    PriceOracleSentinel.initializer(PROVIDER, ORACLE, GRACE_PERIOD)

    # mock call to latest_round_data and get_block_timestamp so that grace period is over
    # and allow borrowing
    %{
        stop_mock = mock_call(ids.ORACLE,"latest_round_data",[0, 1, 0, 0, 0])
        stop_warp = warp(20)
    %}
    let (can_borrow) = PriceOracleSentinel.is_borrow_allowed()
    assert can_borrow = TRUE
    %{
        stop_mock()
        stop_warp()
    %}

    # mock call to latest_round_data and get_block_timestamp so that grace period is not over
    # and not allow borrowing
    %{
        stop_mock_2 = mock_call(ids.ORACLE,"latest_round_data",[0, 1, 0, 1, 0])
        stop_warp_2 = warp(2)
    %}
    let (cant_borrow) = PriceOracleSentinel.is_borrow_allowed()
    assert cant_borrow = FALSE
    %{
        stop_mock_2()
        stop_warp_2()
    %}

    return ()
end

func mock_pool_admin_true{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    %{
        stop_mock_1 = mock_call(ids.PROVIDER,"get_ACL_manager",[ids.ACL_MANAGER])
        stop_mock_2 = mock_call(ids.ACL_MANAGER,"is_pool_admin",[1])
        stop_mock_3 = mock_call(ids.ACL_MANAGER,"is_risk_admin",[0])
    %}
    return ()
end

func mock_pool_admin_false{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    %{
        stop_mock_1 = mock_call(ids.PROVIDER,"get_ACL_manager",[ids.ACL_MANAGER])
        stop_mock_2 = mock_call(ids.ACL_MANAGER,"is_pool_admin",[0])
        stop_mock_3 = mock_call(ids.ACL_MANAGER,"is_risk_admin",[0])
    %}
    return ()
end
