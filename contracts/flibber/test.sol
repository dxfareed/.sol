// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @dev OpenZeppelin Contracts (last updated v5.1.0) (utils/ReentrancyGuard.sol)
 */
abstract contract ReentrancyGuard {
    uint256 private constant NOT_ENTERED = 1;
    uint256 private constant ENTERED = 2;

    uint256 private _status;

    /// @dev Unauthorized reentrant call.
    error ReentrancyGuardReentrantCall();

    constructor() {
        _status = NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     */
    modifier nonReentrant() {
        _nonReentrantBefore();
        _;
        _nonReentrantAfter();
    }

    function _nonReentrantBefore() private {
        if (_status == ENTERED) {
            revert ReentrancyGuardReentrantCall();
        }
        _status = ENTERED;
    }

    function _nonReentrantAfter() private {
        _status = NOT_ENTERED;
    }

    function _reentrancyGuardEntered() internal view returns (bool) {
        return _status == ENTERED;
    }
}

// Import OpenZeppelin's IERC20 and ECDSA libraries.
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol"; 
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/cryptography/ECDSA.sol";

contract EthBridge is ReentrancyGuard {
    using ECDSA for bytes32;

    address public admin;
    // For testing on Sepolia, we use placeholder/mock addresses.
    IERC20 public usdc = IERC20(0x1241676d45b1Cb5B573b6258C4A838e149A1D191); // mock USDC address
    IERC20 public fib  = IERC20(0x132Ca3eff205D1f01A71e3D2E41B00056AF5c64E); // mock $FIB address

    // Fee required in $FIB tokens per bridging transaction (e.g., 10 FIB assuming 18 decimals)
    uint256 public fibFee = 10 * 10**18;

    // Mapping to track user deposits (USDC amounts locked)
    mapping(address => uint256) public deposits;
    // Mapping for meta-transaction nonces to prevent replay attacks
    mapping(address => uint256) public nonces;

    // Events for off-chain relayers/validators to detect deposits.
    event TokensLocked(address indexed user, uint256 amount, uint256 timestamp);
    event MetaTransactionExecuted(
        address indexed user,
        address indexed relayer,
        uint256 usdcAmount,
        uint256 fee,
        uint256 nonce
    );

    constructor() {
        admin = msg.sender;
    }

    /// @notice Direct bridging function: user calls and pays gas in ETH.
    /// The user must approve this contract to spend both their USDC and $FIB tokens.
    function bridgeTokens(uint256 usdcAmount) external nonReentrant {
        require(usdcAmount > 0, "Amount must be > 0");

        // Transfer fee in $FIB tokens from the user to the admin (or fee collector).
        require(fib.transferFrom(msg.sender, admin, fibFee), "FIB fee transfer failed");

        // Transfer USDC tokens from the user to this contract (locking the tokens).
        require(usdc.transferFrom(msg.sender, address(this), usdcAmount), "USDC transfer failed");

        deposits[msg.sender] += usdcAmount;

        // Emit event so off-chain relayers can process the bridge (e.g., trigger mint on Solana).
        emit TokensLocked(msg.sender, usdcAmount, block.timestamp);
    }

    /// @notice Meta-Transaction bridging function: allows a relayer to submit a user's signed transaction.
    /// The user must sign the data (user address, amount, fee, nonce, contract address) off-chain.
    function bridgeTokensMeta(
        address user,
        uint256 usdcAmount,
        uint256 fee,
        uint256 nonce,
        bytes memory signature
    ) external nonReentrant {
        require(usdcAmount > 0, "Amount must be > 0");
        require(nonce == nonces[user], "Invalid nonce");

        // Create the message hash including the contract address to avoid cross-contract replay.
        bytes32 messageHash = keccak256(abi.encodePacked(user, usdcAmount, fee, nonce, address(this)));
        // Compute the Ethereum Signed Message hash using our helper function.
        bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);

        // Verify the signature matches the user.
        require(ethSignedMessageHash.recover(signature) == user, "Invalid signature");

        // Increase the nonce to prevent replay attacks.
        nonces[user]++;

        // Transfer fee in $FIB tokens.
        require(fib.transferFrom(user, admin, fee), "FIB fee transfer failed");

        // Transfer USDC tokens (locking the tokens).
        require(usdc.transferFrom(user, address(this), usdcAmount), "USDC transfer failed");

        deposits[user] += usdcAmount;
        emit MetaTransactionExecuted(user, msg.sender, usdcAmount, fee, nonce);
    }

    /// @notice Admin function to update the $FIB fee if needed.
    function updateFibFee(uint256 newFee) external {
        require(msg.sender == admin, "Only admin can update fee");
        fibFee = newFee;
    }

    /// @dev Helper function to compute the Ethereum Signed Message hash.
    function getEthSignedMessageHash(bytes32 messageHash) internal pure returns (bytes32) {
        // Mimics the behavior of ECDSA.toEthSignedMessageHash
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", messageHash));
    }
}
