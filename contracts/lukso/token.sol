// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.15;


interface ILSP7{
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    function owner() external view returns (address);
    function transferOwnership(address newOwner) external; // onlyOwner
    function renounceOwnership() external; // onlyOwner
    event DataChanged(bytes32 indexed dataKey, bytes dataValue);
    function getData(bytes32 dataKey) external view returns (bytes memory value);
    function setData(bytes32 dataKey, bytes memory value) external; // onlyOwner
    function getDataBatch(bytes32[] memory dataKeys) external view returns (bytes[] memory values);
    function setDataBatch(bytes32[] memory dataKeys, bytes[] memory values) external; // onlyOwner
    event Transfer(address indexed operator, address indexed from, address indexed to, uint256 amount, bool force, bytes data);
    event OperatorAuthorizationChanged(address indexed operator, address indexed tokenOwner, uint256 indexed amount, bytes operatorNotificationData);
    event OperatorRevoked(address indexed operator, address indexed tokenOwner, bool indexed notified, bytes operatorNotificationData);
    function decimals() external view returns (uint8);
    function totalSupply() external view returns (uint256);
    function balanceOf(address tokenOwner) external view returns (uint256);
    function authorizeOperator(address operator, uint256 amount, bytes memory operatorNotificationData) external;
    function revokeOperator(address operator, address tokenOwner, bool notify, bytes memory operatorNotificationData) external;
    function increaseAllowance(address operator, uint256 addedAmount, bytes memory operatorNotificationData) external;
    function decreaseAllowance(address operator, address tokenOwner, uint256 subtractedAmount, bytes memory operatorNotificationData) external;
    function authorizedAmountFor(address operator, address tokenOwner) external view returns (uint256);
    function getOperatorsOf(address tokenOwner) external view returns (address[] memory);
    function transfer(address from, address to, uint256 amount, bool force, bytes memory data) external;
    function transferBatch(address[] memory from, address[] memory to, uint256[] memory amount, bool[] memory force, bytes[] memory data) external;
    function batchCalls(bytes[] memory data) external returns (bytes[] memory results);
}

contract MyLSP7Toke {
    constructor(
        string memory name, // Name of the token
        string memory symbol, // Symbol of the token
        address tokenOwner, // Owner able to add extensions and change metadata
        uint256 lsp4tokenType, // 0 if representing a fungible token, 1 if representing an NFT
        bool isNonDivisible // false for decimals equal to 18, true for decimals equal to 0
    ) ILSP7(name, symbol, tokenOwner, lsp4tokenType, isNonDivisible) {
        // _mint(to, amount, force, data)
        // force: should be set to true to allow EOA to receive tokens
        // data: only relevant if the `to` is a smart contract supporting LSP1.
        _mint(tokenOwner, 200000, true, "");
    }
}