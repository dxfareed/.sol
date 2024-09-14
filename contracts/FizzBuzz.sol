//SPDX-License-Identifier:MIT

pragma solidity >=0.8.0;
contract FizzBuzz{
    function fizzBuzz(uint _number) external pure returns (string memory ){
        if(_number%15==0){
            return "FizzBuzz";
        }
        else if(_number%3==0) {
            return "Fizz";
        }
        else if(_number%5==0){
            return "Buzz";
        }
        else{
            return "Splat";
        }

    }
    error AfterHours(uint time);
    function doNotDisturb(uint _time) public pure returns (string memory message){
        //2400 panic
        //2200 /800 custom err 
        //1200 1259 require
        /*
            If _time is between 1200 and 1259, revert with a string message "At lunch!"
            If _time is between 800 and 1199, return "Morning!"
            If _time is between 1300 and 1799, return "Afternoon!"
            If _time is between 1800 and 2200, return "Evening!"
        */
        assert(_time<2400);
        require( _time>=10 && _time<=1199 || _time>=1300 && _time<=2399, "At lunch!");
        if(_time < 800 || _time>2200){
            revert AfterHours(_time);
        }
        if ((_time>=800) && (_time <= 1199)){
            message ="Morning!";
            return message;
        }
        else if((_time>=1300) && (_time<=1799)){
            message ="Afternoon!";
            return  message;
        }
        else if ((_time>=1800) && (_time<=2200)){
            message ="Evening!";
            return  message;
        }  
    }
}