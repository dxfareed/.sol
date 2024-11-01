//SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

contract Compliment{
    string name;
    constructor( string memory _name){
        name=_name;
    }
    function greetMessage() public view returns(string memory){
        return  string.concat("Nice to meet you ", name);
    }
}

contract FactoryCompliment{
    Compliment newCompliment;
    string public message;
    function createCompilment(string memory _name) public returns (string memory) {
        newCompliment= new Compliment(_name);
        message=newCompliment.greetMessage();
        return newCompliment.greetMessage();
    }
    function DisplayMessage() public view returns(string memory){

    }
}