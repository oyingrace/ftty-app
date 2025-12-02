// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title PlatformFee
 * @notice Handles marketplace platform fees. 
 *         Can be inherited by marketplace contracts.
 */

 contract PlatformFee {
    address public platformFeeRecipient;   // Address that receives platform fees
    uint96 public platformFeeBps;          // Fee in basis points (e.g., 250 = 2.5%)

    event PlatformFeeUpdated(uint96 newFeeBps);
    event PlatformFeeRecipientUpdated(address newRecipient);

    modifier validBps(uint96 bps) {
        require(bps <= 10000, "Fee too high");
        _;
    }