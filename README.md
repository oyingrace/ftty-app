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
  - Solidity ^0.8.19/^0.8.20
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
│   └── Payments.sol       # Payment processing contract with platform fees
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

The project includes two Solidity smart contracts for core marketplace functionality:

### NFTMinting.sol (SimpleMintNFT)

An ERC721 NFT minting contract built with OpenZeppelin libraries:

- **Features**:
  - ERC721Enumerable for easy token enumeration
  - Ownable for admin controls
  - ReentrancyGuard for secure withdrawals
  - Configurable supply limits (max 10,000 tokens)
  - Per-wallet minting limits
  - Revealable metadata with hidden URI support
  - Sale activation controls

- **Key Parameters**:
  - `MAX_SUPPLY`: 10,000 total NFTs
  - `maxPerWallet`: 5 NFTs per wallet (configurable)
  - `mintPrice`: 0.05 ETH per mint (configurable)
  - `saleIsActive`: Public sale toggle

### Payments.sol

A secure payment processing contract for marketplace transactions:

- **Features**:
  - Pull-pattern withdrawals for recipients
  - Configurable platform fees (basis points)
  - Pausable for emergency stops
  - ReentrancyGuard protection
  - Ownable admin controls
  - Support for ETH payments
  - Event logging for all transactions

- **Key Functions**:
  - `payTo()`: Send payment to a recipient (with platform fee)
  - `withdraw()`: Recipients withdraw their accumulated balance
  - `ownerCredit()`: Owner can credit funds to recipients
  - `setPlatformFeeBps()`: Configure platform fee percentage
  - `pause()`/`unpause()`: Emergency controls

Both contracts use OpenZeppelin's battle-tested security libraries and follow best practices for secure smart contract development.

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
