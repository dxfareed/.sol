//SPDX-License-Identifier:MIT

pragma solidity ^0.8.17;

contract UnburnableToken {
    mapping(address => uint256) public balances;
    uint256 public totalSupply;
    uint256 public totalClaimed;

    constructor() {
        totalSupply = 100000000;
        //totalSupply = 1000; for test
    }

    error TokensClaimed();
    error AllTokensClaimed();
    error UnsafeTransfer(address);

    function claim() public {
        if (totalClaimed == totalSupply) {
            revert AllTokensClaimed();
        }
        if (balances[msg.sender] != 0) {
            revert TokensClaimed();
        }
        balances[msg.sender] = 1000;
        totalClaimed += 1000;
    }

    //uint256 public test = msg.sender.balance;
    function safeTransfer(address _to, uint256 _amount) public {
        uint256 sendrBalnce = _to.balance;
        if (
            _to != 0x0000000000000000000000000000000000000000 &&
            (sendrBalnce > 0) &&
            balances[msg.sender] >= _amount
        ) {
            balances[msg.sender] = balances[msg.sender] - _amount;
            balances[_to] = _amount;
        } else {
            revert UnsafeTransfer(_to);
        }
    }
}
