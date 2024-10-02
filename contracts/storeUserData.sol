//SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

contract StoreUserData{
    struct Person{
        string name;
        string gender;
        uint age;
    }
    mapping ( address => Person) People;
    function addUser(string memory _name, string memory _gender, uint _age) external {
        People[msg.sender]=Person(_name, _gender, _age);
    }
    //,string memory, uint
    function getUser( address _addrr) external view returns(string memory,string memory, uint){
        return (People[_addrr].name, People[_addrr].gender, People[_addrr].age) ;
        //return People[_addrr];
    }
}
