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
