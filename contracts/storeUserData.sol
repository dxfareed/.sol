//SPDX-License-Identifier: MIT
//
pragma solidity ^0.8.17;

contract StoreUserData{
//0x52c043C7120d7DA35fFdDF6C5c2359d503ceE5F8
    struct Person{
        string name;
        string gender;
        uint age;
        string uid;
    }
    string[] uids;
    address[] addressOfEchUser;
    mapping ( address => Person) People;
    function addUser(string memory _name, string memory _gender, uint _age,  string memory _uid) external {
        People[msg.sender]=Person(_name, _gender, _age, _uid);
        uids.push(_uid);
        addressOfEchUser.push(msg.sender);
    }
    function showWitUId(string memory _uid) external view returns(string memory iiS, address zz){
        for(uint i; i<uids.length; i++){
            if( keccak256(abi.encodePacked(uids[i])) == keccak256(abi.encodePacked(_uid))){
                //return "hello there we made it !";
                return( People[addressOfEchUser[i]].name, addressOfEchUser[i]);
            }
        }
         return ("not found", msg.sender);
    }
    //,string memory, uint
   /* function getUser( address _addrr) external view returns(string memory,string memory, uint){
        return (People[_addrr].name, People[_addrr].gender, People[_addrr].age) ;
        //return People[_addrr];
    }*/
}
