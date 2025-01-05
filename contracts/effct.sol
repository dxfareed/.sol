// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract TriviaBase {
    address private immutable usdcMockToken = 0x1241676d45b1Cb5B573b6258C4A838e149A1D191;
    address private immutable admin = 0x52c043C7120d7DA35fFdDF6C5c2359d503ceE5F8;


    event RewardsDistributed(address[3] winners, uint[3] rewards);

    error InsufficientContractBalance();

    function sndRewards(address[3] memory _users) external onlyAddress {
        uint contractRewards = IERC20(usdcMockToken).balanceOf(address(this));
        if (contractRewards == 0) revert InsufficientContractBalance();

        uint[3] memory rewards = [
            (58 * contractRewards) / 100,
            (29 * contractRewards) / 100,
            (9 * contractRewards) / 100
        ];
        uint adminreward= (4 * contractRewards) / 100;

        for (uint i = 0; i < 3; i++) {
            IERC20(usdcMockToken).transfer(_users[i], rewards[i]);
        }
        IERC20(usdcMockToken).transfer(admin, adminreward);
        emit RewardsDistributed(_users, rewards);
    }

    modifier onlyAddress() {
        require(msg.sender == admin, "Only admin wallet!");
        _;
    }
}

import "@openzeppelin/contracts/proxy/Clones.sol";

contract TriviaBaseFactory {
    address private constTrivia = 0xf3d0bab35885fb8b2afED184b474e2AC8b0aB217;

    event EmitNewTriviaContract( address _TriviaBase );

    function createTriviaContract() external returns (address) {
        address newconstTrivia = Clones.clone(constTrivia);
        emit EmitNewTriviaContract(newconstTrivia);
        return newconstTrivia;
    }
}
