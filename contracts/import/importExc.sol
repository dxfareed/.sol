//SPDX-License-Identifier:MIT

pragma solidity ^0.8.17;
import "./export.sol";
contract Main{
    using SillyStringUtils for *;
    SillyStringUtils.Haiku public haiku;
   // constructor(string memory _a,string memory _b,string memory _c){
     //   haiku= SillyStringUtils.Haiku(_a,_b,_c);
    //}
     function saveHaiku(string memory _a,string memory _b,string memory _c) public {
        haiku=SillyStringUtils.Haiku(_a,_b,_c);
    }
    function getHaiku(string memory _a,string memory _b,string memory _c) public pure returns (SillyStringUtils.Haiku memory){
       return  SillyStringUtils.Haiku(_a,_b,_c);  
    }
    function shruggieHaiku(string memory _a,string memory _b,string memory _c) public pure returns (SillyStringUtils.Haiku memory) {
        SillyStringUtils.Haiku memory ToAdd;
        ToAdd.line1=_a;
        ToAdd.line2=_b;
        ToAdd.line3=SillyStringUtils.shruggie(_c);
        return ToAdd;
    }
}