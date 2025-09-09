
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title StakingToken
 * @dev A simple fixed-supply ERC20 token for staking.
 */
contract StakingToken is ERC20 {
    /**
     * @param initialSupply The total supply to mint (use 18 decimals like other ERC20s).
     */
    constructor(uint256 initialSupply) ERC20("Staking Token", "STKK") {
        // Mint the full supply to the deployer
        _mint(msg.sender, initialSupply);
    }
}