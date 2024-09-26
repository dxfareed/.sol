//SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "https://github.com/dxfareed/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract AddressBook is Ownable{
    struct Contact{
        uint id;
        string firstName;
        string lastName;
        uint phoneNumbers;
    }
    error ContactNotFound(uint);
    //constructor()Ownable(msg.sender){}
    //address iowner;

    constructor(address _owner)Ownable(_owner){
       // iowner = _owner;
    }
    Contact[]  contacts;
    function addContact(uint _id,string memory _firstName,string memory _lastName,uint _phoneNumbers) external onlyOwner {
        contacts.push(
            Contact(_id, _firstName, _lastName, _phoneNumbers)
        );
    }
    function deleteContact(uint _id) external onlyOwner /*returns(uint _ii)*/ {
       for(uint i=0; i<contacts.length; i++){
             if(contacts[i].id==_id){
                delete contacts[i];
                return;
            }
        }
        revert ContactNotFound(_id);
       //return contacts[0].id;
       /* for(uint i=0; i<contacts.length; i++){
            if(contacts[i].id==_id){
                delete contacts[i];
                break;
            }
        }
        revert ContactNotFound(_id);*/
    }
    function getContact(uint _id) private  view returns(Contact memory) {
        for(uint i=0; i<contacts.length; i++){
             if(contacts[i].id==_id){
                return contacts[i];
                //contacts has not getter function bcus by default the visibility is internal
            }
        }
        revert ContactNotFound(_id);
    }
    function getAllContacts() private view returns(Contact[] memory){
        return contacts;
    }

    /*function returnArry() external view returns(Contact[] memory){
        return contacts;
    }*/
}
contract AddressBookFactory{
    function deploy() external returns(address){
        AddressBook createAddressBook= new AddressBook(msg.sender);
        return address(createAddressBook);
    }
}

/*contract FactoryMaker{
    address caller;
    constructor(){
        caller=msg.sender;
    }
    function createNew(string memory _name) external returns(address){
      AddressBook newAddressBook = new AddressBook(_name, caller);
      return address(newAddressBook);
    }
}*/