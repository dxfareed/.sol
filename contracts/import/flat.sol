// Sources flattened with hardhat v2.22.11 https://hardhat.org

// SPDX-License-Identifier: MIT

// File Contracts/export.sol

// Original license: SPDX_License_Identifier: MIT

pragma solidity ^0.8.17;

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


// File Contracts/importExc.sol

contract Main{
    using SillyStringUtils for *;
    SillyStringUtils.Haiku public haiku;
   // constructor(string memory _a,string memory _b,string memory _c){
     //   haiku= SillyStringUtils.Haiku(_a,_b,_c);
    //}
     function saveHaiku(string memory _a,string memory _b,string memory _c) public returns(SillyStringUtils.Haiku memory){
        haiku=SillyStringUtils.Haiku(_a,_b,_c);
        return haiku;
    }
    function getHaiku() public view returns (SillyStringUtils.Haiku memory){
       //return  SillyStringUtils.Haiku(_a,_b,_c);
       return haiku;  
    }
    function shruggieHaiku() public view returns (SillyStringUtils.Haiku memory) {
        SillyStringUtils.Haiku memory ToAdd=haiku;
        ToAdd.line3=SillyStringUtils.shruggie(haiku.line3);
        return ToAdd;
    }
}