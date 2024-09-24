//SPDX-License-Identifier:MIT

pragma solidity >=0.8.0;

contract lkTup{
    struct LkTp{
        uint age;
        string person;
    }
    function Rtrn() external pure returns(LkTp memory) {
        LkTp memory definedRT = LkTp(20,"Fareed");
        return definedRT;
    }
}