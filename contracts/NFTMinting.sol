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

 import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
