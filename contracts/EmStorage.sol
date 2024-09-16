//SPDX-License-Identifier:MIT

pragma solidity >=0.8.0;

contract EmployeeStorage{
    uint16 private shares;
    uint32 private salary;
    uint public idNumber;
    string public name;
    constructor(uint16 _shares, string memory _name, uint32 _salary, uint _idNumber){
        shares=_shares;
        name=_name;
        salary=_salary;
        idNumber=_idNumber;
        //assert(shares<5000);
    }
    function viewSalary() public view  returns (uint32){
        return salary;
    }
    function viewShares()public view  returns (uint16){
        return shares;
    }
    error TooManyShares(uint total);
    function grantShares(uint16 _newShares) public {
        require(_newShares<5000, "Too many shares");
        shares+=_newShares;
        if(shares>5000){
            revert TooManyShares(shares);
        }
    }
    function checkForPacking(uint _slot) public view returns (uint r) {
        assembly {
            r := sload (_slot)
        }
    }
    function debugResetShares() public {
        shares = 1000;
    }
}
