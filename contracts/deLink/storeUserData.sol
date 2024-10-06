//SPDX-License-Identifer: MIT

pragma solidity ^0.8.17;

contract storeUserData{
    struct eachList{
        string topic;
        string link;   
    }
    mapping( address => eachList[]) StoreList;
    function addList(eachList[] memory) external{
        StoreList[msg.sender]=eachList[];
    }
}