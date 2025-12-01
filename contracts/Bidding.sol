// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/*
 * Offer / Bidding Contract for ERC-721 NFTs
 * Features:
 * - Buyers lock funds as offers
 * - Sellers accept offers
 * - Refund on cancel
 * - Platform fee on accepted offers
 * - Non-custodial NFT handling
 */

 // Events
    event OfferCreated(
        uint256 indexed offerId,
        address indexed offerer,
        address indexed nft,
        uint256 tokenId,
        uint256 amount
    );

     function setPlatformFee(uint256 newFeePercent) external onlyRole(MARKET_ADMIN) {
        platformFeePercent = newFeePercent;
    }

    function setFeeReceiver(address newReceiver) external onlyRole(MARKET_ADMIN) {
        feeReceiver = newReceiver;
    }