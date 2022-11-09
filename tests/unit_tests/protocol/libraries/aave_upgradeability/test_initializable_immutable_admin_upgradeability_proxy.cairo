%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_contract_address

from contracts.interfaces.i_proxy import IProxy
from contracts.protocol.libraries.helpers.constants import INITIALIZE_SELECTOR

from tests.utils.constants import USER_1

@contract_interface
namespace IToken {
    func get_name() -> (name: felt) {
    }

    func get_total_supply() -> (supply: felt) {
    }
}

@external
func __setup__{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    let (deployer) = get_contract_address();
    %{
        context.proxy_address = deploy_contract("./contracts/protocol/libraries/aave_upgradeability/initializable_immutable_admin_upgradeability_proxy.cairo", {"proxy_admin": ids.deployer}).contract_address
        context.implementation_hash = declare("./tests/mocks/mock_token.cairo").class_hash
    %}

    tempvar proxy;
    tempvar implementation_hash;

    %{
        ids.proxy = context.proxy_address 
        ids.implementation_hash=context.implementation_hash
    %}

    IProxy.initialize(
        proxy, implementation_hash, INITIALIZE_SELECTOR, 2, cast(new (345, 900), felt*)
    );

    return ();
}

@external
func test_initialize{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    tempvar proxy;

    %{ ids.proxy = context.proxy_address %}
    %{ stop_prank_non_admin = start_prank(ids.USER_1,target_contract_address=context.proxy_address) %}
    let (name) = IToken.get_name(proxy);
    let (supply) = IToken.get_total_supply(proxy);
    %{ stop_prank_non_admin() %}
    assert name = 345;
    assert supply = 900;
    return ();
}

@external
func test_initialize_when_already_initialized{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    alloc_locals;
    local proxy;
    local implementation_hash;

    %{
        ids.proxy = context.proxy_address 
        ids.implementation_hash=context.implementation_hash
    %}

    %{ expect_revert(error_message="Already initialized") %}
    IProxy.initialize(
        proxy, implementation_hash, INITIALIZE_SELECTOR, 2, cast(new (33, 33), felt*)
    );

    return ();
}

@external
func test_update_to_and_call{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;
    local proxy;
    local implementation_hash;

    %{
        ids.proxy = context.proxy_address 
        ids.implementation_hash=context.implementation_hash
    %}

    // no need to change the implementation hash as long as we verify that the init values were updated
    IProxy.upgrade_to_and_call(
        proxy, implementation_hash, INITIALIZE_SELECTOR, 2, cast(new (400, 500), felt*)
    );
    %{ stop_prank_non_admin = start_prank(ids.USER_1,target_contract_address=context.proxy_address) %}
    let (name) = IToken.get_name(proxy);
    let (supply) = IToken.get_total_supply(proxy);
    %{ stop_prank_non_admin() %}
    assert name = 400;
    assert supply = 500;
    return ();
}

@external
func test_upgrade_to{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;
    local proxy;

    %{ ids.proxy = context.proxy_address %}

    let new_implementation_hash = 34004;

    IProxy.upgrade_to(proxy, new_implementation_hash);

    let (current_implementation) = IProxy.get_implementation(proxy);

    assert current_implementation = new_implementation_hash;

    return ();
}

@external
func test_proxy_admin_calls_fall_back_function{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    alloc_locals;
    local proxy;

    %{ ids.proxy = context.proxy_address %}

    %{ expect_revert(error_message="Proxy: caller is admin") %}
    let (name) = IToken.get_name(proxy);

    return ();
}
