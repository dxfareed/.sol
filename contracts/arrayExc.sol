//SPDX-License-Identifier:MIT

pragma solidity >=0.8.0;

contract ArraysExercise {
    uint[] public numbers = [1,2,3,4,5,6,7,8,9,10];
    uint strNumLength=numbers.length;
    address[] senders;
    uint[] timestamps;
    function getNumbers() external view returns(uint[] memory memArr){
        memArr=numbers;
        return memArr;
    }
    function resetNumbers() external{
        uint[] memory _num= new uint[](strNumLength);
        for(uint i=0; i<numbers.length; i++){
            _num[i]=i+1;
        }
        delete numbers;
        numbers=_num;
    }
    function appendToNumbers(uint[] calldata _toAppend) external {
        for (uint i=0; i<_toAppend.length; i++){
           numbers.push(_toAppend[i]); 
        }
        //numbers.push(arr);   
    }
    function saveTimestamp( uint _unixTimestamp) external{
        senders.push(msg.sender);
        timestamps.push(_unixTimestamp);
    }
    function afterY2K() external view returns (uint[] memory _timestamps, address[] memory _addresses){
        //timestamps and addresses
        uint result;
        for(uint i=0; i<timestamps.length; i++){
            if(timestamps[i]>=946702800){
                result++;
            }
        }
        uint[] memory filtrArry=new uint[](result);
        address[] memory filtrAddress=new address[](result);
        uint _num=0;
        for(uint i=0; i<timestamps.length; i++){
            if(timestamps[i]>=946702800){
                filtrArry[_num]=timestamps[i];
                filtrAddress[_num]=senders[i];
                _num++;
            }
        }
        return  (filtrArry,filtrAddress);
    }
    function resetSenders() external {
        delete senders;
    }
     function resetTimestamps() external {
        delete timestamps;
    }
}

