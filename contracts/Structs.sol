//SPDX-License-Identifier: MIT

pragma solidity >=0.8.0;

contract Struct{
    struct Person{
        string name;
        uint8 age;
        bool exists;
    }
    mapping(address => Person) public assignPerson;
    function sstrFunc(string memory name, uint8 age) external{
        assignPerson[msg.sender]=Person(name,age, true);
        //return assignPerson[msg.sender].age;
    }
    error NotFound(address);
    function showMessage(string memory option, address addr) external view returns(string memory name, uint8){
        if(!assignPerson[addr].exists){
            revert NotFound(addr);
        }
        else if(keccak256(abi.encodePacked(option))==keccak256(abi.encodePacked("name"))){
            string memory rtrName=assignPerson[addr].name;
            return (rtrName, 0);
        }
        else if(keccak256(abi.encodePacked(option))==keccak256(abi.encodePacked("age"))){
            uint8 rtrAge=assignPerson[addr].age;
            return ("", rtrAge);        
        }
        else {
            return ("pick a option", 0);
        }
    }
}