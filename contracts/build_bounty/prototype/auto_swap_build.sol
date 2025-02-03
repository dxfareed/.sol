 //SPDX-License-Identfier:MIT
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

pragma solidity >=0.8.0;

import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import "@uniswap/v3-periphery/contracts/interfaces/INonfungiblePositionManager.sol";
import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Factory.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract CreateUniswapV3Pool {
    address public immutable token;
    address public immutable WETH = 0x4200000000000000000000000000000000000006;
    address public immutable uniswapV3Factory = 0x4752ba5DBc23f44D87826276BF6Fd6b1C372aD24;
    address public immutable positionManager = 0x27F971cb582BF9E50F397e4d29a5C7A34f11faA2;

    constructor(address _token){
        token = _token;
    }

    function createPool(uint24 fee) external returns (address pool) {
        // Check if pool exists
        pool = IUniswapV3Factory(uniswapV3Factory).getPool(token, WETH, fee);
        require(pool == address(0), "Pool already exists");

        // Create pool
        pool = IUniswapV3Factory(uniswapV3Factory).createPool(token, WETH, fee);
    }

    function addLiquidity(
        uint256 tokenAmount,
        uint256 ethAmount,
        uint24 fee,
        int24 tickLower,
        int24 tickUpper
    ) external payable {
        require(msg.value == ethAmount, "ETH amount mismatch");

        // Approve tokens
        IERC20(token).approve(positionManager, tokenAmount);

        // Add liquidity
        INonfungiblePositionManager(positionManager).mint{
            value: ethAmount
        }(
            INonfungiblePositionManager.MintParams({
                token0: token,
                token1: WETH,
                fee: fee,
                tickLower: tickLower,
                tickUpper: tickUpper,
                amount0Desired: tokenAmount,
                amount1Desired: ethAmount,
                amount0Min: tokenAmount / 2, // Min token to avoid slippage
                amount1Min: ethAmount / 2,   // Min ETH to avoid slippage
                recipient: msg.sender,
                deadline: block.timestamp + 1200
            })
        );
    }
}
