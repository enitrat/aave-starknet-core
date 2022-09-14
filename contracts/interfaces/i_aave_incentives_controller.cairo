%lang starknet

from starkware.cairo.common.uint256 import Uint256

@contract_interface
namespace IAaveIncentivesController {
    func get_asset_data() -> (index: felt, emissions_per_second: felt, timestamp: felt) {
    }

    func set_claimer(claimer: felt) -> () {
    }

    func get_claimer() -> (claimer: felt) {
    }

    func configure_assets(
        assets_len: felt, assets: felt*, emissions_per_second_len: felt, emissions_per_second: felt*
    ) -> () {
    }

    func handle_action(account: felt, user_balance: Uint256, total_supply: Uint256) -> (
        rewards: felt
    ) {
    }

    func get_rewards_balance(assets_len: felt, assets: felt*, user: felt) {
    }

    func claim_rewards(assets_len: felt, assets: felt*, amount: felt, to: felt) -> (rewards: felt) {
    }

    func claim_rewards_on_behalf(
        assets_len: felt, assets: felt*, amount: felt, user: felt, to: felt
    ) -> (rewards: felt) {
    }

    func get_user_unclaimed_rewards(user: felt) -> (rewards: felt) {
    }

    func get_user_asset_data(user: felt, asset: felt) -> (index: felt) {
    }

    func REWARD_TOKEN() -> (address: felt) {
    }

    func DISTRIBUTION_END() -> (address: felt) {
    }
}
