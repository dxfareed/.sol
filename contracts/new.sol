//SPDX-License-Identifier:MIT
pragma solidity >=0.8.0;
contract Complimenter{
    string name;
    constructor(string memory _name){
        name=_name;
    }
    function complimnt() external view returns (string memory){
        return string.concat("how are you doing ", name);
    }        
}
contract FactoryCompliment{
    function createComplim(string memory _name) external returns(address){
        Complimenter newComplimnt=new Complimenter(_name);
        return address(newComplimnt);

    }
}