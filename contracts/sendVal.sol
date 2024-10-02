//SPDX-License-Identifier: MIT

pragma solidity >=0.8.0;

contract ValueContrct{
    uint yesNum;
    function setValue(uint _num) public{
        yesNum=_num;
    }
    function getValue() public view returns(uint){
        return yesNum;
    }
}