# 🦊 Experiment 4: MetaMask & Ethereum Wallet Integration

<div align="center">

![MetaMask](https://img.shields.io/badge/MetaMask-Wallet-orange?style=for-the-badge&logo=metamask)
![Ethereum](https://img.shields.io/badge/Ethereum-Blockchain-blue?style=for-the-badge&logo=ethereum)
![Web3](https://img.shields.io/badge/Web3-Integration-purple?style=for-the-badge&logo=web3.js)

</div>

---

## 📋 Overview

This experiment explores **MetaMask**, the leading cryptocurrency wallet and gateway to blockchain applications. Learn how to install, configure, and use MetaMask for interacting with the **Ethereum blockchain**, managing digital assets, and connecting to **decentralized applications (dApps)**.

---

## 🎯 Learning Objectives

- ✅ Install and configure **MetaMask wallet**
- ✅ Understand **wallet security** and seed phrase management
- ✅ Create and manage **Ethereum accounts**
- ✅ Connect to different **blockchain networks** (Mainnet, Testnets)
- ✅ Send and receive **cryptocurrency transactions**
- ✅ Interact with **decentralized applications (dApps)**
- ✅ Explore **token management** and custom tokens
- ✅ Understand **gas fees** and transaction costs

---

## 📚 Theory

### 🔐 What is MetaMask?

**MetaMask** is a browser extension and mobile app that serves as:

- **Cryptocurrency Wallet**: Store and manage ETH and ERC-20 tokens
- **Identity Manager**: Control digital identity and keys
- **dApp Gateway**: Connect to Web3 applications
- **Transaction Signer**: Approve blockchain transactions

**Key Features:**
- Non-custodial (you control private keys)
- Browser integration (Chrome, Firefox, Brave, Edge)
- Multi-network support
- Built-in token swaps
- Hardware wallet integration

### 🔑 Wallet Fundamentals

**Components:**
- **Public Address**: Your wallet's public identifier (0x...)
- **Private Key**: Secret key proving ownership (never share!)
- **Seed Phrase**: 12-word backup for wallet recovery
- **Password**: Local encryption for browser storage

**Security Hierarchy:**
```
Seed Phrase → Private Keys → Public Addresses
(Most sensitive)              (Can be shared)
```

### 🌐 Blockchain Networks

**Ethereum Mainnet:**
- Production blockchain
- Real ETH with monetary value
- Real transaction costs

**Test Networks (Testnets):**
- **Sepolia**: Recommended Ethereum testnet
- **Goerli**: Legacy testnet (deprecated)
- **Mumbai**: Polygon testnet
- Free test ETH for development

### ⛽ Gas Fees

**Gas** represents computational effort to process transactions:

- Measured in **Gwei** (1 ETH = 1,000,000,000 Gwei)
- Higher gas = faster transaction processing
- Varies based on network congestion
- Required for all blockchain operations

**Transaction Cost Formula:**
```
Cost = Gas Used × Gas Price
```

### 🪙 Token Standards

**ERC-20**: Fungible tokens (currencies, utility tokens)
**ERC-721**: Non-fungible tokens (NFTs, unique items)
**ERC-1155**: Multi-token standard (fungible + non-fungible)

---

## 🚀 Getting Started

### Installation Steps

#### **Browser Extension (Chrome/Firefox/Edge)**

1. **Visit Official Site:**
   - Go to [metamask.io](https://metamask.io)
   - Click "Download" → Choose your browser

2. **Add Extension:**
   - Click "Add to Chrome/Firefox/Edge"
   - Confirm installation

3. **Setup Wallet:**
   - Click "Create a new wallet"
   - Create strong password
   - **CRITICAL:** Write down 12-word seed phrase on paper
   - Confirm seed phrase by selecting words in order
   - Wallet is ready!

#### **Mobile App (iOS/Android)**

1. Download from official app stores
2. Open app and tap "Create new wallet"
3. Follow same security setup process

---

## 🔧 Configuration & Usage

### Adding Networks

**Add Sepolia Testnet:**
1. Click network dropdown (top of MetaMask)
2. Select "Show test networks" in settings
3. Select "Sepolia"

**Add Custom Network (Polygon, BSC, etc.):**
1. Settings → Networks → Add Network
2. Enter network details:
   - Network Name: Polygon Mainnet
   - RPC URL: https://polygon-rpc.com
   - Chain ID: 137
   - Currency Symbol: MATIC
   - Block Explorer: https://polygonscan.com

### Getting Test ETH

**Sepolia Faucets:**
- [Alchemy Sepolia Faucet](https://sepoliafaucet.com/)
- [Infura Faucet](https://www.infura.io/faucet/sepolia)
- [QuickNode Faucet](https://faucet.quicknode.com/)

**Process:**
1. Copy your MetaMask address
2. Visit faucet website
3. Paste address and request ETH
4. Wait 1-2 minutes for transaction

### Sending Transactions

**Send ETH:**
1. Click "Send" button
2. Enter recipient address
3. Enter amount
4. Review gas fees
5. Click "Confirm"
6. Wait for confirmation

**Send Tokens:**
1. Click on token in asset list
2. Click "Send"
3. Follow same process as ETH

### Adding Custom Tokens

**Manual Import:**
1. Assets tab → "Import tokens"
2. Enter token contract address
3. Token symbol and decimals auto-populate
4. Click "Add Custom Token"

**Popular Token Addresses (Mainnet):**
- USDT: `0xdac17f958d2ee523a2206206994597c13d831ec7`
- USDC: `0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48`
- DAI: `0x6b175474e89094c44da98b954eedeac495271d0f`

### Connecting to dApps

**Standard Connection Flow:**
1. Visit dApp website (e.g., Uniswap, OpenSea)
2. Click "Connect Wallet"
3. Select MetaMask
4. Approve connection in MetaMask popup
5. dApp can now read your address and request transactions

**Security Note:** Only connect to trusted dApps!

---

## 🛡️ Security Best Practices

### ⚠️ Critical Security Rules

| Rule | Why It Matters |
|------|----------------|
| **Never share seed phrase** | Anyone with it can steal all funds |
| **Never share private key** | Gives complete control of account |
| **Write seed phrase offline** | Digital copies can be hacked |
| **Use hardware wallet for large amounts** | Extra security layer |
| **Verify website URLs** | Avoid phishing sites |
| **Start with small amounts** | Test before large transactions |
| **Enable browser protection** | Extra phishing protection |

### 🔒 Security Features to Enable

- **Password protection**: Strong, unique password
- **Auto-lock**: Lock wallet after inactivity
- **Phishing detection**: Built-in warning system
- **Privacy mode**: Hide balances from dApps

### 🚨 Common Scams to Avoid

- **Fake support**: MetaMask never asks for seed phrase
- **Phishing websites**: Always verify URLs
- **Free airdrops**: Often require malicious approvals
- **Too good to be true**: No free money schemes

---

## 💡 Key Concepts

### Account Management

**Multiple Accounts:**
- Create unlimited accounts from one seed phrase
- Each has unique address
- Useful for organizing funds

**Account Structure:**
```
Seed Phrase (Master Key)
  ├── Account 1 (0xABC...)
  ├── Account 2 (0xDEF...)
  └── Account 3 (0x123...)
```

### Transaction States

1. **Pending**: Submitted to network, awaiting confirmation
2. **Confirmed**: Included in block (1 confirmation)
3. **Successful**: Fully confirmed (multiple blocks)
4. **Failed**: Reverted (but gas fee still charged!)

### Gas Price Strategies

- **Low**: Cheap but slow (hours)
- **Medium**: Balanced (minutes)
- **High**: Fast but expensive (seconds)
- **Custom**: Manual control

---

## 🎮 Practical Exercises

### Exercise 1: Setup & Configuration
- ✅ Install MetaMask
- ✅ Create wallet and secure seed phrase
- ✅ Create 2 additional accounts
- ✅ Add Sepolia testnet

### Exercise 2: Test Transactions
- ✅ Get test ETH from faucet
- ✅ Send test ETH between your accounts
- ✅ View transaction on Etherscan

### Exercise 3: Network Exploration
- ✅ Add Polygon network
- ✅ Switch between networks
- ✅ Compare gas fees

### Exercise 4: Token Management
- ✅ Add custom token
- ✅ View token balance
- ✅ Send tokens between accounts

### Exercise 5: dApp Interaction
- ✅ Connect to Uniswap testnet
- ✅ Approve token spending
- ✅ Disconnect wallet

---

## 📊 Comparison: MetaMask vs Other Wallets

| Feature | MetaMask | Trust Wallet | Coinbase Wallet |
|---------|----------|--------------|-----------------|
| **Type** | Browser + Mobile | Mobile Only | Browser + Mobile |
| **Networks** | Multi-chain | Multi-chain | Multi-chain |
| **dApp Browser** | ✅ | ✅ | ✅ |
| **Built-in Swap** | ✅ | ✅ | ✅ |
| **Open Source** | ✅ | ❌ | Partial |
| **Hardware Support** | ✅ | ❌ | ❌ |

---

## 🌍 Use Cases

### DeFi (Decentralized Finance)
- Trade on Uniswap, SushiSwap
- Lend/borrow on Aave, Compound
- Provide liquidity on DEXs

### NFTs (Non-Fungible Tokens)
- Buy/sell on OpenSea, Rarible
- Mint digital art
- Collect digital assets

### DAOs (Decentralized Autonomous Organizations)
- Vote on proposals
- Participate in governance
- Claim DAO rewards

### Gaming
- Play blockchain games
- Trade in-game assets
- Earn crypto rewards

---

## 📖 Further Reading

- [MetaMask Official Documentation](https://docs.metamask.io/)
- [Ethereum.org - Wallets](https://ethereum.org/en/wallets/)
- [How Ethereum Wallets Work](https://ethereum.org/en/developers/docs/accounts/)
- [ERC-20 Token Standard](https://ethereum.org/en/developers/docs/standards/tokens/erc-20/)
- [Understanding Gas Fees](https://ethereum.org/en/developers/docs/gas/)

---

## 📁 Files

- `Experiment 4 - MetaMask.pdf` - Complete lab manual and screenshots
- `README.md` - This file

---

## 🎓 Key Takeaways

| Concept | Real-World Application |
|---------|----------------------|
| **Wallet Security** | Protecting digital assets |
| **Network Switching** | Accessing different blockchains |
| **Gas Management** | Optimizing transaction costs |
| **dApp Integration** | Using Web3 applications |
| **Token Management** | Handling various cryptocurrencies |

---

## 👨‍💻 Author

**Atharva Lotankar**

---

<div align="center">

### 🌟 Experiment Status: ✅ Completed

*Web3 wallet mastery achieved - Ready for decentralized applications!*

[![MetaMask](https://img.shields.io/badge/Download-MetaMask-orange?style=for-the-badge&logo=metamask)](https://metamask.io)
[![Ethereum](https://img.shields.io/badge/Explore-Ethereum-blue?style=for-the-badge&logo=ethereum)](https://ethereum.org)

</div>
