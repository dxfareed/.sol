// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@chainlink/contracts/src/v0.8/ccip/interfaces/IRouterClient.sol";
import "@chainlink/contracts/src/v0.8/ccip/libraries/Client.sol";
import "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import "./fibtoken.sol";

contract FIBSlottingMechanism is Ownable, ReentrancyGuard {
    IRouterClient private immutable i_router;
    IERC20 public immutable fibToken;

    //router 0x2f16873EE9970059B60857946f0343a8F655111C
    // 1000000000000000000
    //fibtoken 0x132Ca3eff205D1f01A71e3D2E41B00056AF5c64E
    
    // Chainlink price feeds
    mapping(address => AggregatorV3Interface) public tokenPriceFeeds;
    
    // User balances for each token
    mapping(address => mapping(address => uint256)) public userTokenBalances;
    
    // Supported tokens
    mapping(address => bool) public supportedTokens;
    
    // Bridge fee in FIB tokens
    uint256 public bridgeFeeInFIB;
    
    // Destination chain gas limits
    mapping(uint64 => uint256) public chainGasLimits;
    
    // Events
    event TokenSupported(address indexed token, address indexed priceFeed);
    event SlotIn(address indexed user, address indexed token, uint256 amount);
    event SlotOut(
        address indexed user,
        address indexed token,
        uint256 amount,
        uint64 destinationChain,
        uint256 fibFeesPaid
    );
    event MessageSent(bytes32 indexed messageId);
    event BridgeFeeUpdated(uint256 newFee);
    event ChainGasLimitUpdated(uint64 chainSelector, uint256 gasLimit);

    constructor(
        address _router,
        address _fibToken,
        uint256 _initialBridgeFee
    ) Ownable(msg.sender) {
        require(_router != address(0), "Invalid router address");
        require(_fibToken != address(0), "Invalid FIB token address");
        
        i_router = IRouterClient(_router);
        fibToken = IERC20(_fibToken);
        bridgeFeeInFIB = _initialBridgeFee;
        
        // Add initial supported chains gas limits
        chainGasLimits[16015286601757825753] = 200000; // Sepolia
        chainGasLimits[12532609583862916517] = 200000; // Mumbai
        chainGasLimits[14767482510784806043] = 200000; // Fuji
    }

    function addSupportedToken(
        address token,
        address priceFeed
    ) external onlyOwner {
        require(token != address(0), "Invalid token address");
        require(priceFeed != address(0), "Invalid price feed address");
        require(!supportedTokens[token], "Token already supported");

        supportedTokens[token] = true;
        tokenPriceFeeds[token] = AggregatorV3Interface(priceFeed);
        
        emit TokenSupported(token, priceFeed);
    }

    function slotIn(address token, uint256 amount) external nonReentrant {
        require(supportedTokens[token], "Token not supported");
        require(amount > 0, "Amount must be greater than 0");

        // Transfer tokens to contract
        require(
            IERC20(token).transferFrom(msg.sender, address(this), amount),
            "Token transfer failed"
        );
        
        userTokenBalances[token][msg.sender] += amount;
        
        emit SlotIn(msg.sender, token, amount);
    }
    //000000000000000000
    function slotInETH() external payable nonReentrant {
        require(msg.value > 0, "Must send ETH");
        require(supportedTokens[address(0)], "ETH not supported");
        
        userTokenBalances[address(0)][msg.sender] += msg.value;
        
        emit SlotIn(msg.sender, address(0), msg.value);
    }

    function slotOut(
        address token,
        uint256 amount,
        uint64 destinationChainSelector,
        address receiver
    ) external nonReentrant {
        require(supportedTokens[token], "Token not supported");
        require(amount > 0, "Amount must be greater than 0");
        require(chainGasLimits[destinationChainSelector] > 0, "Chain not supported");
        require(
            userTokenBalances[token][msg.sender] >= amount,
            "Insufficient balance"
        );
        require(
            fibToken.balanceOf(msg.sender) >= bridgeFeeInFIB,
            "Insufficient FIB balance for fee"
        );

        // Calculate USD value
        uint256 usdValue = getTokenValueInUSD(token, amount);
        
        // Deduct balance before external calls
        userTokenBalances[token][msg.sender] -= amount;
        
        // Transfer FIB tokens for bridge fee
        require(
            fibToken.transferFrom(msg.sender, address(this), bridgeFeeInFIB),
            "FIB fee transfer failed"
        );

        // Prepare CCIP message
        Client.EVM2AnyMessage memory message = Client.EVM2AnyMessage({
            receiver: abi.encode(receiver),
            data: abi.encode(token, amount, usdValue),
            tokenAmounts: new Client.EVMTokenAmount[](0),
            extraArgs: "",  // Changed to empty string as default
            feeToken: address(0)
        });

        // Get CCIP fee
        uint256 ccipFee = i_router.getFee(destinationChainSelector, message);
        
        // Send CCIP message
        bytes32 messageId = i_router.ccipSend{value: ccipFee}(
            destinationChainSelector,
            message
        );

        emit SlotOut(
            msg.sender,
            token,
            amount,
            destinationChainSelector,
            bridgeFeeInFIB
        );
        emit MessageSent(messageId);
    }

    function getTokenValueInUSD(
        address token,
        uint256 amount
    ) public view returns (uint256) {
        AggregatorV3Interface priceFeed = tokenPriceFeeds[token];
        require(address(priceFeed) != address(0), "Price feed not found");

        (, int256 price,,,) = priceFeed.latestRoundData();
        require(price > 0, "Invalid price");
        
        return (amount * uint256(price)) / 1e18;
    }

    // Admin functions
    function setBridgeFee(uint256 newFeeAmount) external onlyOwner {
        bridgeFeeInFIB = newFeeAmount;
        emit BridgeFeeUpdated(newFeeAmount);
    }

    function setChainGasLimit(
        uint64 chainSelector,
        uint256 gasLimit
    ) external onlyOwner {
        chainGasLimits[chainSelector] = gasLimit;
        emit ChainGasLimitUpdated(chainSelector, gasLimit);
    }

    function withdrawToken(address token) external onlyOwner {
        if (token == address(0)) {
            uint256 balance = address(this).balance;
            require(balance > 0, "No ETH to withdraw");
            (bool success, ) = payable(owner()).call{value: balance}("");
            require(success, "ETH transfer failed");
        } else {
            uint256 balance = IERC20(token).balanceOf(address(this));
            require(balance > 0, "No tokens to withdraw");
            require(
                IERC20(token).transfer(owner(), balance),
                "Token transfer failed"
            );
        }
    }

    receive() external payable {}
}
