//SPDX-License-Identifier:MIT

pragma solidity ^0.8.0;

contract GarageManager{
    struct Car{
        string make;
        string model;
        string color;
        uint numberOfDoors;
    }
    mapping(address => Car[]) public garage;
    error BadCarIndex(uint index);
    function addCar(string memory _make, string memory _model, string memory _color,uint _nod) public{
        Car memory newCar=Car({
            make:_make,
            model:_model,
            color:_color,
            numberOfDoors:_nod
        });
        //Car(_make,_model,_color,_nod);
        garage[msg.sender].push(newCar);
    }
    function getMyCars() public view returns (Car[] memory) {
        return garage[msg.sender];
    }
    function getUserCars(address addr) public view returns(Car[] memory cars){
        if(garage[addr].length>0){
            return garage[addr];
        }
    }
    function updateCar(uint _index,string memory _make, string memory _model, string memory _color,uint _nod) public {
        if(_index>garage[msg.sender].length){
            revert BadCarIndex(_index);
        }
        Car memory updatCar=Car({
            make:_make,
            model:_model,
            color:_color,
            numberOfDoors:_nod
        });
        garage[msg.sender][_index]=updatCar;
    }
    function resetMyGarage() public {
        delete garage[msg.sender];
    }
}