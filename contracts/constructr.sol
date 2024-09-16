//SPDX-License-Identifier:MIT

pragma solidity >=0.8.0;

contract wrtContrust{
    uint8 public age;
    uint8 public cars;
    constructor (uint8 _age, uint8 _cars){
        age=_age;
        cars=_cars;
    }
    function updateCars(uint8 _cars) public{
        cars=_cars;
    }
    function increaseAge() public {
        age++;
    }
    function changeAge(uint8 _age) public{
        age = _age;
    }
}