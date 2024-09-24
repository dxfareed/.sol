//SPDX-License-Identifier:MIT

pragma solidity >=0.8.0;

contract Test{
    mapping (address => uint) public Num;

    function AddToNum(address person, uint _num) external returns(string memory frm) {
        if(Num[person]==0){
            Num[person]=_num;
        }
        else{
            return "allready entered";
        }
    }
    function Delete(address addr) external {
        delete Num[addr];
    }
}