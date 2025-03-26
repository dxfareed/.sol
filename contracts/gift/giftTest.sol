//SPDX-License-Identifier:MIT

pragma solidity ^0.8.0;

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract Gift{
    address private immutable ADMIN = 0x52c043C7120d7DA35fFdDF6C5c2359d503ceE5F8;
    address private immutable TOKEN = 0x072BA244Cf0DE5984dEB40030Aef86d7661303dC;

    mapping (address => uint256) userAllocation;

    error TransactionError(string);
    error InsufficientBalance(string);

    //@approve then.. 
    function UserDeposit(uint256 _amount) external returns(bool _success){
        _success = IERC20(TOKEN).transferFrom(msg.sender, address(this), _amount);
       if (_success){
            userAllocation[msg.sender] += _amount;
            return _success;
       }
       else {
        revert TransactionError("Transaction Error");
       }
    }

    //ADMIN call this function only
    // @ onlyAdmin modifier
    function ClaimReward(uint256 _amount,address _sender,address _reciever)  external onlyAdmin returns (bool _success){
        
        // @ require too many gas. fucking pun hahhah
        //require( userAllocation[_sender] <= _amount, "Insufficient Below" );

        if( _amount > userAllocation[_sender] ){
            revert InsufficientBalance("Insufficient Balance");
        }
        _success = IERC20(TOKEN).transfer(_reciever, _amount);

        if(_success){
            userAllocation[_sender] -= _amount;
            return _success;
        }
    }

    function UserBalance(address _caller) external view returns (uint256) {
        return userAllocation[_caller];
    }

    //contract balance
    function plusOneBalance() external view returns(uint256){
        uint256 bal = IERC20(TOKEN).balanceOf(address(this));
        return bal;
    }

    modifier onlyAdmin(){
        require(msg.sender == ADMIN, "Only ADMIN can call this function");
        _;
    }
}
