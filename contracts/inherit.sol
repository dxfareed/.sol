//SPDX-License-Identifier:MIT

pragma solidity ^0.8.0;

contract Hello{
    function MessageA() external  pure returns(string memory message){
        return "hello world message 1";
    }
}
contract Hello2 is Hello{
    function MessageB() public pure returns(string memory message){
        return Hello.MessageA();
    }
}