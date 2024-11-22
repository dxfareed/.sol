//SPDX-License-Identifier: MIT

pragma solidity >=0.8.0;

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
}

contract UserStore{
    address private imp = 0x6eef01557aE461A863c6214A96B0dD872601b53d ; 
    mapping (address => uint) public numbersOfGamePlayed;
    mapping (address => uint) creatorTotal; 

    address[] whl_Users;

    function storeTotalGP(address[] memory _users) external {
        for(uint i; i< _users.length; i++){
            numbersOfGamePlayed[_users[i]]= numbersOfGamePlayed[_users[i]]+1;
        }
        whl_Users = _users;
    }

    function showTotalGp() external view returns(uint) {
       return  numbersOfGamePlayed[msg.sender];
    }

    function storeCreatorTotal() external {
        creatorTotal[msg.sender] = creatorTotal[msg.sender]+1;
    }
    
    function showCreatorTotal() external view returns(uint){
        return creatorTotal[msg.sender];
    }

    function sendRewards(address _allow) external view returns (uint){
      uint ret = IERC20(imp).balanceOf(_allow); 
      return ret;
    }
    function approve(address spender, uint num) external returns (bool){
        bool apprv = IERC20(imp).approve(spender, num);
        return apprv;
    }

    function allowApprovTest(address _owner, address _spender) external view returns (uint){
        return IERC20(imp).allowance(_owner, _spender);
    }
    function transferTo(address _from, address _to, uint _amount) external {
       IERC20(imp).transferFrom(_from, _to, _amount);
    }
}

/* contract DepositToPlayers{
    error NotFound(string);
    function deposit(address[] memory _winners) external {
        
    }
} */

/*contract addMe{
    function add(uint _a, uint _b) external pure returns(uint){
        return _a+_b;
    }
}

contract testj{
    function testNi() public pure returns(uint){
        addMe addressAddme = addMe(0x11dDe867C6a225C49523b540BF854C6ECEa6C489); 
        
        return addressAddme.add(2,3);
    }
}*/