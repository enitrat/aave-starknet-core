%lang starknet

@contract_interface
namespace IMockInitializableImplementation {
    func initialize(val: felt, txt: felt) {
    }

    func get_revision() -> (revision: felt) {
    }

    func get_value() -> (value: felt) {
    }

    func get_text() -> (text: felt) {
    }
}

@contract_interface
namespace IMockInitializableReentrantImplementation {
    func initialize(val: felt) {
    }

    func get_value() -> (value: felt) {
    }

    func get_text() -> (text: felt) {
    }
}
