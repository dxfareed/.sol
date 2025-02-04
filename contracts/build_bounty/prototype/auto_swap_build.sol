//SPDX-License-Identfier:UNLICENSED;
/*
pragma solidity >=0.8.0;

import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";

contract AutoSwapDonation{

    ISwapRouter public immutable swapRouter;
    address public immutable token;
    address public constant WETH9 = 0x4200000000000000000000000000000000000006;
    constructor( address _token) {
        swapRouter = ISwapRouter(0x050E797f3625EC8785265e1d9BDd4799b97528A1);
        token = _token;
    }

    receive() external payable {
        swapETHForToken(msg.value);
    }

    function swapETHForToken(uint256 amount) internal {
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

        swapRouter.exactInputSingle{value: amount}(params);
    }


} */

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "https://github.com/cakezero/mode-ai-agent-hackathon/blob/main/smart-contract/interface/IUniswapV2Router.sol";
import "https://github.com/cakezero/mode-ai-agent-hackathon/blob/main/smart-contract/interface/IUniswapV2Factory.sol";

contract LiquidityContract{

   
    address public constant UNISWAP_V2_ROUTER =
        0x050E797f3625EC8785265e1d9BDd4799b97528A1;

    address public constant UNISWAP_V2_FACTORY = 0x9fBFa493EC98694256D171171487B9D47D849Ba9;

    error MustSendETH();
    error MustSpecifyTokenAmount();

    address public memeToken = 0x0a0E0FccC2c799845214E8E5583E44479EC02a23;
    address public pair;
    address public weth;
    IUniswapV2Router public uniswapRouter;

    constructor(address _token) {
        // deploy the meme token
        memeToken = _token;
        uniswapRouter = IUniswapV2Router(UNISWAP_V2_ROUTER);

        weth = uniswapRouter.WETH();

        IERC20(memeToken).approve(UNISWAP_V2_ROUTER, type(uint256).max);

        pair = IUniswapV2Factory(UNISWAP_V2_FACTORY).createPair(memeToken, weth);
    }

    // Swap ETH for Meme Token
    function swapETHForMeme() external payable {
        if (msg.value <= 0) revert MustSendETH();

        address[] memory path;
        path = new address[](2);

        path[0] = weth; // ModeETH address
        path[1] = memeToken; // Meme token address

        uniswapRouter.swapExactETHForTokens{value: msg.value}(
            0,
            path,
            msg.sender, // Send Meme tokens to the user
            block.timestamp + 360
        );
    }

    function getTokenAddress() external view returns (address) {
        return memeToken;
    }

    // Swap Meme Token for ETH
    function swapMemeForETH(
        uint256 amountIn
    ) external {
        if (amountIn <= 0) revert MustSpecifyTokenAmount();

        address[] memory path;
        path = new address[](2);

        path[0] = memeToken; // Meme token address
        path[1] = weth; // WETH address

        // Transfer Meme tokens from user to this contract
        IERC20(memeToken).transferFrom(msg.sender, address(this), amountIn);

        // Perform the swap
        uniswapRouter.swapExactTokensForETH(
            amountIn,
            0,
            path,
            msg.sender, // Send ETH to the user
            block.timestamp + 360
        );
    }

    // Add liquidity to the Meme Token and ETH pool
    function addLiquidityETH(
        uint256 amountTokenDesired
    ) external payable {
        if (msg.value <= 0) revert MustSendETH();

        if (amountTokenDesired <= 0) revert MustSpecifyTokenAmount();

        // Transfer Meme tokens from user to this contract
        IERC20(memeToken).transferFrom(msg.sender, address(this), amountTokenDesired);

        // Add liquidity
        uniswapRouter.addLiquidityETH{value: msg.value}(
            memeToken,
            amountTokenDesired,
            0,
            0,
            msg.sender, // LP tokens sent to the user
            block.timestamp + 360
        );
    }

    // Receive function to accept ETH
    receive() external payable {}


    /* error MustSendETH();
    error MustSpecifyTokenAmount();
    function AddLiquidity(uint256 amountTokenDesired) external payable {
         if (msg.value <= 0) revert MustSendETH();

        if (amountTokenDesired <= 0) revert MustSpecifyTokenAmount();

        // Transfer Meme tokens from user to this contract
        IERC20(memeToken).transferFrom(msg.sender, address(this), amountTokenDesired);

        // Add liquidity
        uniswapRouter.addLiquidityETH{value: msg.value}(
            memeToken,
            amountTokenDesired,
            0,
            0,
            msg.sender, // LP tokens sent to the user
            block.timestamp + 360
        );
    } */
}