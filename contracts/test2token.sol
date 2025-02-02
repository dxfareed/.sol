//SPDX-License-Identifier: MIT

pragma solidity >= 0.8.0;

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract TestToken{
    address immutable MOCK_USDC = 0x1241676d45b1Cb5B573b6258C4A838e149A1D191;
    function sendToken() external {
        IERC20(MOCK_USDC).balanceOf(msg.sender);
    }
}



