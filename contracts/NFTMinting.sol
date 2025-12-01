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

      // ----------- MINTING -----------

    /**
     * @notice Public payable mint.
     * @param quantity Number of tokens to mint
     */

     function mint(uint256 quantity) external payable nonReentrant {
        require(saleIsActive, "Sale is not active");
        require(quantity > 0, "Quantity must be > 0");
        uint256 supply = totalSupply();
        require(supply + quantity <= MAX_SUPPLY, "Exceeds max supply");
        require(walletMints[msg.sender] + quantity <= maxPerWallet, "Exceeds wallet limit");
        require(msg.value >= mintPrice * quantity, "Insufficient ETH sent");

        // Mint loop (gas: consider batch-mint patterns if you expect big quantity per tx)
        for (uint256 i = 0; i < quantity; i++) {
            uint256 tokenId = supply + i + 1; // token IDs start at 1
            _safeMint(msg.sender, tokenId);
        }

        walletMints[msg.sender] += quantity;
        emit Minted(msg.sender, quantity);

        // refund excess ETH (if user sent too much)
        uint256 excess = msg.value - (mintPrice * quantity);
        if (excess > 0) {
            // it's safe to use call here because we're sending to msg.sender.
            (bool sent, ) = payable(msg.sender).call{value: excess}("");
            require(sent, "Refund failed");
        }
    }

      // Owner reserve mint (for team, giveaways, airdrops)
    function reserveMint(address to, uint256 quantity) external onlyOwner {
        require(quantity > 0, "Quantity must be > 0");
        uint256 supply = totalSupply();
        require(supply + quantity <= MAX_SUPPLY, "Exceeds max supply");
        for (uint256 i = 0; i < quantity; i++) {
            uint256 tokenId = supply + i + 1;
            _safeMint(to, tokenId);
        }
    }

    // ----------- READ METADATA -----------

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "URI query for nonexistent token");

        if (!revealed) {
            return hiddenMetadataURI;
        }

         string memory base = baseTokenURI;
        return bytes(base).length > 0 ? string(abi.encodePacked(base, tokenId.toString(), ".json")) : "";
    }

     // ----------- OWNER CONTROLS -----------

    function setBaseURI(string calldata uri) external onlyOwner {
        baseTokenURI = uri;
        emit BaseURISet(uri);
    }

    function setHiddenMetadataURI(string calldata uri) external onlyOwner {
        hiddenMetadataURI = uri;
        emit HiddenURISet(uri);
    }
    function reveal() external onlyOwner {
        revealed = true;
        emit Revealed(true);
    }

    function setMintPrice(uint256 newPrice) external onlyOwner {
        mintPrice = newPrice;
    }

    function setMaxPerWallet(uint256 newMax) external onlyOwner {
        maxPerWallet = newMax;
    }

    function toggleSale() external onlyOwner {
        saleIsActive = !saleIsActive;
        emit SaleToggled(saleIsActive);
    }
