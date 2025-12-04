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


