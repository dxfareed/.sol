//SPDX-License-Identifier: MIT

pragma solidity >=0.8.0;

contract SetValue{
        uint[] private fromvalue;

        function addVal(uint[] memory _val) public {
                uint[] memory newvalue = new uint[](_val.length);
                for(uint i; i<_val.length; i++){
                        newvalue[i]=(_val[i]);
                }
                fromvalue = newvalue;
        }

        function returnval() external view returns(uint[] memory) {
                return fromvalue;
        }
}

