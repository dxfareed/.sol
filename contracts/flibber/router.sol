// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "@chainlink/contracts/src/v0.8/ccip/interfaces/IRouterClient.sol";
import "@chainlink/contracts/src/v0.8/ccip/libraries/Client.sol";

contract MockRouter is IRouterClient {
    // Mock state variables to track calls
    bool public isEnabled = true;
    mapping(bytes32 => Client.EVM2AnyMessage) public sentMessages;
    
    error RouterDisabled();
    constructor() {}

    // Implement getFee as before
    function getFee(
        uint64,  // destinationChainSelector
        Client.EVM2AnyMessage calldata  // message
    ) external pure returns (uint256) {
        return 0.01 ether;
    }

    // Implement ccipSend with basic validation
    function ccipSend(
        uint64,  // destinationChainSelector
        Client.EVM2AnyMessage calldata message
    ) external payable returns (bytes32) {
        if (!isEnabled) revert RouterDisabled();
        
        // Generate a deterministic messageId based on inputs
        bytes32 messageId = keccak256(
            abi.encode(
                msg.sender,
                message,
                block.timestamp
            )
        );
        
        // Store the message for potential verification
        sentMessages[messageId] = message;
        
        return messageId;
    }

    // Implement isChainSupported from IRouterClient
    function isChainSupported(uint64) external pure returns (bool) {
        return true; // Mock always returns true for testing
    }

    // Additional helper functions for testing
    function toggleRouter() external {
        isEnabled = !isEnabled;
    }

    function getSentMessage(bytes32 messageId) 
        external 
        view 
        returns (Client.EVM2AnyMessage memory) 
    {
        return sentMessages[messageId];
    }
}
