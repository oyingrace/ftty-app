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