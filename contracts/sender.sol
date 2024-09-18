//SPDX-License-Identifier: MIT

pragma solidity >=0.8.0;

contract checkOwner{
    address owner;
    constructor(){
        owner=msg.sender;
    }
    error InavlidOwner(address);
    modifier onlyOwner{
        if(msg.sender!=owner){
            revert InavlidOwner(msg.sender);
        }
        _;
    }
    function changeUser(string memory name) external view  onlyOwner returns (string memory,string memory,string memory){
        return ("only ",name, "can edit this");
    }
}