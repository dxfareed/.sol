//SPDX-License-Identfier:MIT;


pragma solidity >=0.8.0;

import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";

interface IWETH9 {
    function deposit() external payable;
    function withdraw(uint256) external;
    function approve(address spender, uint256 amount) external returns (bool);
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract AutoSwapDonation {
    ISwapRouter public immutable swapRouter;
    address public immutable token;
    address public constant WETH9 = 0x4200000000000000000000000000000000000006;

    constructor(address _token) {
        swapRouter = ISwapRouter(0x94cC0AaC535CCDB3C01d6787D6413C739ae12bc4); // Ensure this is the correct router for your testnet
        token = _token;
    }

    receive() external payable {
        swapETHForToken(msg.value);
    }

    function swapETHForToken(uint256 amount) public payable {
        require(amount > 0, "Must send ETH");
        IWETH9(WETH9).deposit{value: amount}();
        
        IWETH9(WETH9).approve(address(swapRouter), amount);
        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter.ExactInputSingleParams({
            tokenIn: WETH9,
            tokenOut: token,
            fee: 3000,
            recipient: msg.sender,
            deadline: block.timestamp + 300,
            amountIn: amount,
            amountOutMinimum: 0,
            sqrtPriceLimitX96: 0
        });

        swapRouter.exactInputSingle(params);
    }
}
