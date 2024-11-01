//SPDX-License-Identifier: MIT

pragma solidity >=0.8.0;

contract Events{
    //event setUpNumber(uint indexed  oldnumber, uint indexed newNumber);
    string text="text";
    function reText() public view returns (string memory yiy){
       // emit setUpNumber (_old, _fav);
        string storage mn=text;
        yiy=mn;
        return mn;
    }
    //https://www.youtube.com/watch?v=bFU5WHjisWI
}