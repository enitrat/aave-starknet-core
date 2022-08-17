%lang starknet

@contract_interface
namespace IPriceOracleGetter:
    func BASE_CURRENCY() -> (address : felt):
    end

    func BASE_CURRENCY_UNIT() -> (base : felt):
    end

    func get_asset_price(asset : felt) -> (asset_price : felt):
    end
end
