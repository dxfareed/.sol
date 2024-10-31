//SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

contract FundMe{
    mapping ( address => uint) storeAmount;
    function fund() public payable {
        storeAmount[msg.sender]= msg.value;
        require(msg.value < 1e18, "token not enough");
    }
    function returnAddresAmount() public view returns(uint){
        return storeAmount[msg.sender];
    }
    function withDraw() public{
        payable (msg.sender).transfer(address(this).balance);
    }
}

