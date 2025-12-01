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

    // ----------------------------------------
    // Create Offer (funds locked)
    // ----------------------------------------

    function createOffer(address nft, uint256 tokenId)
        external
        payable
        nonReentrant
        returns (uint256)

         {
        require(msg.value > 0, "Offer cannot be zero");

        offerCounter++;
        offers[offerCounter] = Offer(
            msg.sender,
            nft,
            tokenId,
            msg.value,
            true
        );

        emit OfferCreated(
            offerCounter,
            msg.sender,
            nft,
            tokenId,
            msg.value
        );

        return offerCounter;
    }

    // ----------------------------------------
    // Update Offer (add more ETH)
    // ----------------------------------------

    function increaseOffer(uint256 offerId)
        external
        payable
        nonReentrant
        {
        Offer storage o = offers[offerId];
        require(o.active, "Offer inactive");
        require(o.offerer == msg.sender, "Not offer owner");
        require(msg.value > 0, "Increase must be > 0");
         o.amount += msg.value;
        emit OfferUpdated(offerId, o.amount);
    }