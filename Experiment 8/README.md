# 🏦 Experiment 8: Decentralized Banking DApp

<div align="center">

![Solidity](https://img.shields.io/badge/Solidity-0.8+-purple?style=for-the-badge&logo=solidity)
![MetaMask](https://img.shields.io/badge/MetaMask-E2761B?style=for-the-badge&logo=metamask&logoColor=white)
![Ethers.js](https://img.shields.io/badge/Ethers.js-5.7-blue?style=for-the-badge)
![Remix IDE](https://img.shields.io/badge/Remix-IDE-brightgreen?style=for-the-badge)

### *Configure a MetaMask wallet and integrate it with a DApp for optimal, secure banking transactions on the Ethereum blockchain.*

</div>

---

## 🎯 Aim

To configure a cryptocurrency wallet using **MetaMask** and integrate it with a Decentralized Application (DApp) designed for optimal and secure Banking Transactions on the blockchain.

---

## 📖 Theory

### 1. MetaMask as a Web3 Provider

MetaMask acts as a bridge between web browsers and Ethereum-based blockchain networks. It injects a global Ethereum API object (`window.ethereum`) into the browser context, allowing decentralized web applications to:

- Request user wallet authorization
- Retrieve public addresses
- Prompt users to sign banking transactions using their private keys

### 2. Banking DApp Architecture & Front-End Integration

Client-side applications utilize **Ethers.js** or **Web3.js** to handle banking workflows (depositing, withdrawing, and transferring Ether):

| Component | Role |
|-----------|------|
| **Provider** | Reads blockchain state — queries balances or contract funds without gas fees |
| **Signer** | Represents an authorized account capable of signing value-bearing transactions |
| **Contract Instance** | JavaScript representation of the smart contract via its deployed address and ABI |

### 3. Reentrancy Protection & Gas Optimization

| Technique | Description |
|-----------|-------------|
| **Checks-Effects-Interactions Pattern** | State variables updated in storage *before* external Ether transfers to prevent reentrancy attacks |
| **Gas-Efficient State Updates** | Reusable function logic avoids unnecessary computations and EVM failures |

---

## 📁 Files

| File | Description |
|------|-------------|
| `OptimalBankingDApp.sol` | Solidity smart contract — deposit, withdraw, transfer |
| `index.html` | Front-end DApp UI integrated with MetaMask via Ethers.js |
| `Blockchain_Lab_8 - Atharva Lotankar(D20C_20).pdf` | Full lab documentation with screenshots |

---

## 💻 Smart Contract Overview

**`OptimalBankingDApp.sol`** — A secure, gas-optimized decentralized banking contract.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract OptimalBankingDApp {
    mapping(address => uint256) private balances;

    function deposit() external payable { ... }
    function withdraw(uint256 _amount) external { ... }
    function transferFunds(address payable _to, uint256 _amount) external { ... }
    function getBalance(address _account) external view returns (uint256) { ... }
}
```

**Key Functions:**

- **`deposit()`** — Accepts ETH and credits the sender's internal balance
- **`withdraw(uint256)`** — Uses Checks-Effects-Interactions to safely transfer ETH back to the user
- **`transferFunds(address, uint256)`** — Internal peer-to-peer transfer between bank accounts (no ETH leaves the contract)
- **`getBalance(address)`** — View function (gas-free) returning any account's balance

**Deployed Contract Address:** `0xDA0bab807633f07f013f94DD0E6A4F96F8742B53`

---

## 🌐 Front-End DApp Overview

**`index.html`** — A clean banking portal UI loaded in the browser.

- Built with vanilla HTML/CSS/JS + **Ethers.js v5.7**
- Connect MetaMask wallet with a single click
- Live vault balance display (updates after every transaction)
- Three banking operations: Deposit, Withdraw, Transfer

---

## 🚀 Procedure

### Step 1: Smart Contract Compilation & Deployment in Remix

1. Open [Remix IDE](https://remix.ethereum.org) and create `OptimalBankingDApp.sol`
2. Compile using **Solidity compiler 0.8.0**
3. Select **Remix VM (Cancun)** as the environment and click **Deploy**
4. Copy the deployed contract address: `0xDA0bab807633f07f013f94DD0E6A4F96F8742B53`

### Step 2: Testing Contract Functions in Remix

| Operation | Parameters | Result |
|-----------|-----------|--------|
| `deposit()` | Value: `1000000000000000000` wei (1 ETH) | Block mined, balance credited |
| `getBalance(0x5B3...eddC4)` | — | Returns `1000000000000000000` wei |
| `transferFunds(...)` | To: `0xAb8...5cb2`, Amount: `500000000000000000` wei | 0.5 ETH transferred internally |

### Step 3: Web3 Integration with MetaMask & Front-End UI

1. Open `index.html` via **VS Code Live Server** at `http://127.0.0.1:5500/index.html`
2. Click **Connect MetaMask Wallet** — connects account `0xea511ccccaf859bf49e20c8cdecc257f923162dc`
3. Enter `0.01 ETH` in the deposit section → click **Deposit to Bank**
4. Approve the transaction prompt in MetaMask (connected to local Ganache network)
5. Vault balance updates automatically after confirmation

---

## 🔑 Key Concepts

- **Checks-Effects-Interactions (CEI) Pattern** — Guards against reentrancy
- **`window.ethereum` injection** — MetaMask's Web3 provider interface
- **Ethers.js Provider vs Signer** — Read-only vs write operations
- **ABI (Application Binary Interface)** — Contract method signatures for JS interaction
- **Gas optimization** — Minimal state writes, no redundant computations

---

## 🛠️ Technologies Used

| Technology | Purpose |
|------------|---------|
| Solidity 0.8+ | Smart contract language |
| Remix IDE | Contract compilation & deployment |
| MetaMask | Browser wallet & Web3 provider |
| Ethers.js v5.7 | JS library for blockchain interaction |
| Ganache | Local Ethereum test network |
| VS Code Live Server | Serve front-end locally |

---

## ✅ Conclusion

A decentralized Banking Application (DApp) was successfully implemented, deployed, and integrated with MetaMask wallet. By using Ethers.js and the injected Web3 provider (`window.ethereum`), seamless interaction was established between client-side JavaScript and smart contracts on the Ethereum network. Practical operations including wallet account linking, gas-free balance reads, and signing deposit transactions were all verified successfully.

---

<div align="center">

*Experiment 8 — Part of [Blockchain Experiments by Atharva Lotankar](../README.md)*

</div>
