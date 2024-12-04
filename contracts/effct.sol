// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract TriviaBase {
    address public immutable usdcMockToken;
    address public immutable admin;

    event RewardsDistributed(address[3] winners, uint[3] rewards);

    constructor(address _usdcMockToken, address _admin) {
        usdcMockToken = _usdcMockToken;
        admin = _admin;
    }

    error InsufficientContractBalance();

    function transferFunctionUsdc(uint _amount) external {
        IERC20(usdcMockToken).transferFrom(msg.sender, address(this), _amount);
    }

    function sndRewards(address[3] memory _users) external {
        uint contractRewards = IERC20(usdcMockToken).balanceOf(address(this));
        if (contractRewards == 0) revert InsufficientContractBalance();

        uint[3] memory rewards = [
            (58 * contractRewards) / 100,
            (29 * contractRewards) / 100,
            (9 * contractRewards) / 100
        ];

        for (uint i = 0; i < 3; i++) {
            IERC20(usdcMockToken).transfer(_users[i], rewards[i]);
        }

        emit RewardsDistributed(_users, rewards);
    }

    modifier onlyAddress() {
        require(msg.sender == admin, "Only admin wallet!");
        _;
    }
}

import "@openzeppelin/contracts/proxy/Clones.sol";

contract TriviaBaseFactory {
    address private constTrivia;

    constructor(address _constTrivia) {
        constTrivia = _constTrivia;
    }

    event EmitNewTriviaContract( address _TriviaBase );

    function createTriviaContract() external returns (address) {
        address newconstTrivia = Clones.clone(constTrivia);
        emit EmitNewTriviaContract(newconstTrivia);
        return newconstTrivia;
    }
}
