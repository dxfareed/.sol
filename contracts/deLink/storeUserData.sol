//SPDX-License-Identifer: UNLICENSED
pragma solidity ^0.8.17;

contract storeUserData{
    struct eachList{
        string name;
        string topic;
        string link;
        string uid; 
    }
    mapping( address => eachList[]) StoreList;
    function addList(eachList[] memory _userlist) external{
        for(uint i; i<_userlist.length; i++){
            StoreList[msg.sender].push(_userlist[i]);
        }
        //StoreList[msg.sender].push(_userlist);
    }
    function checkUser() external view returns(string memory  _message){
        if(StoreList[msg.sender].length!=0){
            return StoreList[msg.sender][0].uid;
        }
    }
}