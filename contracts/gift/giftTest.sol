//SPDX-License-Identifier:MIT

pragma solidity ^0.8.0;

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract Gift{
    address private immutable admin = 0x52c043C7120d7DA35fFdDF6C5c2359d503ceE5F8;
    address private immutable token = 0x1241676d45b1Cb5B573b6258C4A838e149A1D191;

    mapping (address => uint256) userAllocation;

    000000
    //@approve then.. 
    function UserDeposit(uint256 _amount) external returns(bool){
       bool success = IERC20(token).transferFrom(msg.sender, address(this), _amount);
       if (success){
            userAllocation[msg.sender] += _amount;
            return success;
       }
    }

    //admin call this function only
    function ClaimReward(uint256 _amount,address _sender,address _reciever)  external onlyAdmin returns (bool){
        require( userAllocation[_sender] <= _amount, "Insufficient Below" );
        bool _success = IERC20(token).transfer(_reciever, _amount);

        if(_success){
            userAllocation[_sender] -= _amount;
            return _success;
        }
    }

    function UserBalance(address _caller) external view returns (uint256) {
        return userAllocation[_caller];
    }

    function plusOneBalance() external view returns(uint256){
        uint256 bal = IERC20(token).balanceOf(address(this));
        return bal;
    }

    modifier onlyAdmin(){
        require(msg.sender == admin, "Only admin can call this function");
        _;
    }
}