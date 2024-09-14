// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BasicMath {

    // Function to add two uint values
    function adder(uint _a, uint _b) public pure returns (uint sum, bool error) {
        // Initialize variables
        uint result = _a + _b;

        // Check for overflow
        if (result < _a) {
            return (0, true);
        } else {
            return (result, false);
        }
    }

    // Function to subtract two uint values
    function subtractor(uint _a, uint _b) public pure returns (uint difference, bool error) {
        // Check for underflow
        if (_b > _a) {
            return (0, true);
        } else {
            return (_a - _b, false);
        }
    }
}
