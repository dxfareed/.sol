//SPDX-License-Identifier:MIT

pragma solidity >=0.8.0;
contract arryT{
    uint[] numClt=[1,2,3,4,5];
    function showArry() external view  returns(uint)  {
        /*uint[] memory localarr=numClt;
        return (localarr.length);*/
        //local cost 13k
        //---------------
        return (numClt.length); 
        //storage more efficient with out assignment, gas fee 2k
    }
    function loopArr() external view returns(uint){
        uint[] memory num=new  uint[](numClt.length);
        uint pzx=0;
        for(uint8 i=0; i<numClt.length; i++){
            if(numClt[i]%2==0){
                num[pzx] = (numClt[i]);
                pzx++;
            }
        }
        return num[1];
    }
}