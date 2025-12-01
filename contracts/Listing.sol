// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/*
* Simple NFT Marketplace Listing Contract
* Features:
* - Create listing (non-custodial)
* - Cancel listing
* - Buy NFT with native token (ETH or chain currency)
* - Platform fee (e.g., 2%)
* - Safe NFT transfers
* - Reentrancy protection
*/

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract NFTMarketplace is ReentrancyGuard, AccessControl {
    bytes32 public constant MARKET_ADMIN = keccak256("MARKET_ADMIN");

uint256 public platformFeePercent; // e.g., 250 = 2.5%
    address public feeReceiver;

    struct Listing {
        address seller;
        address nft;
        uint256 tokenId;
        uint256 price;
        bool active;
    }

    uint256 public listingCounter = 0;
    mapping(uint256 => Listing> public listings;

// Events
    event ItemListed(
        uint256 listingId,
        address indexed seller,
        address indexed nft,
        uint256 indexed tokenId,
        uint256 price
    );

 event ListingCancelled(uint256 listingId);
    event ItemSold(
        uint256 listingId,
        address indexed buyer,
        uint256 price
    );

    constructor(uint256 _feePercent, address _feeReceiver) {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MARKET_ADMIN, msg.sender);

        platformFeePercent = _feePercent;
        feeReceiver = _feeReceiver;
    }

// --------------------------------------------------------
    // ADMIN
    // --------------------------------------------------------

function setPlatformFee(uint256 newFeePercent) external onlyRole(MARKET_ADMIN) {
        platformFeePercent = newFeePercent;
    }

    function setFeeReceiver(address newReceiver) external onlyRole(MARKET_ADMIN) {
        feeReceiver = newReceiver;
    }