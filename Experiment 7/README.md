# 🛡️ Experiment 7: Local Blockchain with Ganache & Smart Contract Deployment

<div align="center">

![Ganache](https://img.shields.io/badge/Ganache-Local%20Blockchain-orange?style=for-the-badge&logo=ethereum)
![Solidity](https://img.shields.io/badge/Solidity-0.8+-purple?style=for-the-badge&logo=solidity)
![Remix IDE](https://img.shields.io/badge/Remix-IDE-blue?style=for-the-badge&logo=remix)
![Escrow](https://img.shields.io/badge/Smart%20Contract-Escrow-green?style=for-the-badge)

</div>

---

## 📋 Overview

This experiment demonstrates how to **establish a local Ethereum blockchain** using Ganache and **deploy a Solidity smart contract** through Remix IDE connected via an External HTTP Provider. The deployed contract — `BugBountyEscrow.sol` — implements a complete escrow lifecycle for security bug bounty programs, simulating a real-world DeFi workflow on a local test network.

---

## 🎯 Learning Objectives

- ✅ Set up and configure **Ganache** as a local personal blockchain
- ✅ Connect **Remix IDE** to Ganache using External HTTP Provider
- ✅ Write and compile a **Solidity escrow smart contract**
- ✅ Deploy and interact with the contract through its full lifecycle
- ✅ Verify transactions and state changes in both **Remix Terminal** and **Ganache GUI**
- ✅ Understand **escrow mechanics**, access control, and ETH transfer patterns

---

## 📚 Theory

### 🔗 Ganache

Ganache is a personal, local Ethereum blockchain provided by the **Truffle Suite**, designed for development and testing. Key features:

- **Instant mining** — blocks are mined immediately on each transaction
- **Pre-funded accounts** — 10 test accounts each loaded with 100 ETH
- **GUI dashboard** — real-time view of blocks, transactions, contracts, and logs
- **Deterministic** — same seed always produces the same accounts
- **Safe environment** — isolated from mainnet, no real funds at risk

### 🖥️ Remix IDE

Remix is a browser-based Solidity development environment that provides:

- A full **code editor** with syntax highlighting and linting
- **Solidity compiler** with version selection
- **Deploy & Run Transactions** tab for deployment and function calls
- **Debugger** and **static analysis** tools
- Plugin ecosystem for testing and verification

### 🔌 External HTTP Provider

When Remix's environment is set to **Custom - External HTTP Provider**, it sends JSON-RPC requests directly to any local RPC endpoint — in this case Ganache at `http://127.0.0.1:7545`. This bypasses browser wallet extensions and gives Remix direct access to all local Ganache accounts.

### 🔐 Escrow Pattern in Smart Contracts

An **escrow** holds funds in a neutral intermediate state until conditions are fulfilled. In `BugBountyEscrow.sol`:

- The **company** locks ETH into the contract when creating a bounty
- A **hunter** submits a bug report (stored as an IPFS hash or string)
- The **company** reviews and approves the submission
- On approval, the locked ETH is automatically transferred to the hunter

This pattern eliminates the need for trust between parties — the contract enforces the rules.

---

## ⚙️ Environment Setup

### Step 1 — Start Ganache

1. Launch **Ganache GUI** (Truffle Suite)
2. Create a new workspace or use Quickstart
3. Note the RPC Server: `http://127.0.0.1:7545`
4. Chain ID: `1337` / Network ID: `5777`
5. Confirm 10 accounts are pre-funded with **100 ETH each**

### Step 2 — Connect Remix to Ganache

1. Open [Remix IDE](https://remix.ethereum.org)
2. Navigate to **Deploy & Run Transactions** tab (rocket icon)
3. Under **Environment**, select **Custom - External HTTP Provider**
4. Enter RPC endpoint: `http://127.0.0.1:7545`
5. Confirm accounts populate from Ganache in the **Account** dropdown

---

## 💻 Smart Contract: BugBountyEscrow.sol

### Contract Architecture

```
BugBountyEscrow
│
├── Enums
│   └── Status: Created → Submitted → Approved → Paid / Refunded
│
├── Struct: Bounty
│   ├── bountyId    (uint256)
│   ├── company     (address payable)
│   ├── hunter      (address payable)
│   ├── amount      (uint256 — wei locked in escrow)
│   ├── bugReportHash (string — IPFS hash or report ID)
│   └── status      (Status enum)
│
├── State Variables
│   ├── bountyCount  (uint256 — auto-increment ID)
│   └── bounties     (mapping: uint256 → Bounty)
│
├── Events
│   ├── BountyCreated(bountyId, company, amount)
│   ├── BugSubmitted(bountyId, hunter, bugReportHash)
│   ├── BountyApproved(bountyId)
│   └── RewardPaid(bountyId, hunter, amount)
│
└── Functions
    ├── createBounty()      payable — company locks ETH
    ├── submitBug()         — hunter submits report
    ├── approveBug()        — company approves (access controlled)
    ├── releasePayment()    — company triggers payout (access controlled)
    └── getBounty()         view — inspect bounty state
```

### Full Source Code

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BugBountyEscrow {
    enum Status { Created, Submitted, Approved, Paid, Refunded }

    struct Bounty {
        uint256 bountyId;
        address payable company;
        address payable hunter;
        uint256 amount;
        string bugReportHash;
        Status status;
    }

    uint256 public bountyCount;
    mapping(uint256 => Bounty) public bounties;

    event BountyCreated(uint256 indexed bountyId, address indexed company, uint256 amount);
    event BugSubmitted(uint256 indexed bountyId, address indexed hunter, string bugReportHash);
    event BountyApproved(uint256 indexed bountyId);
    event RewardPaid(uint256 indexed bountyId, address indexed hunter, uint256 amount);

    function createBounty() external payable {
        require(msg.value > 0, "Bounty reward must be greater than zero");

        bountyCount++;
        bounties[bountyCount] = Bounty({
            bountyId: bountyCount,
            company: payable(msg.sender),
            hunter: payable(address(0)),
            amount: msg.value,
            bugReportHash: "",
            status: Status.Created
        });

        emit BountyCreated(bountyCount, msg.sender, msg.value);
    }

    function submitBug(uint256 _bountyId, string memory _bugReportHash) external {
        Bounty storage bounty = bounties[_bountyId];
        require(bounty.bountyId != 0, "Bounty does not exist");
        require(bounty.status == Status.Created, "Bounty is not open for submission");

        bounty.hunter = payable(msg.sender);
        bounty.bugReportHash = _bugReportHash;
        bounty.status = Status.Submitted;

        emit BugSubmitted(_bountyId, msg.sender, _bugReportHash);
    }

    function approveBug(uint256 _bountyId) external {
        Bounty storage bounty = bounties[_bountyId];
        require(msg.sender == bounty.company, "Only company can approve");
        require(bounty.status == Status.Submitted, "No submission to approve");

        bounty.status = Status.Approved;
        emit BountyApproved(_bountyId);
    }

    function releasePayment(uint256 _bountyId) external {
        Bounty storage bounty = bounties[_bountyId];
        require(msg.sender == bounty.company, "Only company can release payment");
        require(bounty.status == Status.Approved, "Bounty report not approved yet");

        bounty.status = Status.Paid;
        uint256 paymentAmount = bounty.amount;
        bounty.amount = 0;

        bounty.hunter.transfer(paymentAmount);
        emit RewardPaid(_bountyId, bounty.hunter, paymentAmount);
    }

    function getBounty(uint256 _bountyId) external view returns (
        uint256 bountyId,
        address company,
        address hunter,
        uint256 amount,
        string memory bugReportHash,
        Status status
    ) {
        Bounty memory b = bounties[_bountyId];
        require(b.bountyId != 0, "Bounty does not exist");
        return (b.bountyId, b.company, b.hunter, b.amount, b.bugReportHash, b.status);
    }
}
```

---

## 🔄 Contract Lifecycle & Workflow

```
Company Account                     Hunter Account
     │                                    │
     │ createBounty() + 1 ETH             │
     │ ─────────────────────────►         │
     │          [Status: Created]          │
     │                                    │
     │                    submitBug("IPFS_REPORT_123", 1)
     │                    ◄───────────────│
     │          [Status: Submitted]        │
     │                                    │
     │ approveBug(1)                       │
     │ ─────────────────────────►         │
     │          [Status: Approved]         │
     │                                    │
     │ releasePayment(1)                   │
     │ ─────────────────────────►         │
     │          [Status: Paid]             │
     │                         1 ETH ────►│
     │                                    │
```

### Execution Steps

| Block | Action | Caller | Details |
|-------|--------|--------|---------|
| 1–4 | Contract Deployment | — | `BugBountyEscrow` deployed to Ganache |
| 5 | `createBounty()` | Company | Locks `1 ETH` (1000000000000000000 wei) into escrow |
| 6 | `submitBug(1, "IPFS_REPORT_123")` | Hunter | Bug report submitted, status → `Submitted` |
| 7 | `approveBug(1)` | Company | Report approved, status → `Approved` |
| 8 | `releasePayment(1)` | Company | 1 ETH transferred to hunter, status → `Paid` |

---

## 🧪 Compiling & Deploying in Remix

### Compilation

1. Open `BugBountyEscrow.sol` in Remix
2. Go to the **Solidity Compiler** tab
3. Select compiler version **0.8.x** (matching `pragma solidity ^0.8.0`)
4. Click **Compile BugBountyEscrow.sol**
5. Confirm green checkmark — no errors or warnings

### Deployment

1. Go to **Deploy & Run Transactions** tab
2. Environment: **Custom - External HTTP Provider** → `http://127.0.0.1:7545`
3. Select the **Company account** from the Account dropdown
4. Contract: `BugBountyEscrow`
5. Click **Deploy**
6. Confirm transaction appears in Ganache's **Transactions** tab

### Interacting with the Contract

**createBounty** — set VALUE to `1 ETH` (or `1000000000000000000 wei`), click `createBounty`

**submitBug** — switch to Hunter account; call `submitBug` with:
- `_bountyId`: `1`
- `_bugReportHash`: `"IPFS_REPORT_123"`

**approveBug** — switch back to Company account; call `approveBug` with:
- `_bountyId`: `1`

**releasePayment** — Company account; call `releasePayment` with:
- `_bountyId`: `1`
- Observe hunter's balance increase by 1 ETH in Ganache

---

## 📊 Output & Observations

### Block Sequence on Ganache

```
Block 1  → Contract deployment transaction
Block 2  → Contract initialization
Block 3  → Setup transaction
Block 4  → Setup transaction
Block 5  → createBounty  : 1 ETH (1000000000000000000 wei) locked into escrow
Block 6  → submitBug     : "IPFS_REPORT_123" linked to Bounty #1
Block 7  → approveBug    : Approval granted by company account
Block 8  → releasePayment: 1 ETH released to hunter's address
```

### State Transitions Observed

| Step | `status` | `amount` | `hunter` |
|------|----------|----------|---------|
| After `createBounty` | `Created (0)` | 1 ETH | `0x000...000` |
| After `submitBug` | `Submitted (1)` | 1 ETH | Hunter address |
| After `approveBug` | `Approved (2)` | 1 ETH | Hunter address |
| After `releasePayment` | `Paid (3)` | 0 | Hunter address |

### Ganache Verification

- All 8 transactions visible in **TRANSACTIONS** tab
- Company balance decremented by ~1 ETH + gas fees
- Hunter balance incremented by exactly 1 ETH on block 8
- Contract balance returns to 0 after `releasePayment`

---

## 🔍 Key Concepts Demonstrated

### Access Control
`approveBug` and `releasePayment` are restricted via `require(msg.sender == bounty.company)`, ensuring only the company that created the bounty can approve and release funds. This prevents unauthorized payout.

### Escrow Pattern
ETH is held inside the contract's balance after `createBounty`. It only leaves via `hunter.transfer(paymentAmount)` in `releasePayment` — the contract acts as a trustless third party.

### Reentrancy Mitigation
`releasePayment` sets `bounty.amount = 0` and `bounty.status = Paid` **before** calling `transfer`, following the Checks-Effects-Interactions (CEI) pattern to guard against reentrancy attacks.

### Event Logging
All four lifecycle transitions emit indexed events (`BountyCreated`, `BugSubmitted`, `BountyApproved`, `RewardPaid`), enabling off-chain listeners (like a frontend or indexer) to track bounty state without repeatedly calling `getBounty`.

---

## 💬 Viva / Discussion Questions

**Q1. What is Ganache and why is it used for development?**
Ganache is a personal, customizable local Ethereum blockchain from the Truffle Suite. It enables developers to deploy contracts, execute transactions, and inspect state in a safe, deterministic environment with instant block mining and pre-funded test accounts — without spending real ETH.

**Q2. How does Remix connect to Ganache?**
Via the **Deploy & Run Transactions** tab in Remix, by selecting **Custom - External HTTP Provider** and pointing it to Ganache's local RPC endpoint at `http://127.0.0.1:7545`. This gives Remix direct JSON-RPC access to all Ganache accounts.

**Q3. What is the escrow pattern in smart contracts?**
An escrow smart contract holds funds in a locked state until predefined conditions are met. Neither party (company or hunter) can unilaterally move the funds — the contract enforces the rules, making trust between parties unnecessary.

**Q4. What is the Checks-Effects-Interactions (CEI) pattern?**
It is a Solidity best practice where you: (1) **Check** preconditions with `require`, (2) **Update state** variables, then (3) **Interact** with external addresses via `transfer`/`call`. This ordering prevents reentrancy exploits.

**Q5. What does `address payable` mean in Solidity?**
A `payable` address can receive Ether. Regular `address` types cannot call `.transfer()` or `.send()` on them. In this contract, both `company` and `hunter` are `address payable` to enable ETH transfers.

**Q6. Why are events emitted in this contract?**
Events write to the Ethereum transaction log — a cheap, indexed storage layer. They let off-chain applications (UIs, backends) listen for lifecycle changes without polling contract state. Indexed parameters allow efficient log filtering.

---

## 🚀 Getting Started

### Prerequisites

- [Ganache](https://trufflesuite.com/ganache/) — GUI version installed and running
- [Remix IDE](https://remix.ethereum.org) — browser-based, no installation needed
- Basic familiarity with Solidity and Ethereum concepts

### Steps to Reproduce

```
1. Launch Ganache → Quickstart Ethereum
2. Open Remix IDE in browser
3. Create new file → paste BugBountyEscrow.sol
4. Compile with Solidity 0.8.x
5. Set environment to Custom - External HTTP Provider → http://127.0.0.1:7545
6. Deploy the contract from Account[0] (company)
7. Call createBounty() with VALUE = 1 ETH from Account[0]
8. Switch to Account[1] (hunter) → call submitBug(1, "IPFS_REPORT_123")
9. Switch back to Account[0] → call approveBug(1)
10. Call releasePayment(1) → verify hunter balance increase in Ganache
```

---

## 📁 Files

| File | Description |
|------|-------------|
| `BugBountyEscrow.sol` | Solidity smart contract — full escrow implementation |
| `Blockchain_Lab_7 - Atharva Lotankar(D20C_20).pdf` | Complete lab documentation with screenshots |
| `README.md` | This file |

---

## 👨‍💻 Author

**Atharva Lotankar**  
Roll No: D20C_20

---

<div align="center">

### 🌟 Experiment Status: ✅ Completed

*Local blockchain configured · Smart contract deployed · Full escrow lifecycle executed!*

</div>
