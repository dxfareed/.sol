//SPDX-License-Identifier:MIT

pragma solidity >=0.8.0;

contract HelloWorld{
    function messageA()public  pure returns(string memory){
        return "hello world";
    }
}
contract HelloWorldSecond{
    function messageB()public  pure returns(string memory){
        return "hello world";
    }
}
contract MainMessage is  HelloWorld, HelloWorldSecond(){
    function showMessage() public pure returns(string memory){
        return messageA();
    }
}