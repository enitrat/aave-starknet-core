from starkware.cairo.common.math_cmp import is_le_felt
from starkware.cairo.common.math import assert_le_felt, assert_lt_felt
from starkware.cairo.common.bool import FALSE, TRUE
from contracts.protocol.libraries.helpers.bool_cmp import BoolCompare

# @notice Function checks if the a < b. Interprets a, b in range [0, P)
# @dev Internal function meant to only be used by functions of SafeCmp library
# @param a Unsigned felt integer
# @param b Unsigned felt integer
# @returns res Bool felt indicating if a < b
func _is_lt_felt{range_check_ptr}(a : felt, b : felt) -> (res : felt):
    if a == b:
        return (FALSE)
    end
    return is_le_felt(a, b)
end

# @notice Library to safely compare felts interpreted as unsigned or signed integers.
#
#         Motivation:
#         Cairo felts represent signed or unsigned integers.
#         To compare unsigned integers developers can use: is_le_felt, assert_le_felt from math_cmp and math library
#         However, currently there is no safe way to compare felts interpreted as signed integers.
#         Developer when working with signed integers tend to use functions: is_le, assert_le, is_nn, assert_nn.
#         This is not safe, because those functions work in range [0, 2**128) and should only be used with context of Uint256 type (with low and high members)
#         Functions provided in this library allow for safe work with felts interpreted as signed and unsigned integers, outside of Uint256 context.
#
# @author Nethermind
namespace SafeCmp:
    #
    #
    # CONSTANTS
    #
    #

    # P - the prime number defined in Cairo documentation. Every artithmetic operation is done with mod P.
    # NOTE: This number shouldn't change for StartkNet, but if you are using Cairo with other P, please adjust this number to your needs.
    const P = 2 ** 251 + 17 * 2 ** 192 + 1  # 3618502788666131213697322783095070105623107215331596699973092056135872020481 == 0
    # signed_MIN - the lowest number possible in Cairo if felts are interpreted as signed integers.
    # (Recall : floor(P/2) = (P-1)/2)
    # (P-1/2) is done to be able to express floor(P/2) (no floor function in Cairo)
    # +1 is added, because (P-1/2): highest signed integer and (P-1/2)+1: lowest signed integer
    const signed_MIN = ((P - 1) / 2) + 1  # as signed: -1809251394333065606848661391547535052811553607665798349986546028067936010240 or as unsigned: 1809251394333065606848661391547535052811553607665798349986546028067936010241

    #
    #
    # UNSIGNED FELTS
    #
    #

    # @notice Checks if the a <= b. Interprets a, b in range [0, P)
    # @param a Unsigned felt integer
    # @param b Unsigned felt integer
    # @returns res Bool felt indicating if a <= b
    func is_le_unsigned{range_check_ptr}(a : felt, b : felt) -> (res : felt):
        return is_le_felt(a, b)
    end

    # @notice Checks if the a < b. Interprets a, b in range [0, P)
    # @param a Unsigned felt integer
    # @param b Unsigned felt integer
    # @returns res Bool felt indicating if a < b
    func is_lt_unsigned{range_check_ptr}(a : felt, b : felt) -> (res : felt):
        return _is_lt_felt(a, b)
    end

    # @notice Checks if the vale is in range [low, high). Interprets value, low, high in range [0, P)
    # @param value Unsigned felt integer, checked if is in range
    # @param low Unsigned felt integer, lower bound of the range
    # @param high Unsigned felt integer, upper bound of the range
    # @returns res Bool felt indicating if low <= value < high
    func is_in_range_unsigned{range_check_ptr}(value : felt, low : felt, high : felt) -> (
        res : felt
    ):
        alloc_locals
        with_attr error_message("Range definition error: low >= high"):
            let (check) = _is_lt_felt(low, high)
            assert check = TRUE
        end
        let (ok_low) = is_le_felt(low, value)
        let (ok_high) = _is_lt_felt(value, high)
        let (res) = BoolCompare.both(ok_low, ok_high)
        return (res)
    end

    # @notice Asserts that a <= b. Interprets a, b in range [0, P)
    # @param a Unsigned felt integer
    # @param b Unsigned felt integer
    func assert_le_unsigned{range_check_ptr}(a : felt, b : felt):
        assert_le_felt(a, b)
        return ()
    end

    # @notice Asserts that a < b. Interprets a, b in range [0, P)
    # @param a Unsigned felt integer
    # @param b Unsigned felt integer
    func assert_lt_unsigned{range_check_ptr}(a : felt, b : felt):
        assert_lt_felt(a, b)
        return ()
    end

    # @notice Asserts that the value is in range [low, high). Interprets value, low, high in range [0, P)
    # @param value Unsigned felt integer, checked if is in range
    # @param low Unsigned felt integer, lower bound of the range
    # @param high Unsigned felt integer, upper bound of the range
    func assert_in_range_unsigned{range_check_ptr}(value : felt, low : felt, high : felt):
        alloc_locals
        with_attr error_message("Range definition error: low >= high"):
            let (check) = _is_lt_felt(low, high)
            assert check = TRUE
        end
        let (ok_low) = is_le_felt(low, value)
        let (ok_high) = _is_lt_felt(value, high)
        assert ok_low * ok_high = TRUE
        return ()
    end

    #
    #
    # SIGNED FELTS
    #
    #

    # @notice Checks if the value is non-negative integer, i.e. 0 <= value < floor(P/2) + 1. Interprets a in range [floor(-P/2), floor(P/2)]
    # @dev Note that floor(-P/2) is equal to floor(P/2) + 1. If felt is signed, then negative numbers are [floor(P/2)+1, P-1]
    # @param a Signed felt integer
    # @returns res Bool felt indicating if 0 <= value < floor(P/2) + 1 (Recall : floor(P/2) = (P-1)/2)
    func is_nn_signed{range_check_ptr}(value : felt) -> (res : felt):
        return _is_lt_felt(value, signed_MIN)
    end

    # @notice Checks if the a <= b. Interprets a, b in range [floor(-P/2), floor(P/2)] (Recall : floor(P/2) = (P-1)/2)
    # @dev Note that floor(-P/2) is equal to floor(P/2) + 1. If felt is signed, then negative numbers are [floor(P/2)+1, P-1], and non-negative [0(P), floor(P/2)]
    # @param a Signed felt integer
    # @param b Signed felt integer
    # @returns res Bool felt indicating if a <= b
    func is_le_signed{range_check_ptr}(a : felt, b : felt) -> (res : felt):
        return is_le_felt(a + (P - 1) / 2, b + (P - 1) / 2)
    end

    # @notice Checks if the a < b. Interprets a, b in range [floor(-P/2), floor(P/2)]
    # @dev Note that floor(-P/2) is equal to floor(P/2) + 1. If felt is signed, then negative numbers are [floor(P/2)+1, P-1], and non-negative [P, floor(P/2)]
    # @param a Signed felt integer
    # @param b Signed felt integer
    # @returns res Bool felt indicating if a < b
    func is_lt_signed{range_check_ptr}(a : felt, b : felt) -> (res : felt):
        return _is_lt_felt(a + (P - 1) / 2, b + (P - 1) / 2)
    end

    # @notice Checks if the [low, high). Interprets value, low, high in range [floor(-P/2), floor(P/2)]
    # @dev Note that floor(-P/2) is equal to floor(P/2) + 1. If felt is signed, then negative numbers are [floor(P/2)+1, P-1], and non-negative [P, floor(P/2)]
    # @param value Signed felt integer, checked if is in range
    # @param low Signed felt integer, lower bound of the range
    # @param high Signed felt integer, upper bound of the range
    # @returns res Bool felt indicating if value is in [low, high) range
    func is_in_range_signed{range_check_ptr}(value : felt, low : felt, high : felt) -> (res : felt):
        return is_in_range_unsigned(value + (P - 1) / 2, low + (P - 1) / 2, high + (P - 1) / 2)
    end

    # @notice Asserts that a is non-negative integer, i.e. 0 <= a < floor(P/2) + 1. Interprets a in range [floor(-P/2), floor(P/2)]
    # @dev Note that floor(-P/2) is equal to floor(P/2) + 1. If felt is signed, then negative numbers are [floor(P/2)+1, P-1]
    # @param a Signed felt integer
    func assert_nn_signed{range_check_ptr}(value : felt):
        assert_lt_felt(value, signed_MIN)
        return ()
    end

    # @notice Asserts that a <= b. Interprets a, b in range [floor(-P/2), floor(P/2)]
    # @dev Note that floor(-P/2) is equal to floor(P/2) + 1. If felt is signed, then negative numbers are [floor(P/2)+1, P-1], and non-negative [P, floor(P/2)]
    # @param a Signed felt integer
    # @param b Signed felt integer
    func assert_le_signed{range_check_ptr}(a : felt, b : felt):
        assert_le_felt(a + (P - 1) / 2, b + (P - 1) / 2)
        return ()
    end

    # @notice Asserts that a < b. Interprets a, b in range [floor(-P/2), floor(P/2)]
    # @dev Note that floor(-P/2) is equal to floor(P/2) + 1. If felt is signed, then negative numbers are [floor(P/2)+1, P-1], and non-negative [P, floor(P/2)]
    # @param a Signed felt integer
    # @param b Signed felt integer
    func assert_lt_signed{range_check_ptr}(a : felt, b : felt):
        assert_lt_felt(a + (P - 1) / 2, b + (P - 1) / 2)
        return ()
    end

    # @notice Asserts that the value is in [low, high). Interprets value, low, high in range [floor(-P/2), floor(P/2)]
    # @dev Note that floor(-P/2) is equal to floor(P/2) + 1. If felt is signed, then negative numbers are [floor(P/2)+1, P-1], and non-negative [P, floor(P/2)]
    # @param value Signed felt integer, checked if is in range
    # @param low Signed felt integer, lower bound of the range
    # @param high Signed felt integer, upper bound of the range
    func assert_in_range_signed{range_check_ptr}(value : felt, low : felt, high : felt):
        assert_in_range_unsigned(value + (P - 1) / 2, low + (P - 1) / 2, high + (P - 1) / 2)
        return ()
    end
end
