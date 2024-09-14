//SPDX-License-Identifier:MIT

pragma solidity >=0.8.0;

contract Message{
    function showMessage() external pure returns (string memory){
        return "Hello, Chrome!";
    }
}