//SPDX-License-Identifier: MIT

pragma solidity >=0.8.17;

contract SimpleStorage {
    mapping(address => uint256) StorageWitAdrress;

    error UserNotFound();
    
    address[] NumUsers;

    function addFavNum(uint256 _favNum) public {
        StorageWitAdrress[msg.sender] = _favNum;
        NumUsers.push(msg.sender);
    }

    function DisplayFavoriteNum() public view returns (uint256) {
        return StorageWitAdrress[msg.sender];
    }

    modifier onlyOwner() {
        bool _checkUser = false;
        for (uint256 i; i < NumUsers.length; i++) {
            if (NumUsers[i] == msg.sender) {
                _checkUser = true;
            }
        }
        if (StorageWitAdrress[msg.sender]==0 && !_checkUser) {
            revert UserNotFound();
        }
        _;
    }
}

/*

pragma solidity >=0.8.0;

contract RecieveText{
    uint public result;
    error SendBack();
    receive()external payable{
        if(msg.value<=0){
            revert SendBack();  
        }
        result+=5;
    }
}

pragma solidity ^0.8.8;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

// Why is this a library and not abstract?
// Why not an interface?
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
}
*/