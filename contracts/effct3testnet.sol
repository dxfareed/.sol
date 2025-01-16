// SPDX-License-Identifier: MIT
pragma solidity >= 0.8.0;

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract TriviaBase {

    //testnet!
    address private immutable ADMIN;
    address private immutable MOCK_USDC;
    address private immutable BANK_ADMIN;
    address private immutable deployer;

    constructor(){
        ADMIN = 0x70ca4a44A227645BB4815AE4d68098eA68aB926F;
        MOCK_USDC = 0x1241676d45b1Cb5B573b6258C4A838e149A1D191;
        BANK_ADMIN =  0x1160E90A81Da8EcF955Eb38565B2fc2d6F7D5C57;
        deployer = 0x52c043C7120d7DA35fFdDF6C5c2359d503ceE5F8;
    }


    event RewardsDistributed(address[3] winners, uint[3] rewards);

    error InsufficientContractBalance();

    function EmergencyWithdrawalAdmin() external onlyAddress{
        uint contractBalance = IERC20(MOCK_USDC).balanceOf(address(this));
        IERC20(MOCK_USDC).transfer(ADMIN, contractBalance);
    }

    function ReturnContractBalnc() external view returns(uint){
        return IERC20(MOCK_USDC).balanceOf(address(this));
    }

    function RewardWinners(address[3] memory _users) external{
        //key to randomize lmao;
        require(msg.sender == deployer, "Not deployer Address");
        uint contractBalance = IERC20(MOCK_USDC).balanceOf(address(this));
        if (contractBalance == 0) revert InsufficientContractBalance();

        uint[3] memory user_reward = [
            (48 * contractBalance) / 100,
            (29 * contractBalance) / 100,
            (19 * contractBalance) / 100
        ];

        uint admin_reward = (4 * contractBalance) / 100;

        for (uint i = 0; i < 3; i++) {
            IERC20(MOCK_USDC).transfer(_users[i], user_reward[i]);
        }
        
        IERC20(MOCK_USDC).transfer(BANK_ADMIN, admin_reward);
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
    address private immutable TRIVIA = 0x8bdA167BAE1b73D90C01bC7Df3CF151BEFa5D780;

    event EmitNewTriviaContract( address _TriviaBase );

    function createTriviaContract() external returns (address) {
        address newconstTrivia = Clones.clone(TRIVIA);
        emit EmitNewTriviaContract(newconstTrivia);
        return newconstTrivia;
    }
}
