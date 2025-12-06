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

    /**
     * @notice Create an auction for an ERC-721 token. Seller must approve this contract.
     * @param nft Address of ERC-721 contract
     * @param tokenId Token ID to auction
     * @param reservePrice Minimum required price (in wei)
     * @param startTime Auction start time (unix). Use block.timestamp to start immediately.
     * @param endTime Auction end time (unix). Must be > startTime.
     */

      function createAuction(
        address nft,
        uint256 tokenId,
        uint256 reservePrice,
        uint256 startTime,
        uint256 endTime
    ) external returns (uint256) {
        require(nft != address(0), "Invalid NFT");
        require(endTime > startTime, "end must be > start");
        require(IERC721(nft).ownerOf(tokenId) == msg.sender, "Not token owner");
        // marketplace doesn't take custody; seller must approve this contract to transfer on settlement
        // ownerOf check above ensures token exists and msg.sender is owner.
auctionCount++;
        auctions[auctionCount] = Auction({
            seller: msg.sender,
            nft: nft,
            tokenId: tokenId,
            reservePrice: reservePrice,
            startTime: startTime,
            endTime: endTime,
            highestBidder: address(0),
            highestBid: 0,
            settled: false
        });

        emit AuctionCreated(auctionCount, msg.sender, nft, tokenId, reservePrice, startTime, endTime);
        return auctionCount;
    }

     // -----------------------
    // BID
    // -----------------------
    /**
     * @notice Place a bid for a particular auction. Payable in native currency.
     * @param auctionId Auction identifier
     */

     function placeBid(uint256 auctionId) external payable nonReentrant {
        Auction storage a = auctions[auctionId];
        require(a.seller != address(0), "Auction does not exist");
        require(block.timestamp >= a.startTime, "Auction not started");
        require(block.timestamp < a.endTime, "Auction ended");
        require(msg.value > 0, "Must send ETH");

        uint256 minBid = a.highestBid == 0 ? a.reservePrice : (a.highestBid + ((a.highestBid * 5) / 100)); 
        // enforced min increment: if first bid, must meet reservePrice; afterwards require +5% increase
        // adjust increment logic as needed

         require(msg.value >= minBid, "Bid too low");

         address previousHighest = a.highestBidder;
        uint256 previousHighestBid = a.highestBid;

        // record new highest
        a.highestBidder = msg.sender;
        a.highestBid = msg.value;

        // push refund to previous highest (pull pattern)
        if (previousHighest != address(0)) {
            pendingReturns[previousHighest] += previousHighestBid;
        }

        // anti-sniping: if bid placed within timeBuffer, extend
        uint256 newEndTime = a.endTime;
        if (a.endTime - block.timestamp <= timeBuffer) {
            a.endTime = block.timestamp + timeBuffer;
            newEndTime = a.endTime;
        }

         emit BidPlaced(auctionId, msg.sender, msg.value, previousHighest, previousHighestBid, newEndTime);
    }

    // -----------------------
    // WITHDRAW REFUNDS
    // -----------------------

    /**
     * @notice Withdraw funds that were outbid.
     */
    function withdrawRefund() external nonReentrant {
        uint256 amount = pendingReturns[msg.sender];
        require(amount > 0, "No funds to withdraw");
        pendingReturns[msg.sender] = 0;
        (bool sent, ) = payable(msg.sender).call{value: amount}("");
        require(sent, "Withdraw failed");
    }

    // -----------------------
    // CANCEL AUCTION
    // -----------------------
    /**
     * @notice Seller can cancel an auction only if there are no bids.
     */
    function cancelAuction(uint256 auctionId) external nonReentrant {
        Auction storage a = auctions[auctionId];
        require(a.seller != address(0), "Auction does not exist");
        require(msg.sender == a.seller || hasRole(ADMIN_ROLE, msg.sender), "Not seller/admin");
        require(a.highestBidder == address(0), "Cannot cancel after bids");
        require(!a.settled, "Already settled");

        a.settled = true; // mark settled to prevent reuse
        emit AuctionCancelled(auctionId);
    }









