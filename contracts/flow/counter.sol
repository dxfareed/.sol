//SPDX-License-Identfier:MIT

pragma solidity >=0.8.0;


contract Counter{
    uint256 private counter;
    event TweakNum(uint256);

    function AddCount() external{
        counter++;
        emit TweakNum(counter);
    }

    function CallCount() external view returns(uint256){
        return counter;
    }
}