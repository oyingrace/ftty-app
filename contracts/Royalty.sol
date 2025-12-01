// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/*
 * ERC-2981 Royalty Implementation
 * - Uses OpenZeppelin ERC2981 base implementation
 * - AccessControl for admin role
 * - Manage default royalty and token-specific royalties
 *
 * Note:
 * - feeNumerator is in basis points relative to _feeDenominator() (default 10000).
 *   e.g., feeNumerator = 500 => 5.00%
 */

 import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";

contract RoyaltyManager is ERC2981, AccessControl {
    bytes32 public constant ROYALTY_ADMIN = keccak256("ROYALTY_ADMIN");

    event DefaultRoyaltySet(address indexed receiver, uint96 feeNumerator);
    event DefaultRoyaltyDeleted();
    event TokenRoyaltySet(uint256 indexed tokenId, address indexed receiver, uint96 feeNumerator);
    event TokenRoyaltyReset(uint256 indexed tokenId);

    constructor(address initialAdmin) {
        require(initialAdmin != address(0), "Zero admin");
        _grantRole(DEFAULT_ADMIN_ROLE, initialAdmin);
        _grantRole(ROYALTY_ADMIN, initialAdmin);
    }