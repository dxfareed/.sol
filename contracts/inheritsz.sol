///SPDX-License-Identifier:MIT

pragma solidity >=0.8.0;

abstract contract Employee {
    uint public idNumber;
    uint public managerId;
    constructor(uint _idnum, uint _managerId){
        idNumber=_idnum;
        managerId=_managerId;
    }
    function getAnnualCost() public virtual view returns(uint);
}
contract Salaried is Employee {
    uint public annualSalary;
    constructor(uint _idnum, uint _managerId, uint _annualSal)Employee(_idnum,_managerId){
       annualSalary=_annualSal;
    }
    function getAnnualCost() public override view returns (uint){
        return annualSalary;
    }
}
contract Hourly is Employee {
    uint public hourlyRate;
    uint annualHourlyCost;
     constructor(uint _hourlyrate, uint _idnum, uint _managerId)Employee(_idnum,_managerId){
        hourlyRate=_hourlyrate;
        annualHourlyCost=2080;
    }
    function getAnnualCost() public override  view returns (uint _total){
        _total=annualHourlyCost*hourlyRate;
        return _total;
    }
}
contract Manager{
    uint[] employeeIds;
    function AddReport(uint _idNum) public {
        employeeIds.push(_idNum);
    }
    function resetReports() public {
        delete employeeIds;
    }
}
contract Salesperson is Hourly{
    uint hourlyRatei;
    constructor(uint _hourlyRate, uint _salesId, uint _salesManId) Hourly(_hourlyRate, _salesId, _salesManId){
        hourlyRatei=_hourlyRate;
    }
    function getAnnualHourly() public view returns(uint){
        return Hourly.hourlyRate;
    }
}
contract EngineeringManager is Salaried,Manager{
    uint idnum;
    constructor(uint annualSal,uint _idnum, uint manNumId)Salaried(_idnum, manNumId,annualSal){
        idnum=_idnum;
    }
    function AddbyEng()public   {
        Manager.AddReport(idnum);
    }
    function Deletem()public {
        Manager.resetReports();
    }
    function showM()public view returns (uint[] memory) {
        return Manager.employeeIds;
    }
}
contract InheritanceSubmission {
    address public salesPerson;
    address public engineeringManager;

    constructor(address _salesPerson, address _engineeringManager) {
        salesPerson = _salesPerson;
        engineeringManager = _engineeringManager;
    }
}