// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract Payments is Ownable, ReentrancyGuard, Pausable {
    using SafeERC20 for IERC20;

    // Track balances owed to recipients (pull pattern)
    mapping(address => uint256) public pendingWithdrawals;

    // Optional platform fee (basis points, e.g., 100 = 1%)
    uint256 public platformFeeBps;
    address public feeCollector;

   event Received(address indexed from, uint256 amount, string indexed reference);
    event PaymentScheduled(address indexed from, address indexed to, uint256 amount, string indexed reference);
    event Withdrawn(address indexed recipient, uint256 amount);
    event ERC20Withdrawn(address indexed token, address indexed recipient, uint256 amount);
    event PlatformFeeUpdated(uint256 newBps);
    event FeeCollectorUpdated(address newCollector);
    event EmergencyWithdraw(address indexed recipient, uint256 amount);

constructor(address _feeCollector, uint256 _platformFeeBps) {
        require(_feeCollector != address(0), "invalid fee collector");
        require(_platformFeeBps <= 10_000, "bps too large");
        feeCollector = _feeCollector;
        platformFeeBps = _platformFeeBps;
    }

// Allow contract to receive ETH directly
    receive() external payable {
        emit Received(msg.sender, msg.value, "");
        // Keep funds in contract for later scheduling/withdraw or manual distribution
    }

    /// @notice Send a payment to an address. Payment is credited to recipient's pendingWithdrawals.
    /// @param recipient recipient address
    /// @param reference optional description/reference
    function payTo(address recipient, string calldata reference) external payable whenNotPaused nonReentrant {
        require(msg.value > 0, "no value");
        require(recipient != address(0), "invalid recipient");

        uint256 fee = _takePlatformFee(msg.value);
        uint256 net = msg.value - fee;

        pendingWithdrawals[recipient] += net;

        emit PaymentScheduled(msg.sender, recipient, net, reference);
    }

     /// @notice Schedule a payment on behalf of the contract owner (owner-funded payout)
    function ownerCredit(address recipient, uint256 amount, string calldata reference) external onlyOwner whenNotPaused {
        require(recipient != address(0), "invalid recipient");
        require(address(this).balance >= amount, "insufficient contract balance");

        uint256 fee = _takePlatformFee(amount);
        uint256 net = amount - fee;

        pendingWithdrawals[recipient] += net;

        emit PaymentScheduled(msg.sender, recipient, net, reference);
    }

    /// @notice Withdraw accumulated ETH owed to sender
    function withdraw() external nonReentrant whenNotPaused {
        uint256 amount = pendingWithdrawals[msg.sender];
        require(amount > 0, "nothing to withdraw");

        pendingWithdrawals[msg.sender] = 0;
        (bool sent, ) = payable(msg.sender).call{value: amount}("");
        require(sent, "transfer failed");

        emit Withdrawn(msg.sender, amount);
    }

    /// @notice Withdraw ERC20 tokens (if contract holds tokens that belong to a recipient)
    /// Note: This contract doesn't automatically credit ERC20 payments. Owner can credit via ownerCreditERC20.
    function withdrawERC20(IERC20 token) external nonReentrant whenNotPaused {
        // We keep a simple mapping for ERC20 pending balances by token+address in more advanced implementations.
        revert("use ownerCreditERC20 pattern or extend contract");
    }

    /// @notice Owner can credit ERC20 tokens to a recipient (pull pattern).
    function ownerCreditERC20(IERC20 token, address recipient, uint256 amount, string calldata reference) external onlyOwner whenNotPaused {
        require(recipient != address(0), "invalid recipient");
        require(amount > 0, "invalid amount");

        // The owner must have transferred tokens to this contract prior to calling
        // or this function could be combined to pull tokens from owner via allowance.
        // For simplicity, we track token balances off-chain or extend mapping per token.
        // (Implementation note provided below)
        revert("implement token bookkeeping if you need ERC20 pull-payments");
    }

    // -------------------------
    // Admin functions
    // -------------------------

    function setPlatformFeeBps(uint256 bps) external onlyOwner {
        require(bps <= 10_000, "bps > 100%");
        platformFeeBps = bps;
        emit PlatformFeeUpdated(bps);
    }

function setFeeCollector(address collector) external onlyOwner {
        require(collector != address(0), "invalid");
        feeCollector = collector;
        emit FeeCollectorUpdated(collector);
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

     /// Emergency withdraw by owner (for recovery). Use carefully.
    function emergencyWithdraw(address payable to, uint256 amount) external onlyOwner {
        require(to != address(0), "invalid");
        require(amount <= address(this).balance, "insufficient balance");
        (bool sent, ) = to.call{value: amount}("");
        require(sent, "transfer failed");
        emit EmergencyWithdraw(to, amount);
    }

// -------------------------
    // Internal helpers
    // -------------------------

    function _takePlatformFee(uint256 amount) internal returns (uint256 fee) {
        if (platformFeeBps == 0) return 0;
        fee = (amount * platformFeeBps) / 10_000;
        if (fee == 0) return 0;

        // transfer fee immediately
        (bool ok, ) = payable(feeCollector).call{value: fee}("");
        require(ok, "fee transfer failed");
    }
}