// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface IWETH9 {
    function deposit() external payable;
    function withdraw(uint256) external;
    function approve(address spender, uint256 amount) external returns (bool);
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract AutoSwapDonation is Ownable {
    ISwapRouter public immutable swapRouter;
    ERC20 public immutable token;
    address private constant WETH9 = 0x4200000000000000000000000000000000000006;
    uint24 public swapFee;

    event DonationReceived(address indexed donor, uint256 ethAmount);
    event SwapExecuted(uint256 amountIn, uint256 amountOut);
    event Withdraw(address indexed to, address indexed token, uint256 amount);

    constructor(address _token, address _swapRouter, uint24 _swapFee)Ownable(msg.sender) {
        swapRouter = ISwapRouter(_swapRouter);
        token = ERC20(_token);
        swapFee = _swapFee;
    }
    function donate() public payable {
        _swapETHForToken(msg.value);
        emit DonationReceived(msg.sender, msg.value);
    }

    function _swapETHForToken(uint256 amount) internal {
        require(amount > 0, "Must send ETH");

        IWETH9(WETH9).deposit{value: amount}();
        IWETH9(WETH9).approve(address(swapRouter), amount);

        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter.ExactInputSingleParams({
            tokenIn: WETH9,
            tokenOut: address(token),
            fee: swapFee,
            recipient: msg.sender,
            deadline: block.timestamp + 300,
            amountIn: amount,
            amountOutMinimum: 0,
            sqrtPriceLimitX96: 0
        });

        uint256 amountOut = swapRouter.exactInputSingle(params);
        emit SwapExecuted(amount, amountOut);
    }

    function withdraw(address _token, uint256 _amount) public onlyOwner {
        require(_token != address(token), "Cannot withdraw the target token.");
        require(_token != WETH9, "Cannot withdraw WETH9 directly, use withdrawWETH");
        ERC20(_token).transfer(msg.sender, _amount);
        emit Withdraw(msg.sender, _token, _amount);
    }

    function withdrawWETH(uint256 _amount) public onlyOwner {
        IWETH9(WETH9).withdraw(_amount);
        payable(msg.sender).transfer(_amount);
        emit Withdraw(msg.sender, WETH9, _amount);
    }

    function setSwapFee(uint24 _newFee) public onlyOwner {
        swapFee = _newFee;
    }
    receive() external payable {
        _swapETHForToken(msg.value);
    }
}
