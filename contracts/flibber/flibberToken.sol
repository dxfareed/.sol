// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract FIBToken is ERC20, ERC20Burnable, Ownable {
    uint256 public constant TOKEN_PRICE_USD = 400; // $400 per token
    uint256 public constant FAUCET_AMOUNT = 9000000000000000; // 0.009 tokens (considering 18 decimals)
    uint256 public constant FAUCET_COOLDOWN = 24 hours;
    
    AggregatorV3Interface internal priceFeed;
    
    // Mapping to track last faucet request time for each address
    mapping(address => uint256) public lastFaucetRequest;
    
    // Events
    event TokensPurchased(address buyer, uint256 amount, uint256 cost);
    event TokensSold(address seller, uint256 amount, uint256 payment);
    event FaucetDispensed(address recipient, uint256 amount);

    constructor(
        address initialOwner,
        address _priceFeedAddress
    ) ERC20("FLIBBER", "$FIB") Ownable(initialOwner) {
        priceFeed = AggregatorV3Interface(_priceFeedAddress);
        _mint(msg.sender, 1000000 * 10 ** decimals());
    }

    // Faucet function to dispense tokens
    function requestFaucet() public {
        require(
            block.timestamp >= lastFaucetRequest[msg.sender] + FAUCET_COOLDOWN,
            "Please wait 24 hours between faucet requests"
        );
        
        require(
            balanceOf(address(this)) >= FAUCET_AMOUNT,
            "Faucet is empty"
        );

        lastFaucetRequest[msg.sender] = block.timestamp;
        _transfer(address(this), msg.sender, FAUCET_AMOUNT);
        
        emit FaucetDispensed(msg.sender, FAUCET_AMOUNT);
    }

    // Check time remaining until next faucet request
    function timeUntilNextFaucet(address user) public view returns (uint256) {
        uint256 timePassed = block.timestamp - lastFaucetRequest[user];
        if (timePassed >= FAUCET_COOLDOWN) {
            return 0;
        }
        return FAUCET_COOLDOWN - timePassed;
    }

    // Get the latest ETH/USD price from Chainlink
    function getLatestPrice() public view returns (uint256) {
        (, int256 price,,,) = priceFeed.latestRoundData();
        return uint256(price) * 1e10; // Convert to 18 decimals
    }

    // Calculate how many tokens can be bought with the provided ETH
    function getTokenAmount(uint256 ethAmount) public view returns (uint256) {
        uint256 ethUsdPrice = getLatestPrice();
        uint256 ethValueInUsd = (ethAmount * ethUsdPrice) / 1e18;
        return (ethValueInUsd * 1e18) / (TOKEN_PRICE_USD * 1e18);
    }

    // Buy tokens with ETH
    function buyTokens() public payable {
        require(msg.value > 0, "Must send ETH to buy tokens");
        
        uint256 tokenAmount = getTokenAmount(msg.value);
        require(tokenAmount > 0, "ETH amount too small");
        
        _mint(msg.sender, tokenAmount);
        
        emit TokensPurchased(msg.sender, tokenAmount, msg.value);
    }

    // Sell tokens back for ETH
    function sellTokens(uint256 tokenAmount) public {
        require(tokenAmount > 0, "Must sell more than 0 tokens");
        require(balanceOf(msg.sender) >= tokenAmount, "Insufficient token balance");

        uint256 ethUsdPrice = getLatestPrice();
        uint256 usdValue = tokenAmount * TOKEN_PRICE_USD;
        uint256 ethAmount = (usdValue * 1e18) / ethUsdPrice;

        require(address(this).balance >= ethAmount, "Insufficient contract balance");

        _burn(msg.sender, tokenAmount);
        payable(msg.sender).transfer(ethAmount);

        emit TokensSold(msg.sender, tokenAmount, ethAmount);
    }

    // Fund the faucet
    function fundFaucet(uint256 amount) public onlyOwner {
        require(amount > 0, "Amount must be greater than 0");
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
        _transfer(msg.sender, address(this), amount);
    }

    // Allow the contract to receive ETH
    receive() external payable {}

    // Owner functions
    function withdrawETH() public onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No ETH to withdraw");
        payable(owner()).transfer(balance);
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function setPriceFeed(address newPriceFeed) public onlyOwner {
        require(newPriceFeed != address(0), "Invalid price feed address");
        priceFeed = AggregatorV3Interface(newPriceFeed);
    }
}