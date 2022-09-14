struct PriceTick {
    asset: felt,
    value: felt,
    timestamp: felt,
    publisher: felt,
    type: felt,
}
struct PriceAggregate {
    asset: felt,
    median: felt,
    variance: felt,
    quorum: felt,
    liquidity: felt,
    timestamp: felt,
}
