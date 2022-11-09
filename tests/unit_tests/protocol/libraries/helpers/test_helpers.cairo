%lang starknet

from starkware.cairo.common.bool import FALSE, TRUE
from starkware.cairo.lang.compiler.lib.registers import get_fp_and_pc

from contracts.protocol.libraries.helpers.helpers import is_zero, update_struct

struct MyStruct {
    a: felt,
    b: felt,
    c: felt,
}

@view
func test_is_zero() {
    let (true) = is_zero(0);
    let (false) = is_zero(1);
    assert true = TRUE;
    assert false = FALSE;
    return ();
}

@view
func test_update_struct{range_check_ptr}() {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    local my_struct: MyStruct = MyStruct(1, 2, 3);
    local modified_value = 100;
    let (modified_struct_ptr: MyStruct*) = update_struct(
        &my_struct, MyStruct.SIZE, &modified_value, 1
    );
    let modified_struct: MyStruct = [modified_struct_ptr];

    assert modified_struct = MyStruct(1, 100, 3);
    return ();
}

@view
func test_update_struct_out_of_range{range_check_ptr}() {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    local my_struct: MyStruct = MyStruct(1, 2, 3);
    local modified_value = 100;
    %{ expect_revert() %}
    let (modified_struct_ptr: MyStruct*) = update_struct(
        &my_struct, MyStruct.SIZE, &modified_value, 10
    );
    return ();
}
