//SPDX-License-Identifier: MIT

pragma solidity >= 0.8.17;

contract CreateMe{
    string name;
    address nmowner;
    constructor(string memory _name, address _owner){
        name = _name;
        nmowner = _owner;
    }
    function HelloMessage() external view returns(string memory){
        require(msg.sender== nmowner, "not owner!");
        return (string.concat("hello ",name));
    }
}
contract createMessageMore{
    CreateMe hello;
    address _owner_= msg.sender;
    function creator(string memory _name) external returns(address){
        hello = new CreateMe(_name, _owner_);
        return address(hello);
    }
}