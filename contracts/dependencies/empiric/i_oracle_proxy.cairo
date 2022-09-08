%lang starknet

namespace EmpiricAggregationModes:
    const MEDIAN = 120282243752302  # str_to_felt("median")
end

@contract_interface
namespace IEmpiricOracle:
    #
    # Getters
    #

    # @notice This function looks up the aggregate value for an entry using all sources
    # @param key: key to lookup entry for
    # @param aggregation_mode: method to use for aggregate value
    # @return value: value for entry
    # @return decimals: number of decimals of precision
    # @return last_updated timestamp: timestamp of last update
    # @return num_sources_aggregated: number of sources used in predicted value
    func get_value(key : felt, aggregation_mode : felt) -> (
        value : felt, decimals : felt, last_updated_timestamp : felt, num_sources_aggregated : felt
    ):
    end

    # @notice This function lets the caller specify a list of sources to use for the aggregate entity value
    # @param key: key to lookup entry for
    # @param aggregation_mode: method to use for aggregate value
    # @param sources_len: length of the sources array
    # @param sources: sources to use for the data lookup
    # @return value: value for entry
    # @return decimals: number of decimals of precision
    # @return last_updated timestamp: timestamp of last update
    # @return num_sources_aggregated: number of sources used in predicted value
    func get_value_for_sources(
        key : felt, aggregation_mode : felt, sources_len : felt, sources : felt*
    ) -> (
        value : felt, decimals : felt, last_updated_timestamp : felt, num_sources_aggregated : felt
    ):
    end
end
