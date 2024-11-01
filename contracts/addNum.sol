//SPDX-License-Identifier:MIT

pragma solidity >=0.8.17;

contract AddNum{
    function addNum(uint a, uint b) public pure returns(uint sum){
        unchecked{ sum = a+b; }
        if(sum<=0){
            return 0;
        }
        return sum;
    }
}