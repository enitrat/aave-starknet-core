from starkware.cairo.common.uint256 import Uint256
from contracts.protocol.libraries.types.data_types import DataTypes

const UINT128_MAX = 2 ** 128 - 1
const INITIALIZE_SELECTOR = 215307247182100370520050591091822763712463273430149262739280891880522753123

func empty_reserve_configuration() -> (res : DataTypes.ReserveConfiguration):
    return (DataTypes.ReserveConfiguration(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
end

func empty_reserve_data() -> (res : DataTypes.ReserveData):
    let (empty_config) = empty_reserve_configuration()
    return (DataTypes.ReserveData(empty_config, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
end

func uint256_max() -> (max : Uint256):
    return (Uint256(UINT128_MAX, UINT128_MAX))
end
