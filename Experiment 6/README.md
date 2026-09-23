# 🗳️ Experiment 6: Smart Contract Creation & Deployment using Solidity and Remix IDE

<div align="center">

![Solidity](https://img.shields.io/badge/Solidity-Smart_Contracts-blue?style=for-the-badge&logo=solidity)
![Remix](https://img.shields.io/badge/Remix-IDE-darkblue?style=for-the-badge&logo=remix)
![Ethereum](https://img.shields.io/badge/Ethereum-Deployment-purple?style=for-the-badge&logo=ethereum)

</div>

---

## 📋 Overview

This experiment focuses on **creating and deploying a real-world smart contract** using Solidity and Remix IDE. The contract — `CampusBudgetAllocator` — simulates a **weighted voting system** where department representatives vote on campus club budget allocations. It demonstrates core Solidity patterns including `require` guards, `mapping`, `storage` vs `memory`, structs, delegation chains, and proportional budget distribution.

---

## 🎯 Aim

> **Creation and Deployment of Smart Contract and Transactions using Solidity and Remix IDE.**

**Course Outcomes:** CO3, CO5, CO6

---

## 📚 Theory

### 1. 🔒 Relevance of `require` Statements in Solidity

The `require` statement acts as a **guard condition** inside Solidity functions. If its condition is not met, execution halts immediately and all state changes within that transaction are **reverted** — nothing is written to the blockchain.

This rollback mechanism is critical for:
- **Security** — preventing unauthorized access
- **Correctness** — ensuring only valid inputs are processed
- **Reliability** — keeping contract state consistent

**In the `CampusBudgetAllocator` contract:**

```solidity
// Only the Dean can register representatives
require(msg.sender == dean, "Only the Dean can register reps.");

// Prevent double-registration
require(representatives[repAddress].studentWeight == 0, "Rep already registered.");

// Prevent voting with no weight
require(sender.studentWeight > 0, "Not authorized to vote.");

// Prevent double-voting
require(!sender.hasVoted, "Already voted.");

// Guard against invalid club index
require(clubIndex < clubs.length, "Invalid club choice.");
```

Each `require` also carries a **descriptive error message**, making the contract easier to debug and interact with for end users.

---

### 2. 🗝️ Keywords: `mapping`, `storage`, and `memory`

#### `mapping`
A `mapping` is a key-value data structure — similar to a hash table. Its syntax is:
```solidity
mapping(keyType => valueType)
```
In this contract:
```solidity
mapping(address => Representative) public representatives;
```
Each Ethereum address maps to a `Representative` struct holding their voting weight, delegate, and vote choice. Mappings are **gas-efficient for lookups** but cannot be iterated or have their length queried directly.

#### `storage`
`storage` refers to the **permanent state of the contract on the blockchain**. Variables declared at the contract level live in storage by default. Data persists across transactions but is expensive to write.

```solidity
Representative storage sender = representatives[msg.sender];
```
Using the `storage` keyword here means `sender` is a **reference** — changes to it directly update the blockchain state.

#### `memory`
`memory` is **temporary**, existing only for the duration of a function call. It is discarded once the function returns and is cheaper than storage.

```solidity
Club memory c = clubs[clubIndex];
return (c.name, c.totalVotes, c.allocatedBudget);
```
Here, `c` is a temporary copy used purely for reading and returning — no need to persist it, so `memory` is the right choice.

> **Rule of thumb:** Use `storage` when you need to modify persistent state. Use `memory` for temporary reads and computations.

---

### 3. ⚖️ Why `bytes32` Instead of `string`?

In earlier Solidity implementations (e.g., the classic Ballot contract), proposal names used `bytes32` rather than `string`.

| Feature | `bytes32` | `string` |
|---|---|---|
| Size | Fixed — exactly 32 bytes | Dynamic — variable length |
| Gas cost | Lower — simpler EVM handling | Higher — complex ABI encoding |
| Comparison | Fast and direct | Expensive (requires hashing) |
| Flexibility | Limited to 32 characters | Unlimited length |
| Readability | Needs conversion tools | Human-readable directly |

`bytes32` was preferred when **gas efficiency and performance** were the priority. Modern contracts (like `CampusBudgetAllocator`) use `string` for club names since readability and user-friendliness matter more here, and tools like Web3 Type Converter ease the transition.

---

## 💻 Smart Contract: `CampusBudgetAllocator`

### Contract Purpose

Simulates a **campus governance system** where:
- A **Dean** registers department representatives with voting weights proportional to their department size
- Representatives can **delegate** their vote to another representative
- Representatives **vote** for a campus club
- The Dean triggers **proportional budget distribution** based on vote totals

---

### 📐 Data Structures

```solidity
struct Representative {
    uint studentWeight;   // Voting weight = department size
    bool hasVoted;        // Prevents double voting
    address delegate;     // Who this rep delegated to
    uint votedClubIndex;  // Which club they voted for
}

struct Club {
    string name;            // Club name
    uint totalVotes;        // Accumulated weighted votes
    uint allocatedBudget;   // Proportional budget share
}
```

```solidity
mapping(address => Representative) public representatives;
Club[] public clubs;
```

---

### ⚙️ Functions

#### `constructor(string[] memory clubNames, uint _totalTreasuryPool)`
Deploys the contract. The deployer becomes the **Dean**. Initializes the club list and total budget pool.

```solidity
constructor(string[] memory clubNames, uint _totalTreasuryPool) {
    dean = msg.sender;
    totalTreasuryPool = _totalTreasuryPool;
    for (uint i = 0; i < clubNames.length; i++) {
        clubs.push(Club({ name: clubNames[i], totalVotes: 0, allocatedBudget: 0 }));
    }
}
```

---

#### `registerRepresentative(address repAddress, uint departmentSize)`
- **Dean only** — enforced with `require`
- Assigns a representative's voting weight equal to their department's student count
- Prevents re-registration and zero-weight entries

---

#### `delegateVote(address to)`
- Transfers your voting weight to another representative
- Walks the **delegation chain** to find the final delegate
- Detects and **reverts on circular delegation loops**
- If the target already voted, immediately adds weight to that club

```solidity
while (representatives[to].delegate != address(0)) {
    to = representatives[to].delegate;
    require(to != msg.sender, "Loop detected in delegation.");
}
```

---

#### `voteForClub(uint clubIndex)`
- Casts a weighted vote for a club by index
- Guarded against: no voting rights, already voted, invalid index
- Adds `studentWeight` to the chosen club's `totalVotes`

---

#### `calculateBudgetDistribution()`
- **Dean only**
- Distributes the treasury proportionally:

```
allocatedBudget = (Club Votes × Total Treasury) / Total Votes Cast
```

```solidity
clubs[i].allocatedBudget = (clubs[i].totalVotes * totalTreasuryPool) / totalVotesCast;
```

---

#### `getClubDetails(uint clubIndex)`
- View function — reads and returns club name, total votes, and allocated budget
- Uses `memory` for the local copy since no state modification is needed

---

### 📄 Full Contract

```solidity
// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract CampusBudgetAllocator {

    struct Representative {
        uint studentWeight;
        bool hasVoted;
        address delegate;
        uint votedClubIndex;
    }

    struct Club {
        string name;
        uint totalVotes;
        uint allocatedBudget;
    }

    address public dean;
    uint public totalTreasuryPool;
    uint public totalVotesCast;

    mapping(address => Representative) public representatives;
    Club[] public clubs;

    constructor(string[] memory clubNames, uint _totalTreasuryPool) {
        dean = msg.sender;
        totalTreasuryPool = _totalTreasuryPool;
        for (uint i = 0; i < clubNames.length; i++) {
            clubs.push(Club({ name: clubNames[i], totalVotes: 0, allocatedBudget: 0 }));
        }
    }

    function registerRepresentative(address repAddress, uint departmentSize) external {
        require(msg.sender == dean, "Only the Dean can register reps.");
        require(!representatives[repAddress].hasVoted, "Rep already voted.");
        require(representatives[repAddress].studentWeight == 0, "Rep already registered.");
        require(departmentSize > 0, "Department size must be greater than zero.");
        representatives[repAddress].studentWeight = departmentSize;
    }

    function delegateVote(address to) external {
        Representative storage sender = representatives[msg.sender];
        require(sender.studentWeight > 0, "You have no voting rights.");
        require(!sender.hasVoted, "You already voted.");
        require(to != msg.sender, "Self-delegation not allowed.");

        while (representatives[to].delegate != address(0)) {
            to = representatives[to].delegate;
            require(to != msg.sender, "Loop detected in delegation.");
        }

        Representative storage targetDelegate = representatives[to];
        require(targetDelegate.studentWeight >= 1, "Target cannot receive votes.");

        sender.hasVoted = true;
        sender.delegate = to;

        if (targetDelegate.hasVoted) {
            clubs[targetDelegate.votedClubIndex].totalVotes += sender.studentWeight;
            totalVotesCast += sender.studentWeight;
        } else {
            targetDelegate.studentWeight += sender.studentWeight;
        }
    }

    function voteForClub(uint clubIndex) external {
        Representative storage sender = representatives[msg.sender];
        require(sender.studentWeight > 0, "Not authorized to vote.");
        require(!sender.hasVoted, "Already voted.");
        require(clubIndex < clubs.length, "Invalid club choice.");

        sender.hasVoted = true;
        sender.votedClubIndex = clubIndex;
        clubs[clubIndex].totalVotes += sender.studentWeight;
        totalVotesCast += sender.studentWeight;
    }

    function calculateBudgetDistribution() external {
        require(msg.sender == dean, "Only the Dean can execute payout calculations.");
        require(totalVotesCast > 0, "No votes were cast.");
        for (uint i = 0; i < clubs.length; i++) {
            clubs[i].allocatedBudget = (clubs[i].totalVotes * totalTreasuryPool) / totalVotesCast;
        }
    }

    function getClubDetails(uint clubIndex) external view
        returns (string memory name, uint totalVotes, uint allocatedBudget) {
        require(clubIndex < clubs.length, "Invalid club index.");
        Club memory c = clubs[clubIndex];
        return (c.name, c.totalVotes, c.allocatedBudget);
    }
}
```

---

## 🚀 Deployment & Interaction Guide

### Step 1 — Open Remix IDE
Go to [remix.ethereum.org](https://remix.ethereum.org) in your browser.

### Step 2 — Load the Contract
- Create a new file: `CampusBudgetAllocator.sol`
- Paste in the contract code

### Step 3 — Compile
- Go to the **Solidity Compiler** tab
- Select version `0.8.x` (compatible with `>=0.7.0 <0.9.0`)
- Click **Compile CampusBudgetAllocator.sol**
- Ensure no errors appear

### Step 4 — Deploy
- Go to **Deploy & Run Transactions**
- Environment: `Remix VM (Osaka)` for local testing
- Fill constructor parameters:
  - `clubNames`: `["Tech Club", "Arts Club", "Sports Club"]`
  - `_totalTreasuryPool`: `1000000` (arbitrary units or Wei)
- Click **Deploy**

### Step 5 — Interact

| Action | Function | Who |
|---|---|---|
| Register a rep | `registerRepresentative(address, weight)` | Dean only |
| Delegate vote | `delegateVote(address)` | Any registered rep |
| Cast vote | `voteForClub(clubIndex)` | Any registered rep |
| Distribute budget | `calculateBudgetDistribution()` | Dean only |
| View club results | `getClubDetails(clubIndex)` | Anyone |

---

## 🔄 Example Walkthrough

```
Dean deploys with clubs: ["Tech Club", "Arts Club", "Sports Club"], treasury: 1,000,000

Dean registers:
  - Rep A (CS dept) → weight 300
  - Rep B (Arts dept) → weight 200
  - Rep C (Sports dept) → weight 100
  - Rep D (Mech dept) → weight 400

Voting:
  - Rep A → votes for Tech Club (index 0)   → 300 votes
  - Rep B → delegates to Rep A              → Rep A's weight becomes 500
  - Rep C → votes for Sports Club (index 2) → 100 votes
  - Rep D → votes for Arts Club (index 1)   → 400 votes

  (Rep A re-votes? No — hasVoted = true, delegation adds directly to Tech Club)
  After delegation resolved: Tech Club = 500, Arts Club = 400, Sports Club = 100
  Total votes cast = 1000

Dean calls calculateBudgetDistribution():
  Tech Club  → (500 × 1,000,000) / 1000 = 500,000
  Arts Club  → (400 × 1,000,000) / 1000 = 400,000
  Sports Club→ (100 × 1,000,000) / 1000 = 100,000
```

---

## 📊 Key Concepts Summary

| Concept | Usage in Contract |
|---|---|
| `require` | Guards registration, voting, delegation, budget calculation |
| `mapping` | `representatives` — links addresses to voter data |
| `storage` | `Representative storage sender` — modifies blockchain state directly |
| `memory` | `Club memory c` — temporary read in `getClubDetails` |
| `struct` | `Representative` and `Club` — group related fields |
| `string` | Club names — readable over `bytes32` |
| Proportional formula | `(votes × treasury) / totalVotes` — fair budget split |

---

## 📁 Files

```
Experiment 6/
├── CampusBudgetAllocator.sol       # Main smart contract
├── Blockchain_Lab_6 - Atharva Lotankar(D20C_20).pdf  # Lab documentation
└── README.md                       # This file
```

---

## 📖 Further Reading

- [Solidity Docs — require](https://docs.soliditylang.org/en/latest/control-structures.html#error-handling-assert-require-revert-and-exceptions)
- [Solidity Docs — Mappings](https://docs.soliditylang.org/en/latest/types.html#mapping-types)
- [Solidity Docs — Data Locations](https://docs.soliditylang.org/en/latest/types.html#data-location)
- [Remix IDE](https://remix.ethereum.org)
- [Ethereum Ballot Example](https://docs.soliditylang.org/en/latest/solidity-by-example.html#voting)

---

## 👨‍💻 Author

**Atharva Lotankar**

---

<div align="center">

### 🌟 Experiment Status: ✅ Completed

*Smart contract deployed — Campus budget allocated transparently on-chain!*

[![Remix](https://img.shields.io/badge/Open-Remix_IDE-blue?style=for-the-badge&logo=remix)](https://remix.ethereum.org)
[![Solidity](https://img.shields.io/badge/Language-Solidity-purple?style=for-the-badge&logo=solidity)](https://docs.soliditylang.org/)

</div>
