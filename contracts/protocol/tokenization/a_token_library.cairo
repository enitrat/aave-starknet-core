%lang starknet

from starkware.cairo.common.bool import FALSE, TRUE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_not_equal
from starkware.cairo.common.uint256 import Uint256, uint256_eq
from starkware.starknet.common.syscalls import get_caller_address

from openzeppelin.token.erc20.IERC20 import IERC20
from openzeppelin.token.erc20.library import ERC20

from contracts.interfaces.i_pool import IPool
from contracts.protocol.libraries.helpers.bool_cmp import BoolCmp
from contracts.protocol.libraries.helpers.errors import Errors
from contracts.protocol.libraries.math.wad_ray_math import WadRayMath
from contracts.protocol.tokenization.base.incentivized_erc20_library import IncentivizedERC20

// from contracts.protocol.tokenization.base.scaled_balance_token_base import ScaledBalanceTokenBase

//
// Events
//

@event
func Transfer(from_: felt, to: felt, value: Uint256) {
}

@event
func BalanceTransfer(from_: felt, to: felt, amount: Uint256, index: Uint256) {
}

@event
func Initialized(
    underlying_asset: felt,
    pool: felt,
    treasury: felt,
    incentives_controller: felt,
    a_token_decimals: felt,
    a_token_name: felt,
    a_token_symbol: felt,
) {
}

//
// Storage
//

@storage_var
func AToken_treasury() -> (res: felt) {
}

@storage_var
func AToken_underlying_asset() -> (res: felt) {
}

// should be defined in IncentivizedERC20
@storage_var
func AToken_pool() -> (res: felt) {
}

// should be defined in IncentivizedERC20
@storage_var
func AToken_incentives_controller() -> (res: felt) {
}

namespace AToken {
    // Authorization

    func assert_only_pool{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
        alloc_locals;
        let (caller_address) = get_caller_address();
        let (pool) = POOL();
        let error_code = Errors.CALLER_MUST_BE_POOL;
        with_attr error_message("{error_code}") {
            assert pool = caller_address;
        }
        return ();
    }

    func assert_only_pool_admin{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
        assert TRUE = FALSE;
        return ();
    }

    // Externals

    func initializer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        pool: felt,
        treasury: felt,
        underlying_asset: felt,
        incentives_controller: felt,
        a_token_decimals: felt,
        a_token_name: felt,
        a_token_symbol: felt,
    ) {
        // IncentivizedERC20.initialize(...)
        // assert pool = IncentivizedERC20.POOL()

        ERC20.initializer(a_token_name, a_token_symbol, a_token_decimals);

        AToken_treasury.write(treasury);
        AToken_underlying_asset.write(underlying_asset);
        AToken_incentives_controller.write(incentives_controller);
        AToken_pool.write(pool);

        Initialized.emit(
            underlying_asset,
            pool,
            treasury,
            incentives_controller,
            a_token_decimals,
            a_token_name,
            a_token_symbol,
        );
        return ();
    }

    // func mint{
    //         syscall_ptr : felt*,
    //         pedersen_ptr : HashBuiltin*,
    //         range_check_ptr
    //     }(caller : felt, on_behalf_of : felt, amount : Uint256, index : Uint256) -> (success: felt):
    //     assert_only_pool()
    //     ScaledBalanceTokenBase._mint_scaled(caller, on_behalf_of, amount, index);
    //     return ()
    // end

    // TODO: remove this once mint function above works
    func mint{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        caller: felt, on_behalf_of: felt, amount: Uint256, index: Uint256
    ) {
        assert_only_pool();
        ERC20._mint(on_behalf_of, amount);
        return ();
    }

    // func burn{
    //         syscall_ptr : felt*,
    //         pedersen_ptr : HashBuiltin*,
    //         range_check_ptr
    //     }(from_ : felt, receiver_or_underlying : felt, amount : Uint256, index : Uint256) -> (success: felt):
    //     assert_only_pool()
    //     ScaledBalanceTokenBase._burn_scaled(from_, receiver_or_underlying, amount, index);
    //     let (contract_address) = get_contract_address()
    //     if (receiver_or_underlying != contract_address):
    //         IERC20.transfer(_underlying_asset.read(), receiver_or_underlying, amount)
    //     end
    //     return ()
    // end

    func burn{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        from_: felt, receiver_or_underlying: felt, amount: Uint256, index: Uint256
    ) -> (success: felt) {
        alloc_locals;
        assert_only_pool();
        let (local underlying) = UNDERLYING_ASSET_ADDRESS();
        ERC20._burn(from_, amount);
        IERC20.transfer(underlying, receiver_or_underlying, amount);
        return (TRUE,);
    }

    // func mint_to_treasury(amount : Uint256, index : Uint256) {
    //     assert_only_pool()
    //     if (amount == 0):
    //         return ()
    //     end
    //     ScaledBalanceTokenBase._mint_scaled(_POOL.read(), _treasury, amount, index)
    // end

    func transfer_on_liquidation{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        from_: felt, to: felt, value: Uint256
    ) {
        alloc_locals;
        assert_only_pool();
        _transfer_base(from_, to, value, FALSE);
        Transfer.emit(from_, to, value);
        return ();
    }

    func balance_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        user: felt
    ) -> (balance: Uint256) {
        alloc_locals;
        let (balance_scaled) = ERC20.balance_of(user);
        let (pool) = POOL();
        let (underlying) = UNDERLYING_ASSET_ADDRESS();
        let (liquidity_index) = IPool.get_reserve_normalized_income(pool, underlying);
        let balance = WadRayMath.ray_mul(balance_scaled, liquidity_index);
        return (balance,);
    }

    func total_supply{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        supply: Uint256
    ) {
        alloc_locals;
        let (current_supply_scaled) = IncentivizedERC20.total_supply();
        let (is_zero) = uint256_eq(current_supply_scaled, Uint256(0, 0));
        if (is_zero == TRUE) {
            return (supply=Uint256(0, 0));
        }
        let (pool) = AToken_pool.read();
        let (asset) = AToken_underlying_asset.read();
        let (rate) = IPool.get_reserve_normalized_income(pool, asset);
        let supply = WadRayMath.ray_mul(current_supply_scaled, rate);
        return (supply,);
    }

    func transfer_underlying_to{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        target: felt, amount: Uint256
    ) {
        alloc_locals;
        assert_only_pool();
        let (underlying) = UNDERLYING_ASSET_ADDRESS();
        IERC20.transfer(contract_address=underlying, recipient=target, amount=amount);
        return ();
    }

    // func handle_repayment{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    //     assert_only_pool()
    //     return ()
    // end

    // func permit{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    // end

    func rescue_tokens{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        token: felt, to: felt, amount: Uint256
    ) {
        alloc_locals;
        assert_only_pool_admin();
        let (underlying) = UNDERLYING_ASSET_ADDRESS();
        let error_code = Errors.UNDERLYING_CANNOT_BE_RESCUED;
        with_attr error_message("{error_code}") {
            assert_not_equal(token, underlying);
        }
        IERC20.transfer(contract_address=token, recipient=to, amount=amount);
        return ();
    }

    // Getters

    func RESERVE_TREASURY_ADDRESS{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        ) -> (res: felt) {
        let (res) = AToken_treasury.read();
        return (res,);
    }

    func UNDERLYING_ASSET_ADDRESS{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        ) -> (res: felt) {
        let (res) = AToken_underlying_asset.read();
        return (res,);
    }

    func POOL{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (res: felt) {
        let (res) = AToken_pool.read();
        return (res,);
    }

    func get_incentives_controller{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        ) -> (res: felt) {
        let (controller) = AToken_incentives_controller.read();
        return (controller,);
    }

    // func DOMAIN_SEPARATOR{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    // end

    // func nonces{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    // end

    // func _EIP712BaseId{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    // end

    // Internals

    func _transfer_base{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        from_: felt, to: felt, amount: Uint256, validate: felt
    ) {
        alloc_locals;

        BoolCmp.is_valid(validate);

        let (pool) = POOL();
        let (underlying_asset) = UNDERLYING_ASSET_ADDRESS();
        let (index) = IPool.get_reserve_normalized_income(pool, underlying_asset);

        let (from_scaledbalance_before) = ERC20.balance_of(from_);
        let from_balance_before = WadRayMath.ray_mul(from_scaledbalance_before, index);
        let (to_scaledbalance_before) = ERC20.balance_of(to);
        let to_balance_before = WadRayMath.ray_mul(to_scaledbalance_before, index);

        let amount_over_index = WadRayMath.ray_div(amount, index);
        ERC20._transfer(from_, to, amount_over_index);

        if (validate == TRUE) {
            IPool.finalize_transfer(
                pool, underlying_asset, from_, to, amount, from_balance_before, to_balance_before
            );
            tempvar syscall_ptr = syscall_ptr;
            tempvar pedersen_ptr = pedersen_ptr;
            tempvar range_check_ptr = range_check_ptr;
        } else {
            tempvar syscall_ptr = syscall_ptr;
            tempvar pedersen_ptr = pedersen_ptr;
            tempvar range_check_ptr = range_check_ptr;
        }

        BalanceTransfer.emit(from_, to, amount, index);
        return ();
    }

    func _transfer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        from_: felt, to: felt, amount: Uint256
    ) {
        _transfer_base(from_, to, amount, TRUE);
        return ();
    }
}
