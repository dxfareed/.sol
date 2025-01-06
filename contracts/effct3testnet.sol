// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract TriviaBase {

    //testnet!
    address private immutable usdcMockToken = 0x1241676d45b1Cb5B573b6258C4A838e149A1D191;
    address private immutable ADMIN = 0x52c043C7120d7DA35fFdDF6C5c2359d503ceE5F8;


    event RewardsDistributed(address[3] winners, uint[3] rewards);

    error InsufficientContractBalance();

    function EmergencyWithdrawalAdmin() external onlyAddress{
        uint contractBalance = IERC20(usdcMockToken).balanceOf(address(this));
        IERC20(usdcMockToken).transfer(ADMIN, contractBalance);
        
    }

    function ReturnContractBalnc() external view returns(uint){
        return IERC20(usdcMockToken).balanceOf(address(this));
    }

    function RewardWinners(address[3] memory _users) external onlyAddress {
        uint contractBalance = IERC20(usdcMockToken).balanceOf(address(this));
        if (contractBalance == 0) revert InsufficientContractBalance();

        uint[3] memory user_reward = [
            (58 * contractBalance) / 100,
            (29 * contractBalance) / 100,
            (9 * contractBalance) / 100
        ];

        uint admin_reward = (4 * contractBalance) / 100;

        for (uint i = 0; i < 3; i++) {
            IERC20(usdcMockToken).transfer(_users[i], user_reward[i]);
        }
        IERC20(usdcMockToken).transfer(ADMIN, admin_reward);
        emit RewardsDistributed(_users, user_reward);
    }

    modifier onlyAddress() {
        require(msg.sender == ADMIN, "Only admin wallet!");
        _;
    }
}

//[0x52c043C7120d7DA35fFdDF6C5c2359d503ceE5F8,0x52c043C7120d7DA35fFdDF6C5c2359d503ceE5F8,0x52c043C7120d7DA35fFdDF6C5c2359d503ceE5F8]

import "@openzeppelin/contracts/proxy/Clones.sol";

contract TriviaBaseFactory {
    address private immutable TRIVIA = 0x7102f6ebbcC678F28622B9308d18c486Fc7503dE;

    event EmitNewTriviaContract( address _TriviaBase );

    function createTriviaContract() external returns (address) {
        address newconstTrivia = Clones.clone(TRIVIA);
        emit EmitNewTriviaContract(newconstTrivia);
        return newconstTrivia;
    }
}
