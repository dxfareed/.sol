// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "./flibberToken.sol";
import "./slotin.sol";

contract DeployFIB {
    // Network addresses for Base Sepolia
    address constant CCIP_ROUTER = 0xA8C0c11bf64AF62CDCA6f93D3769B88BdD7cb93D;
    address constant ETH_USD_PRICE_FEED = 0x4aDC67696bA383F43DD60A9e78F2C97Fbbfc7cb1;
    
    // Initial bridge fee (1 FIB token)
    uint256 constant INITIAL_BRIDGE_FEE = 1 * 1e18;

    function deploy() external returns (address, address) {
        // Deploy FIB Token
        FIBToken fibToken = new FIBToken(
            msg.sender,
            ETH_USD_PRICE_FEED
        );
        
        // Deploy Slotting Mechanism
        FIBSlottingMechanism slotting = new FIBSlottingMechanism(
            CCIP_ROUTER,
            address(fibToken),
            INITIAL_BRIDGE_FEE
        );
        
        // Add supported tokens to slotting mechanism
        slotting.addSupportedToken(address(fibToken), ETH_USD_PRICE_FEED); // FIB token
        slotting.addSupportedToken(address(0), ETH_USD_PRICE_FEED);       // ETH
        
        return (address(fibToken), address(slotting));
    }
}