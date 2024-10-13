//SPDX-License-Identifer: UNLICENSED
pragma solidity ^0.8.17;

contract storeUserData{
    error UserNotFound(string);
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
    }
    function checkUser(address _user) external view returns(eachList[] memory){
        if(StoreList[_user].length!=0){
            return StoreList[_user];
        }
        return StoreList[_user];
        //revert UserNotFound("User not found");
    }
    function deleteData(address _user) external{
        delete  StoreList[_user];
    }
}