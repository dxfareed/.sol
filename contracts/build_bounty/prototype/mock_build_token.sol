// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0;

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);
}

contract ClaimBuildFaucet{
    address immutable MOCK_BUILD;
    uint private immutable magic_num;
    constructor(address mock_build_ca){
        MOCK_BUILD = mock_build_ca;
        magic_num = 10 ** 18;
    }

    function ClaimFaucet() external {
    require(IERC20(MOCK_BUILD).balanceOf(msg.sender) <= 10_000 * magic_num, "holding too many token!");
    require(IERC20(MOCK_BUILD).balanceOf(address(this)) > 0, "Empty vault!" );
    IERC20(MOCK_BUILD).transfer(msg.sender, 10_000_000 * magic_num);  
    }

    function BalanceFaucet() external view returns(uint) {
        return IERC20(MOCK_BUILD).balanceOf(address(this));
    }

    function ReadOnly4DevBalanceFaucet() external view returns(uint) {
        return IERC20(MOCK_BUILD).balanceOf(address(this)) / magic_num;
    }
}