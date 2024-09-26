// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

contract ErrorTriageExercise {
    /**
     * Finds the difference between each uint with it's neighbor (a to b, b to c, etc.)
     * and returns a uint array with the absolute integer difference of each pairing.
     */
    function diffWithNeighbor(
        uint _a,
        uint _b,
        uint _c,
        uint _d
    ) public pure returns (uint[] memory) {
        uint[] memory results = new uint[](3);

        if(_a>_b){
            results[0] = _a - _b;
        }
        else {
            results[0] = _b - _a;
        }
        
        if(_a>_b){
            results[1] = _b - _c;
        }
        else {
            results[1] = _c - _b;
        }
        
        if(_a>_b){
            results[2] = _c - _d;
        }
        else {
            results[2] = _d - _c;
        }
        return results;
    }

    /**
     * Changes the _base by the value of _modifier.  Base is always >= 1000.  Modifiers can be
     * between positive and negative 100;
     */
    function applyModifier(
        uint _base,
        int _modifier
    ) public pure returns (int) {
        return int(uint256(_base)) + _modifier;
    }

    /**
     * Pop the last element from the supplied array, and return the popped
     * value (unlike the built-in function)
     */
    uint[] arr;

    function popWithReturn() public  returns (uint) {
        uint index = arr.length - 1;
        uint val=arr[index];
        delete arr[index];
        uint[] memory newArr= new uint[](arr.length-1);
        for(uint i=0; i<newArr.length; i++){
            newArr[i]=arr[i]; 
        } 
        arr=newArr;
        return val;
    }

    // The utility functions below are working as expected
    function addToArr(uint _num) public {
        arr.push(_num);
    }

    function getArr() public view returns (uint[] memory) {
      /*
      i was supposed to add this in the pop func :( 
      uint[] memory memArr= new uint[](arr.length-1) ;
        if(arr[arr.length-1]==0){
           for(uint i=0; i<arr.length-1; i++){
            memArr[i]=arr[i];
           } 
           arr=memArr;
           return memArr;
        }*/
        return arr;
    }

    function resetArr() public {
        delete arr;
    }
}
