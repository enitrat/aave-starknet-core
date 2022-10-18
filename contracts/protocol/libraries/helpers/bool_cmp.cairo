namespace BoolCmp {
    func is_valid(a: felt) {
        with_attr error_message("Value should be either 0 or 1. Current value: {a}") {
            assert a * a = a;
        }
        return ();
    }

    func eq(a: felt, b: felt) -> felt {
        if (a == b) {
            return 1;
        } else {
            return 0;
        }
    }

    func either(x: felt, y: felt) -> felt {
        assert x * x = x;
        assert y * y = y;
        let res = eq((x - 1) * (y - 1), 0);
        return res;
    }

    func both(x: felt, y: felt) -> felt {
        assert x * x = x;
        assert y * y = y;
        let res = eq((x + y), 2);
        return res;
    }

    func neither(x: felt, y: felt) -> felt {
        assert x * x = x;
        assert y * y = y;
        let res = eq((x + y), 0);
        return res;
    }

    func not(x: felt) -> felt {
        assert x * x = x;
        let res = (1 - x);
        return res;
    }
}
