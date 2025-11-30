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

contract SimpleMintNFT is ERC721Enumerable, Ownable, ReentrancyGuard {
    using Strings for uint256;

   // Configurable parameters
    uint256 public constant MAX_SUPPLY = 10000;         // total NFTs
    uint256 public maxPerWallet = 5;                   // default per-wallet limit
    uint256 public mintPrice = 0.05 ether;             // default price per mint
    bool    public saleIsActive = false;

    // URI handling
    string private baseTokenURI;
    string private hiddenMetadataURI;
    bool   public revealed = false;

    // Track number minted per wallet
    mapping(address => uint256) public walletMints;

     // Events
    event Minted(address indexed minter, uint256 quantity);
    event BaseURISet(string baseURI);
    event HiddenURISet(string hiddenURI);

     event Revealed(bool revealed);
    event SaleToggled(bool active);
    event Withdrawn(address indexed to, uint256 amount);

    constructor(
        string memory name_,
        string memory symbol_,
        string memory hiddenURI_
    ) ERC721(name_, symbol_) {
        hiddenMetadataURI = hiddenURI_;
    }
