//SPDX-License-Identifier:MIT

pragma solidity ^0.8.17;
contract BasicMath{
    function adder(uint _a, uint _b) public pure returns (uint sum, bool error){
        uint smm;
        unchecked{smm=_a+_b;}
        if ( smm <= 0 ){
            return (0, true);
        }
        return (_a + _b , false );
    }
    function subtractor(uint _a, uint _b) public pure returns (uint differ,bool error){
        if( _b > _a ){
            return (0, true);
        }
        return( _a - _b , false );
    }
}