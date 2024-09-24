//SPDX-License-Identifier: MIT

pragma solidity >=0.8.0;

contract GiveAway{
    //address collected from connected address
    //use mathfloor for integer, 
    address owner;
    constructor(){
        owner=msg.sender;
    }
    mapping (address=> uint) UserAddressAmount;
    address[] addressOfUser;
    error AddressAdded(address,string);
    uint amount;//amount
    function SetAmount() public OnlyOwner {
        //amount setfrom frontend then removed on contract
        //after wallet connect
    }
    function sendAmount() private {
        //recieves variable {amountRandom, array variable} from front;
        /*
            for(uint i=0; i< ArrayLength; i++){
                userAmount[addressVariable[i]]=randomAmount[i]
                sendAmount(address[i], randomAmount[i]);
            }
        */
    }
    modifier OnlyOwner(){
        require(owner==msg.sender,"not a owner");
        _;
    }
}