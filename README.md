# FTTY - Gaming Assets Crypto Marketplace

A next-generation platform for buying, selling, and trading in-game assets using cryptocurrency. FTTY provides a secure, fast, and commission-free marketplace for gaming assets powered by blockchain technology.

## 🎮 Overview

FTTY is a decentralized marketplace that enables gamers to trade in-game assets across multiple games using the FTTY token. The platform emphasizes security, speed, and zero commission fees, making it an attractive solution for the gaming economy.

## ✨ Features

- **Secure Transactions**: All transactions are secured by blockchain technology, ensuring safety and transparency
- **Lightning Fast**: Near-instant transactions with optimized blockchain integration
- **Zero Commissions**: Trade without any hidden fees - 0% commission on all transactions
- **Self-Custody**: Keep full control of your assets with self-custody solution
- **Cross-Game Trading**: Trade assets between supported games
- **Multi-Chain Support**: Works across multiple blockchains including Ethereum, Polygon, Arbitrum, Optimism, Base, and Sepolia
- **Wallet Integration**: Seamless wallet connection via Reown AppKit (WalletConnect)
- **Featured Assets**: Browse and discover popular gaming assets
- **Responsive Design**: Modern, mobile-friendly UI with smooth animations

## 🛠️ Tech Stack

- **Framework**: [Next.js 14](https://nextjs.org/) (React 18)
- **Styling**: [Tailwind CSS](https://tailwindcss.com/)
- **Blockchain**: 
  - [Wagmi](https://wagmi.sh/) - React Hooks for Ethereum
  - [Viem](https://viem.sh/) - TypeScript Ethereum library
  - [Reown AppKit](https://reown.com/appkit) (formerly WalletConnect) - Wallet connection
- **Smart Contracts**: 
  - [OpenZeppelin Contracts](https://openzeppelin.com/contracts/) - Secure smart contract libraries
  - Solidity ^0.8.19/^0.8.20 (Ethereum/EVM chains)
  - Clarity 4 (Stacks blockchain)
- **Data Fetching**: [TanStack Query](https://tanstack.com/query) (React Query)
- **Icons**: [React Icons](https://react-icons.github.io/react-icons/)

## 📋 Prerequisites

- Node.js 18+ 
- npm, yarn, pnpm, or bun

## 🚀 Getting Started

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd ftty-app
   ```

2. **Install dependencies**
   ```bash
   npm install
   # or
   yarn install
   # or
   pnpm install
   ```

3. **Set up environment variables** (if needed)
   
   The project uses a Reown (WalletConnect) project ID. The current project ID is configured in `config/wagmi.js`. If you need to use your own:
   - Get a project ID from [Reown Cloud](https://cloud.reown.com)
   - Update `config/wagmi.js` with your project ID

4. **Run the development server**
   ```bash
   npm run dev
   # or
   yarn dev
   # or
   pnpm dev
   ```

5. **Open your browser**
   
   Navigate to [http://localhost:3000](http://localhost:3000) to see the application.

## 📁 Project Structure

```
ftty-app/
├── app/                    # Next.js app directory
│   ├── layout.js          # Root layout with providers
│   ├── page.js            # Home page
│   ├── globals.css        # Global styles
│   └── fonts/             # Custom fonts
├── components/             # React components
│   ├── Navbar.jsx         # Navigation bar with wallet connection
│   ├── Hero.jsx           # Hero section
│   ├── Features.jsx       # Features showcase
│   ├── FeaturedAssets.jsx # Featured gaming assets
│   ├── Chains.jsx         # Supported blockchain networks
│   ├── Community.jsx      # Community section
│   ├── Roadmap.jsx        # Roadmap section
│   ├── Footer.jsx         # Footer component
│   └── Providers.jsx      # React Query & Wagmi providers
├── config/                # Configuration files
│   └── wagmi.js           # Wagmi and blockchain configuration
├── contracts/             # Smart contracts
│   ├── NFTMinting.sol     # ERC721 NFT minting contract
│   ├── Payments.sol       # Payment processing contract with platform fees
│   ├── Listing.sol        # NFT marketplace listing contract
│   ├── Bidding.sol        # Offer/bidding system for NFTs
│   ├── GameItem.sol       # Game item NFT with updatable attributes
│   ├── PlatformFee.sol    # Platform fee management contract
│   ├── Royalty.sol        # ERC-2981 royalty management contract
│   └── Story.clar         # Collaborative story contract (Clarity/Stacks)
├── public/                # Static assets
│   ├── helmet.jpeg
│   ├── staff.jpeg
│   ├── sword.jpg
│   └── whitepaper.pdf
├── tailwind.config.js     # Tailwind CSS configuration
├── next.config.mjs        # Next.js configuration
└── package.json           # Dependencies and scripts
```

## 🎨 Customization

### Colors

The project uses a custom color scheme defined in `tailwind.config.js`:
- **Primary Orange**: `#FF7A00` (ftty-orange)
- **Dark Purple**: `#1A0D2C` (ftty-purple-dark)
- **Darker Purple**: `#110820` (ftty-purple-darker)

You can customize these colors in the Tailwind configuration file.

### Supported Chains

Currently configured chains can be modified in `config/wagmi.js`:
- Ethereum Mainnet
- Arbitrum
- Polygon
- Optimism
- Base
- Sepolia (Testnet)

## 📜 Available Scripts

- `npm run dev` - Start development server
- `npm run build` - Build for production
- `npm run start` - Start production server
- `npm run lint` - Run ESLint

## 🔗 Blockchain Networks

The application supports multiple blockchain networks:
- **Ethereum**: Mainnet and Sepolia testnet
- **Arbitrum**: Layer 2 scaling solution
- **Polygon**: Multi-chain ecosystem
- **Optimism**: Optimistic rollup
- **Base**: Coinbase's Layer 2

Users can connect their wallets and switch between supported networks seamlessly.

## 🔐 Wallet Connection

The app uses Reown AppKit (formerly WalletConnect) for wallet connections, supporting:
- MetaMask
- WalletConnect
- Coinbase Wallet
- And many other popular wallets

## 📄 Whitepaper

A whitepaper is available at `/public/whitepaper.pdf` and can be accessed via the "Whitepaper" button in the hero section.

## Smart Contracts

The project includes a comprehensive suite of Solidity smart contracts for marketplace functionality, NFT management, and payment processing:

### NFTMinting.sol (`SimpleMintNFT`)

An ERC721 NFT minting contract built with OpenZeppelin libraries:

- **Features**:
  - `ERC721Enumerable` for easy token enumeration
  - `Ownable` for admin controls
  - `ReentrancyGuard` for secure withdrawals and minting
  - Configurable supply limits (max 10,000 tokens)
  - Per-wallet minting limits to prevent whales
  - Revealable metadata with hidden URI support
  - Public sale activation controls
  - Owner-only `reserveMint` for team mints, giveaways, and airdrops
  - Automatic refund of excess ETH sent during mint
  - `receive`/`fallback` handlers to accept direct ETH (withdrawable by owner)

- **Key Parameters**:
  - `MAX_SUPPLY`: 10,000 total NFTs
  - `maxPerWallet`: 5 NFTs per wallet (configurable)
  - `mintPrice`: 0.05 ETH per mint (configurable)
  - `saleIsActive`: Public sale toggle

- **Key Functions**:
  - `mint(uint256 quantity)`: Public mint with per-wallet limits and payment checks
  - `reserveMint(address to, uint256 quantity)`: Owner reserve mint
  - `setBaseURI(string uri)`: Set revealed metadata base URI
  - `setHiddenMetadataURI(string uri)`: Set placeholder/hidden metadata URI
  - `reveal()`: One-way reveal switch for collection metadata
  - `setMintPrice(uint256 newPrice)`: Update mint price
  - `setMaxPerWallet(uint256 newMax)`: Update per-wallet limits
  - `toggleSale()`: Enable/disable public sale
  - `withdraw(address payable to)`: Withdraw contract ETH balance to owner-controlled address

### Payments.sol

A secure payment processing contract for marketplace transactions:

- **Features**:
  - Pull-pattern ETH withdrawals for recipients (`pendingWithdrawals`)
  - Configurable platform fees in basis points (supports 0–100%)
  - Dedicated `feeCollector` address for routing platform fees
  - Pausable for emergency stops
  - `ReentrancyGuard` protection on state-changing calls
  - `Ownable` admin controls
  - Support for direct ETH transfers via `receive`
  - Event logging for all key actions (payments, withdrawals, config changes)
  - Optional ERC20 pull-payment scaffolding (disabled by default via `revert`)

- **Key Functions**:
  - `payTo(address recipient, string memo)`: Schedule an ETH payment to a recipient (with platform fee)
  - `ownerCredit(address recipient, uint256 amount, string memo)`: Owner-funded payout from contract balance
  - `withdraw()`: Recipients withdraw their accumulated ETH balance
  - `setPlatformFeeBps(uint256 bps)`: Configure platform fee percentage
  - `setFeeCollector(address collector)`: Set/update the fee collector address
  - `pause()` / `unpause()`: Global pause controls
  - `emergencyWithdraw(address payable to, uint256 amount)`: Owner-only emergency fund recovery
  - `ownerCreditERC20(...)` / `withdrawERC20(...)`: ERC20 extension points for future token payments (currently stubbed)

### Listing.sol (`NFTMarketplace`)

A non-custodial NFT marketplace listing contract:

- **Features**:
  - Create listings without transferring NFT custody
  - Cancel active listings
  - Buy NFTs with native token (ETH or chain currency)
  - Configurable platform fees (basis points, e.g., 250 = 2.5%)
  - Safe NFT transfers using OpenZeppelin's `IERC721`
  - `ReentrancyGuard` protection
  - `AccessControl` for admin role management (`MARKET_ADMIN`)

- **Key Functions**:
  - `createListing(address nft, uint256 tokenId, uint256 price)`: Create a new listing (requires marketplace approval)
  - `cancelListing(uint256 listingId)`: Cancel an active listing (seller only)
  - `buyItem(uint256 listingId)`: Purchase NFT at listed price (with platform fee deduction)
  - `setPlatformFee(uint256 newFeePercent)`: Update platform fee percentage (admin only)
  - `setFeeReceiver(address newReceiver)`: Update fee receiver address (admin only)

- **Events**:
  - `ItemListed`: Emitted when a new listing is created
  - `ListingCancelled`: Emitted when a listing is cancelled
  - `ItemSold`: Emitted when an NFT is purchased

### Bidding.sol (`OfferContract`)

An offer/bidding system for ERC-721 NFTs:

- **Features**:
  - Buyers lock funds as offers (non-custodial NFT handling)
  - Sellers can accept offers
  - Offer cancellation with automatic refund
  - Platform fee on accepted offers
  - Increase offer amounts
  - `ReentrancyGuard` protection
  - `AccessControl` for admin role management (`MARKET_ADMIN`)

- **Key Functions**:
  - `createOffer(address nft, uint256 tokenId)`: Create a new offer (locks ETH)
  - `increaseOffer(uint256 offerId)`: Add more ETH to an existing offer
  - `cancelOffer(uint256 offerId)`: Cancel offer and receive refund (offerer only)
  - `acceptOffer(uint256 offerId)`: Accept offer, transfer NFT, and distribute funds (seller only)
  - `setPlatformFee(uint256 newFeePercent)`: Update platform fee percentage (admin only)
  - `setFeeReceiver(address newReceiver)`: Update fee receiver address (admin only)

- **Events**:
  - `OfferCreated`: Emitted when a new offer is created
  - `OfferUpdated`: Emitted when an offer amount is increased
  - `OfferCancelled`: Emitted when an offer is cancelled
  - `OfferAccepted`: Emitted when an offer is accepted

### GameItem.sol (`GameItemNFT`)

An ERC-721 game item contract with updatable in-game attributes:

- **Features**:
  - Role-based minting (`GAME_ADMIN`)
  - Updatable game attributes (level, power, rarity)
  - Dynamic metadata (baseURI + token-specific attributes)
  - `Pausable` for emergency control
  - `AccessControl` for role management
  - `ERC721URIStorage` for per-token metadata URIs

- **Key Functions**:
  - `mintGameItem(address to, uint256 level, uint256 power, uint256 rarity)`: Mint a new game item with initial stats (admin only)
  - `updateStats(uint256 tokenId, uint256 level, uint256 power, uint256 rarity)`: Update game item attributes (admin only)
  - `setBaseURI(string newBaseURI)`: Update base metadata URI (admin only)
  - `pause()` / `unpause()`: Pause/unpause contract operations (admin only)

- **Events**:
  - `ItemMinted`: Emitted when a new game item is minted
  - `StatsUpdated`: Emitted when game item stats are updated
  - `BaseURIUpdated`: Emitted when base URI is updated

### PlatformFee.sol (`PlatformFee`)

A reusable platform fee management contract:

- **Features**:
  - Configurable platform fee in basis points (0-100%)
  - Fee recipient address management
  - Fee calculation helper function
  - Can be inherited by marketplace contracts
  - Input validation for fee percentages

- **Key Functions**:
  - `getPlatformFeeAmount(uint256 salePrice)`: Calculate platform fee amount for a given sale price
  - `_setPlatformFee(uint96 newFeeBps)`: Internal function to update platform fee (for child contracts)
  - `_setPlatformFeeRecipient(address newRecipient)`: Internal function to update fee recipient (for child contracts)

- **Events**:
  - `PlatformFeeUpdated`: Emitted when platform fee is updated
  - `PlatformFeeRecipientUpdated`: Emitted when fee recipient is updated

### Royalty.sol (`RoyaltyManager`)

An ERC-2981 royalty management contract:

- **Features**:
  - Standard ERC-2981 royalty implementation
  - Default royalty settings for all tokens
  - Token-specific royalty overrides
  - `AccessControl` for admin role management (`ROYALTY_ADMIN`)
  - Basis points-based fee calculation (e.g., 500 = 5.00%)

- **Key Functions**:
  - `setDefaultRoyalty(address receiver, uint96 feeNumerator)`: Set default royalty for all tokens (admin only)
  - `deleteDefaultRoyalty()`: Remove default royalty (admin only)
  - `setTokenRoyalty(uint256 tokenId, address receiver, uint96 feeNumerator)`: Set royalty for specific token (admin only)
  - `resetTokenRoyalty(uint256 tokenId)`: Reset token royalty to default (admin only)

- **Events**:
  - `DefaultRoyaltySet`: Emitted when default royalty is set
  - `DefaultRoyaltyDeleted`: Emitted when default royalty is removed
  - `TokenRoyaltySet`: Emitted when token-specific royalty is set
  - `TokenRoyaltyReset`: Emitted when token royalty is reset

All Solidity contracts use OpenZeppelin's battle-tested security libraries and follow best practices for secure smart contract development.

### Story.clar (`OneWordStory`)

A collaborative story contract built with Clarity 4 for the Stacks blockchain:

- **Features**:
  - Users can add one word at a time to build a collaborative story
  - Each entry stores the word, sender (as ASCII text), and block timestamp
  - Uses Clarity 4 features including `block-header-timestamp` and `to-utf8` for principal conversion
  - Immutable story history stored on-chain
  - Maximum of 200 entries per story

- **Data Structure**:
  - `story`: List of up to 200 entries, each containing:
    - `word`: The word added (string-ascii, max 32 chars)
    - `sender`: The principal address converted to ASCII text (string-ascii, max 256 chars)
    - `timestamp`: Block timestamp when the word was added (uint)

- **Key Functions**:
  - `add-word (word (string-ascii 32))`: Add a single word to the story (public function)
    - Returns: `{ added: word, by: sender-text, at: time }`
  - `get-story`: Read-only function to retrieve the entire story
    - Returns: Complete list of all story entries
  - `story-length`: Read-only function to get the number of entries
    - Returns: Length of the story list

- **Helper Functions**:
  - `principal-to-string (p principal)`: Converts a principal address to UTF-8 string (read-only)

- **Technical Details**:
  - Built with Clarity 4 syntax
  - Uses `var-set` and `var-get` for state management
  - Leverages Clarity 4's built-in `to-utf8` for principal-to-string conversion
  - Uses `block-header-timestamp` for on-chain timestamps
  - Story entries are appended to the list using `append` function

This contract demonstrates collaborative on-chain storytelling where multiple users contribute to build a shared narrative, with each contribution permanently recorded on the Stacks blockchain.

## 🚧 Development Status

This project is currently in development. Features and functionality may change.

## 📝 License

This project is private and proprietary.

## 🤝 Contributing

This is a private project. For questions or support, please contact the project maintainers.

## 📞 Support

For issues, questions, or support, please refer to the project documentation or contact the development team.

---

Built with ❤️ using Next.js and Web3 technologies
