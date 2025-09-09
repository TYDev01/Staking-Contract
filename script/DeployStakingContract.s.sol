// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// import {Script, console} from "forge-std/Script.sol";
import "forge-std/Script.sol";

import {StakingToken} from "../src/StakingToken.sol";
import {StakingContract} from "../src/StakingContract.sol";

/**
 * @title DeployStakingContract
 * @dev Foundry deployment script for the StakingContract.
 * This script deploys the StakingContract using configurable parameters.
 * It supports environment variables for flexibility (e.g., for different networks).
 * 
 * Usage:
 * 1. Set up your Foundry project with OpenZeppelin contracts installed via Forge:
 *    forge install OpenZeppelin/openzeppelin-contracts
 * 
 * 2. Environment Variables (optional, with defaults):
 *    - STAKING_TOKEN: Address of the ERC20 staking token (required, no default).
 *    - INITIAL_APR: Initial APR (e.g., 500 for 5%, default: 500).
 *    - MIN_LOCK_DURATION: Minimum lock duration in seconds (e.g., 2592000 for 30 days, default: 30 days).
 *    - APR_REDUCTION_PER_THOUSAND: APR reduction per 1,000 tokens staked (e.g., 10 for 0.1%, default: 10).
 *    - EMERGENCY_WITHDRAW_PENALTY: Penalty percentage for emergency withdraw (e.g., 10 for 10%, default: 10).
 *    - PRIVATE_KEY: The private key for the deployer account (required for broadcasting on non-local networks).
 * 
 * 3. Run the script:
 *    - Local (Anvil): forge script script/DeployStakingContract.s.sol --broadcast --rpc-url http://localhost:8545
 *    - Testnet/Mainnet: forge script script/DeployStakingContract.s.sol --broadcast --rpc-url $RPC_URL --private-key $PRIVATE_KEY
 * 
 *    Example with env vars:
 *    STAKING_TOKEN=0x... INITIAL_APR=500 forge script script/DeployStakingContract.s.sol ...
 * 
 * 4. After deployment, the script logs the contract address and key details.
 * 
 * Notes:
 * - Ensure the staking token exists on the target network.
 * - This script uses vm.broadcast() for transaction signing.
 * - For production, verify the contract on Etherscan/Blockscout using Forge verify.
 */

contract DeployStakingContract is Script {
    // Default values (can be overridden by env vars)
    uint256 constant DEFAULT_INITIAL_SUPPLY = 1_000_000 * 10**18; // 1M tokens with 18 decimals
    uint256 constant DEFAULT_INITIAL_APR = 500; // 5% APR
    uint256 constant DEFAULT_MIN_LOCK_DURATION = 2 days; // 2 days in seconds
    uint256 constant DEFAULT_APR_REDUCTION_PER_THOUSAND = 10; // 0.1% reduction per 1,000 tokens
    uint256 constant DEFAULT_EMERGENCY_WITHDRAW_PENALTY = 10; // 10% penalty

    function run() external {
        // Load environment variables
        uint256 initialSupply = vm.envOr("INITIAL_SUPPLY", DEFAULT_INITIAL_SUPPLY);
        uint256 initialApr = vm.envOr("INITIAL_APR", DEFAULT_INITIAL_APR);
        uint256 minLockDuration = vm.envOr("MIN_LOCK_DURATION", DEFAULT_MIN_LOCK_DURATION);
        uint256 aprReductionPerThousand = vm.envOr("APR_REDUCTION_PER_THOUSAND", DEFAULT_APR_REDUCTION_PER_THOUSAND);
        uint256 emergencyWithdrawPenalty = vm.envOr("EMERGENCY_WITHDRAW_PENALTY", DEFAULT_EMERGENCY_WITHDRAW_PENALTY);

        // Validate inputs
        require(initialSupply > 0, "INITIAL_SUPPLY must be greater than 0");

        // Start broadcasting transactions
        vm.startBroadcast();

        // Deploy StakingToken
        StakingToken stakingToken = new StakingToken(initialSupply);
        console.log("StakingToken deployed at:", address(stakingToken));
        console.log("Token Name:", stakingToken.name());
        console.log("Token Symbol:", stakingToken.symbol());
        console.log("Initial Supply:", initialSupply);

        // Deploy StakingContract with the token address
        StakingContract stakingContract = new StakingContract(
            address(stakingToken),
            initialApr,
            minLockDuration,
            aprReductionPerThousand,
            emergencyWithdrawPenalty
        );

        // Stop broadcasting
        vm.stopBroadcast();

        // Log StakingContract details
        console.log("StakingContract deployed at:", address(stakingContract));
        console.log("Staking Token:", address(stakingToken));
        console.log("Initial APR:", initialApr);
        console.log("Min Lock Duration (seconds):", minLockDuration);
        console.log("APR Reduction per Thousand:", aprReductionPerThousand);
        console.log("Emergency Withdraw Penalty (%):", emergencyWithdrawPenalty);
    }
}


