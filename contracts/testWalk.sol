//SPDX-License-Identifier:MIT

pragma solidity >=0.8.0;

contract TestNameCollect{
    struct Person{
        string name;
        uint8 age;
    }
    mapping(address => Person[]) ListStoredPeople;
    error RevertWithme(string);

    function addEachPerson(string memory _name, uint8 _age ) external {
        ListStoredPeople[msg.sender].push(
            Person(_name, _age )
        );
    }
    function showPeople(address userAddress) external view returns(string memory, uint8) {
       /* if(People.length<=0){
            revert("Array empty, add params");
        }
        return (People[0].name,People[0].age);
        */
        if(ListStoredPeople[userAddress].length<=0){
            revert("User not found");
        }
        uint8 ageHere=ListStoredPeople[userAddress][0].age;
        string memory nmae=ListStoredPeople[userAddress][0].name;  
        return (nmae, ageHere); 
    }
}