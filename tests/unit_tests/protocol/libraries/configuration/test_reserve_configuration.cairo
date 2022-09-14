%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin

from contracts.protocol.libraries.configuration.reserve_configuration import ReserveConfiguration

const TEST_RESERVE_ASSET = 101928301924019284;

@external
func test_ltv{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    let (ltv) = ReserveConfiguration.get_ltv(TEST_RESERVE_ASSET);
    assert ltv = 0;
    ReserveConfiguration.set_ltv(TEST_RESERVE_ASSET, 10);
    let (ltv) = ReserveConfiguration.get_ltv(TEST_RESERVE_ASSET);
    assert ltv = 10;
    return ();
}

@external
func test_liquidation_threshold{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    let (liquidation_threshold) = ReserveConfiguration.get_liquidation_threshold(
        TEST_RESERVE_ASSET
    );
    assert liquidation_threshold = 0;
    ReserveConfiguration.set_liquidation_threshold(TEST_RESERVE_ASSET, 10);
    let (liquidation_threshold) = ReserveConfiguration.get_liquidation_threshold(
        TEST_RESERVE_ASSET
    );
    assert liquidation_threshold = 10;
    return ();
}

@external
func test_liquidation_bonus{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    let (liquidation_bonus) = ReserveConfiguration.get_liquidation_bonus(TEST_RESERVE_ASSET);
    assert liquidation_bonus = 0;
    ReserveConfiguration.set_liquidation_bonus(TEST_RESERVE_ASSET, 10);
    let (liquidation_bonus) = ReserveConfiguration.get_liquidation_bonus(TEST_RESERVE_ASSET);
    assert liquidation_bonus = 10;
    return ();
}

@external
func test_decimals{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    let (decimals) = ReserveConfiguration.get_decimals(TEST_RESERVE_ASSET);
    assert decimals = 0;
    ReserveConfiguration.set_decimals(TEST_RESERVE_ASSET, 10);
    let (decimals) = ReserveConfiguration.get_decimals(TEST_RESERVE_ASSET);
    assert decimals = 10;
    return ();
}

@external
func test_active{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    let (active) = ReserveConfiguration.get_active(TEST_RESERVE_ASSET);
    assert active = 0;
    ReserveConfiguration.set_active(TEST_RESERVE_ASSET, 1);
    let (active) = ReserveConfiguration.get_active(TEST_RESERVE_ASSET);
    assert active = 1;
    return ();
}

@external
func test_frozen{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    let (frozen) = ReserveConfiguration.get_frozen(TEST_RESERVE_ASSET);
    assert frozen = 0;
    ReserveConfiguration.set_frozen(TEST_RESERVE_ASSET, 1);
    let (frozen) = ReserveConfiguration.get_frozen(TEST_RESERVE_ASSET);
    assert frozen = 1;
    return ();
}

@external
func test_paused{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    let (paused) = ReserveConfiguration.get_paused(TEST_RESERVE_ASSET);
    assert paused = 0;
    ReserveConfiguration.set_paused(TEST_RESERVE_ASSET, 1);
    let (paused) = ReserveConfiguration.get_paused(TEST_RESERVE_ASSET);
    assert paused = 1;
    return ();
}

@external
func test_borrowable_in_isolation{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) {
    let (borrowable_in_isolation) = ReserveConfiguration.get_borrowable_in_isolation(
        TEST_RESERVE_ASSET
    );
    assert borrowable_in_isolation = 0;
    ReserveConfiguration.set_borrowable_in_isolation(TEST_RESERVE_ASSET, 1);
    let (borrowable_in_isolation) = ReserveConfiguration.get_borrowable_in_isolation(
        TEST_RESERVE_ASSET
    );
    assert borrowable_in_isolation = 1;
    return ();
}

@external
func test_siloed_borrowing{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    let (siloed_borrowing) = ReserveConfiguration.get_siloed_borrowing(TEST_RESERVE_ASSET);
    assert siloed_borrowing = 0;
    ReserveConfiguration.set_siloed_borrowing(TEST_RESERVE_ASSET, 1);
    let (siloed_borrowing) = ReserveConfiguration.get_siloed_borrowing(TEST_RESERVE_ASSET);
    assert siloed_borrowing = 1;
    return ();
}

@external
func test_borrow_cap{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    let (borrow_cap) = ReserveConfiguration.get_borrow_cap(TEST_RESERVE_ASSET);
    assert borrow_cap = 0;
    ReserveConfiguration.set_borrow_cap(TEST_RESERVE_ASSET, 10);
    let (borrow_cap) = ReserveConfiguration.get_borrow_cap(TEST_RESERVE_ASSET);
    assert borrow_cap = 10;
    return ();
}

@external
func test_supply_cap{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    let (supply_cap) = ReserveConfiguration.get_supply_cap(TEST_RESERVE_ASSET);
    assert supply_cap = 0;
    ReserveConfiguration.set_supply_cap(TEST_RESERVE_ASSET, 10);
    let (supply_cap) = ReserveConfiguration.get_supply_cap(TEST_RESERVE_ASSET);
    assert supply_cap = 10;
    return ();
}

@external
func test_debt_ceiling{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    let (debt_ceiling) = ReserveConfiguration.get_debt_ceiling(TEST_RESERVE_ASSET);
    assert debt_ceiling = 0;
    ReserveConfiguration.set_debt_ceiling(TEST_RESERVE_ASSET, 10);
    let (debt_ceiling) = ReserveConfiguration.get_debt_ceiling(TEST_RESERVE_ASSET);
    assert debt_ceiling = 10;
    return ();
}

@external
func test_liquidation_protocol_fee{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) {
    let (liquidation_protocol_fee) = ReserveConfiguration.get_liquidation_protocol_fee(
        TEST_RESERVE_ASSET
    );
    assert liquidation_protocol_fee = 0;
    ReserveConfiguration.set_liquidation_protocol_fee(TEST_RESERVE_ASSET, 10);
    let (liquidation_protocol_fee) = ReserveConfiguration.get_liquidation_protocol_fee(
        TEST_RESERVE_ASSET
    );
    assert liquidation_protocol_fee = 10;
    return ();
}

@external
func test_unbacked_mint_cap{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    let (unbacked_mint_cap) = ReserveConfiguration.get_unbacked_mint_cap(TEST_RESERVE_ASSET);
    assert unbacked_mint_cap = 0;
    ReserveConfiguration.set_unbacked_mint_cap(TEST_RESERVE_ASSET, 10);
    let (unbacked_mint_cap) = ReserveConfiguration.get_unbacked_mint_cap(TEST_RESERVE_ASSET);
    assert unbacked_mint_cap = 10;
    return ();
}

@external
func test_eMode_category{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    let (eMode_category) = ReserveConfiguration.get_eMode_category(TEST_RESERVE_ASSET);
    assert eMode_category = 0;
    ReserveConfiguration.set_eMode_category(TEST_RESERVE_ASSET, 10);
    let (eMode_category) = ReserveConfiguration.get_eMode_category(TEST_RESERVE_ASSET);
    assert eMode_category = 10;
    return ();
}

struct Flags {
    active: felt,
    frozen: felt,
    borrowing_enabled: felt,
    stable_rate_borrowing_enabled: felt,
    paused: felt,
}

@external
func test_get_flags{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    ReserveConfiguration.set_active(TEST_RESERVE_ASSET, 1);
    ReserveConfiguration.set_frozen(TEST_RESERVE_ASSET, 1);
    ReserveConfiguration.set_borrowing_enabled(TEST_RESERVE_ASSET, 1);
    ReserveConfiguration.set_stable_rate_borrowing_enabled(TEST_RESERVE_ASSET, 1);
    ReserveConfiguration.set_paused(TEST_RESERVE_ASSET, 1);
    let res = ReserveConfiguration.get_flags(TEST_RESERVE_ASSET);
    let flags = Flags(res[0], res[1], res[2], res[3], res[4]);
    assert flags = Flags(1, 1, 1, 1, 1);
    return ();
}

struct Params {
    ltv: felt,
    liquidation_threshold: felt,
    liquidation_bonus: felt,
    decimals: felt,
    reserve_factor: felt,
    eMode_category: felt,
}

@external
func test_params{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    ReserveConfiguration.set_ltv(TEST_RESERVE_ASSET, 10);
    ReserveConfiguration.set_liquidation_threshold(TEST_RESERVE_ASSET, 20);
    ReserveConfiguration.set_liquidation_bonus(TEST_RESERVE_ASSET, 30);
    ReserveConfiguration.set_decimals(TEST_RESERVE_ASSET, 18);
    ReserveConfiguration.set_reserve_factor(TEST_RESERVE_ASSET, 20);
    ReserveConfiguration.set_eMode_category(TEST_RESERVE_ASSET, 3);
    let res = ReserveConfiguration.get_params(TEST_RESERVE_ASSET);
    let params = Params(res[0], res[1], res[2], res[3], res[4], res[5]);
    assert params = Params(10, 20, 30, 18, 20, 3);
    return ();
}

@external
func test_caps{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    ReserveConfiguration.set_borrow_cap(TEST_RESERVE_ASSET, 1000);
    ReserveConfiguration.set_supply_cap(TEST_RESERVE_ASSET, 10000);
    let (borrow_cap, supply_cap) = ReserveConfiguration.get_caps(TEST_RESERVE_ASSET);
    assert borrow_cap = 1000;
    assert supply_cap = 10000;
    return ();
}
