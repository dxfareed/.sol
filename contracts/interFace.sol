//SPDX-License-Identifier:MIOT

pragma solidity ^0.8.17;

interface IAddedNum{
    function AddNum(uint256,uint256) external pure returns(uint256);
}
contract FaceInter{
    function AddNum(uint256 r,uint256 t) external pure returns(uint256){
        return  r+t;
    }   
}