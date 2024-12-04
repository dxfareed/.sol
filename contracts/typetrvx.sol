//SPDX-License-Identifier: MIT

pragma solidity >=0.8.0;

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract TriviaBase{
    address private constant usdcMockToken= 0xb634247Abf7A50Dd7b9Cf6671A3e83F34f5f78D0;
    address private constant admin = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    uint private constant dec = 1*1e6;
    address[] private winners;
    error insufficientContractBalance();
    
    function transferFunctionUsdc(uint _amount) external returns(address _sender) {
        require(IERC20(usdcMockToken).balanceOf(msg.sender)>=_amount, "Insufficent Balance");
        IERC20(usdcMockToken).transferFrom(msg.sender, address(this), _amount);
        return msg.sender;
    }
    function sndRewards(address[] memory _users) external {
        address[3] memory _winners;
       /*  for (uint i=0; i < _winners.length; i++){
            _winners[i]=_users[i];
        } */
        _winners[0] = _users[0];
        _winners[1] = _users[1];
        _winners[2] = _users[2];
        uint contractRewards =  IERC20(usdcMockToken).balanceOf(address(this));
        if(contractRewards == 0){
            revert insufficientContractBalance();
        }
        uint firstPlayer = (58 * contractRewards * dec)/(100 * dec);
        uint secondPlayer = (29 * contractRewards * dec)/(100 * dec);
        uint thirdPlayer = (9 * contractRewards * dec)/(100 * dec);

        IERC20(usdcMockToken).transfer(winners[0],firstPlayer);
        IERC20(usdcMockToken).transfer(winners[1],secondPlayer);
        IERC20(usdcMockToken).transfer(winners[2],thirdPlayer);
    }
    function ContractBalance() external view returns(uint){
        uint _contractBalance =  IERC20(usdcMockToken).balanceOf(address(this))/dec;
        return _contractBalance;
    }
        /* function emergencyWithDrawal() external onlyAddress {
            uint contractBalance =  IERC20(usdcMockToken).balanceOf(address(this));
            if (contractBalance > 0) {
                require(IERC20(usdcMockToken).transfer(msg.sender,contractBalance), "Failed");
            }
        } */

    modifier onlyAddress(){
        require(msg.sender == address(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4), "Only admin wallet!");
        _;
    }
}

contract TriviaBaseCreate{    

    function createTriviaContract() external returns(address) {
        TriviaBase _trivia = new TriviaBase();
        return address(_trivia);
    }
    function heyhey() external returns(address){
        //return createTriviaContract();
    }
}