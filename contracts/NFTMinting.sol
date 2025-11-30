// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/*
 * Simple NFT minting contract
 * - ERC721Enumerable for easy enumeration (optional but convenient)
 * - Ownable for admin actions
 * - ReentrancyGuard to protect withdrawal
 *
 * Notes:
 * - Adjust MAX_SUPPLY, MAX_PER_WALLET, and MINT_PRICE as needed.
 * - This is a simple public mint. Add whitelist/merkle proofs if needed.
 */