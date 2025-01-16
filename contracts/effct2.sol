// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract TriviaBase {

    //MAINNET
    address private immutable MAINNET_USDC = 0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913;
    address private immutable ADMIN = 0x52c043C7120d7DA35fFdDF6C5c2359d503ceE5F8;


    event RewardsDistributed(address[3] winners, uint[3] rewards);

    error InsufficientContractBalance();

    function EmergencyWithdrawalAdmin() external onlyAddress{
        uint contractBalance = IERC20(MAINNET_USDC).balanceOf(address(this));
        IERC20(MAINNET_USDC).transfer(ADMIN, contractBalance);
        
    }

    function ReturnContractBalnc() external view returns(uint){
        return IERC20(MAINNET_USDC).balanceOf(address(this));
    }

    function RewardWinners(address[3] memory _users) external onlyAddress {

        uint contractBalance = IERC20(MAINNET_USDC).balanceOf(address(this));
        if (contractBalance == 0) revert InsufficientContractBalance();

        uint[3] memory user_reward = [
            (48 * contractBalance) / 100,
            (29 * contractBalance) / 100,
            (19 * contractBalance) / 100
        ];

        uint admin_reward = (4 * contractBalance) / 100;

        for (uint i = 0; i < 3; i++) {
            IERC20(MAINNET_USDC).transfer(_users[i], user_reward[i]);
        }
        IERC20(MAINNET_USDC).transfer(ADMIN, admin_reward);
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
    address private immutable TRIVIA = 0x8241C4E08E270fC790a34B63226d6E57EC22261f;

    event EmitNewTriviaContract( address _TriviaBase );

    function createTriviaContract() external returns (address) {
        address newconstTrivia = Clones.clone(TRIVIA);
        emit EmitNewTriviaContract(newconstTrivia);
        return newconstTrivia;
    }
}
