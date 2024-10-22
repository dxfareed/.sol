//SPDX-License-Identifier: MIT

pragma solidity >=0.8.0;

contract Events{
    event setUpNumber(uint indexed  oldnumber, uint indexed newNumber);
    function reText(uint _old,uint _fav) public{
        emit setUpNumber (_old, _fav);
    }
}