// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/*
 * AuctionHouse.sol
 *
 * Multi-auction English AuctionHouse for ERC-721 items.
 * - Sellers create auctions (must approve this contract to transfer the token).
 * - Buyers place bids (ETH/native currency).
 * - Previous highest bids are stored as refunds (pull pattern).
 * - Anti-sniping: bids placed within timeBuffer extend the auction end.
 * - Platform fee (bps) and ERC-2981 royalties are supported on settlement.
 *
 * NOTE: test thoroughly on a testnet before production.
 */

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";

contract AuctionHouse is ReentrancyGuard, AccessControl {
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");

     // Platform fee (basis points). 10000 bps = 100%
    uint96 public platformFeeBps;
    address public platformFeeRecipient;

    // Anti-sniping time extension buffer (seconds)
    uint256 public timeBuffer = 300; // e.g., 300s = 5 minutes

    uint256 public auctionCount;

    struct Auction {
        address seller;
        address nft;
        uint256 tokenId;
        uint256 reservePrice; // minimum required to start sale
        uint256 startTime; // unix timestamp
        uint256 endTime;   // unix timestamp
        address highestBidder;
        uint256 highestBid;
        bool settled;
    }

    // auctionId => Auction
    mapping(uint256 => Auction) public auctions;

    // bidder => amount available to withdraw (refunds)
    mapping(address => uint256) public pendingReturns;

    // Events
    event AuctionCreated(
        uint256 indexed auctionId,
        address indexed seller,
        address indexed nft,
        uint256 tokenId,
        uint256 reservePrice,
        uint256 startTime,
        uint256 endTime
    );

    event BidPlaced(
        uint256 indexed auctionId,
        address indexed bidder,
        uint256 amount,
        address indexed previousHighestBidder,
        uint256 previousHighestBid,
        uint256 newEndTime
    );

    event AuctionCancelled(uint256 indexed auctionId);
    event AuctionSettled(
        uint256 indexed auctionId,
        address indexed winner,
        uint256 amount
    );

// Constructor
    constructor(address _platformFeeRecipient, uint96 _platformFeeBps) {
        require(_platformFeeRecipient != address(0), "Invalid fee recipient");
        require(_platformFeeBps <= 10000, "Bps > 10000");

         _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(ADMIN_ROLE, msg.sender);

         platformFeeRecipient = _platformFeeRecipient;
        platformFeeBps = _platformFeeBps;
    }

     // -----------------------
    // ADMIN FUNCTIONS
    // -----------------------

 function setPlatformFeeRecipient(address _recipient) external onlyRole(ADMIN_ROLE) {
        require(_recipient != address(0), "Invalid address");
        platformFeeRecipient = _recipient;
    }

    function setPlatformFeeBps(uint96 _bps) external onlyRole(ADMIN_ROLE) {
        require(_bps <= 10000, "Bps > 10000");
        platformFeeBps = _bps;
    }

    function setTimeBuffer(uint256 _timeBuffer) external onlyRole(ADMIN_ROLE) {
        timeBuffer = _timeBuffer;
    }

     // -----------------------
    // CREATE AUCTION
    // -----------------------





