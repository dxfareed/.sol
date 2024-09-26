// SPDX-License-Identifier: MIT

pragma solidity  ^0.8.17;


library SillyStringUtils {

    struct  Haiku {
        string line1;
        string line2;
        string line3;
    }
    //Haiku me=Haiku("","","");
    function shruggie(string memory _input) internal pure returns (string memory) {
        return string.concat(_input, unicode" 🤷");
    }
    //function getHaiku() public pure returns ( Haiku memory){
    //    return Haiku(Haiku.line1,Haiku.line2,Haiku.line3);
    //}
}