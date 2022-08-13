%lang starknet

@contract_interface
namespace IProxy:
    func initialize(
        implementation_class_hash : felt, selector : felt, calldata_len : felt, calldata : felt*
    ) -> (retdata_len : felt, retdata : felt*):
    end

    func upgrade_to_and_call(
        implementation_class_hash : felt, selector : felt, calldata_len : felt, calldata : felt*
    ) -> (retdata_len : felt, retdata : felt*):
    end

    func upgrade_to(implementation_class_hash : felt):
    end

    func get_admin() -> (admin : felt):
    end

    func get_implementation() -> (implementation : felt):
    end

    func change_proxy_admin(new_admin : felt):
    end
end
