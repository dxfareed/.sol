//SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
contract Fund{
    //0x4aDC67696bA383F43DD60A9e78F2C97Fbbfc7cb1 eth
    //0x0FB99723Aee6f420beAD13e6bBB79b7E6F034298 btc
    function deposit() external payable{}
    function getPrice() internal view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0x0FB99723Aee6f420beAD13e6bBB79b7E6F034298
        );
        (, int256 answer, , , ) = priceFeed.latestRoundData();
        return uint256(answer);
    }
    uint public price = (getPrice()*1e10)/1e18;

    function withDraw(uint _number) public{
        _number = _number * 1e18; 
        payable(msg.sender).transfer(_number);
    }
    function balc() public view returns(uint256){
        return address(this).balance/1e18;
    }
}

/*
pragma solidity ^0.8.8;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract PriceConverter {
    uint public priceyet;
    // We could make this public, but then we'd have to deploy it
    function getPrice() external view returns (uint256) {
        // Sepolia ETH / USD Address
        // https://docs.chain.link/data-feeds/price-feeds/addresses#Sepolia%20Testnet
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0x3ec8593F930EA45ea58c968260e6e9FF53FC934f
        );
        (, int256 answer, , , ) = priceFeed.latestRoundData();
        priceyet=getPrice();
        // ETH/USD rate in 18 digit
        //return uint256(answer * 10000000000);
        return uint256(answer);
        // or (Both will do the same thing)
        // return uint256(answer * 1e10); // 1* 10 ** 10 == 10000000000
    }
}*/