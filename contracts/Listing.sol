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