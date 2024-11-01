//SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

contract firstToken is ERC20 {
    address private _ownerFirstToken;

    constructor(string memory _name, string memory _symbol)
        ERC20(_name, _symbol)
    {
        _mint(msg.sender, 1000);
        _ownerFirstToken = msg.sender;
    }

    function pumptit(uint256 _pumpMint) public {
        require(_ownerFirstToken == msg.sender, "Not owner!");

        _mint(msg.sender, _pumpMint);
    }
}
