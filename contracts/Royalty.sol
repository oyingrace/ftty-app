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

    /**
     * @notice Set default royalty info (applies to all tokenIds that don't have specific royalty)
     * @param receiver address to receive royalty
     * @param feeNumerator royalty fraction in basis points (uses _feeDenominator())
     */
    function setDefaultRoyalty(address receiver, uint96 feeNumerator) external onlyRole(ROYALTY_ADMIN) {
        require(receiver != address(0), "Invalid receiver");
        _setDefaultRoyalty(receiver, feeNumerator);
        emit DefaultRoyaltySet(receiver, feeNumerator);
    }

    /**
     * @notice Remove default royalty
     */
    function deleteDefaultRoyalty() external onlyRole(ROYALTY_ADMIN) {
        _deleteDefaultRoyalty();
        emit DefaultRoyaltyDeleted();
    }

    /**
     * @notice Set royalty for a specific tokenId (overrides default)
     * @param tokenId token id to set royalty for
     * @param receiver address to receive royalty
     * @param feeNumerator royalty fraction in basis points
     */
     function setTokenRoyalty(
        uint256 tokenId,
        address receiver,
        uint96 feeNumerator
          ) external onlyRole(ROYALTY_ADMIN) {
        require(receiver != address(0), "Invalid receiver");
        _setTokenRoyalty(tokenId, receiver, feeNumerator);
        emit TokenRoyaltySet(tokenId, receiver, feeNumerator);
    }
    /**
     * @notice Reset token royalty to default (removes token-specific royalty)
     * @param tokenId token id to reset
     */
    function resetTokenRoyalty(uint256 tokenId) external onlyRole(ROYALTY_ADMIN) {
        _resetTokenRoyalty(tokenId);
        emit TokenRoyaltyReset(tokenId);
    }
    /**
     * @notice Change or grant ROYALTY_ADMIN role to another address
     * Only DEFAULT_ADMIN_ROLE can grant/revoke roles (inherited from AccessControl)
     */

    /**
     * @notice Override supportsInterface to include ERC2981 & AccessControl
     */