//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract SetValue{

        uint valuepassinit;
        function HelloWorld(uint _val)public{
                valuepassinit=_val;
        }

        function returnval() external view  returns(uint){
                return valuepassinit;
        }

}
