//SPDX-License-Identifier: MIT

pragma solidity >=0.8.17;

contract voteDapp{
    mapping(address => string) userWhoVoted;
    string[] totalOfA;
    string[] totalOfB;
    error userVotedStop(string _user);
    function addVoteA(string memory _a) external {
        if( bytes(userWhoVoted[msg.sender]).length!=0){
            revert userVotedStop("user voted already");
        }
        userWhoVoted[msg.sender]=_a;
        totalOfA.push(_a);
    }
    function addVoteB(string memory _b) external {
        if( bytes(userWhoVoted[msg.sender]).length!=0){
            revert userVotedStop("user voted already");
        }
        userWhoVoted[msg.sender]=_b;
        totalOfB.push(_b);
    }
    function totalVoteA() external view returns(uint){
        uint _total=totalOfA.length;
        return _total;
    }
    function totalVoteB() external view returns(uint){
        uint _total=totalOfB.length;
        return _total;
    }
    function totalVote() external view returns(uint){
        uint _totalAll= totalOfA.length+totalOfB.length;
        return _totalAll;
    }
}
