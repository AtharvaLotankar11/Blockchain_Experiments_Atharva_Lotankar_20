# 🔐 Experiment 1: Blockchain Fundamentals & Cryptographic Hashing

<div align="center">

![Blockchain](https://img.shields.io/badge/Blockchain-Fundamentals-blue?style=for-the-badge&logo=ethereum)
![Python](https://img.shields.io/badge/Python-3.8+-green?style=for-the-badge&logo=python)
![Cryptography](https://img.shields.io/badge/Cryptography-SHA256-orange?style=for-the-badge&logo=letsencrypt)

</div>

---

## 📋 Overview

This experiment introduces the **fundamental concepts of blockchain technology** through hands-on implementation of cryptographic hashing, proof-of-work mechanisms, and Merkle tree structures. These foundational elements are critical to understanding how blockchains achieve security, immutability, and data integrity.

---

## 🎯 Learning Objectives

- ✅ Understand **SHA-256 cryptographic hashing**
- ✅ Implement **Proof-of-Work (PoW)** mining algorithms
- ✅ Build and visualize **Merkle Trees** for transaction verification
- ✅ Explore **nonce discovery** and leading zero constraints
- ✅ Learn the mathematical foundations of blockchain security

---

## 📚 Theory

### 🔑 Cryptographic Hashing (SHA-256)

**SHA-256** (Secure Hash Algorithm 256-bit) is a one-way cryptographic function that:
- Converts input data of any size into a fixed 256-bit (64-character hexadecimal) output
- Produces a unique "digital fingerprint" for each unique input
- Is computationally infeasible to reverse (pre-image resistance)
- Ensures data integrity and immutability in blockchains

**Properties:**
- **Deterministic**: Same input always produces same hash
- **Avalanche Effect**: Small change in input drastically changes output
- **Collision Resistant**: Extremely difficult to find two inputs with same hash

### ⛏️ Proof-of-Work (PoW)

Proof-of-Work is a consensus mechanism that:
- Requires miners to solve computationally expensive puzzles
- Involves finding a **nonce** (number used once) that produces a hash with specific properties
- Typically requires hash to have a certain number of **leading zeros**
- Difficulty adjusts based on network requirements
- Secures the network by making attacks economically unfeasible

**Mining Process:**
```
Input = Data + Nonce
Hash = SHA256(Input)
Valid if Hash starts with required number of zeros (e.g., 0000...)
```

### 🌳 Merkle Trees

A **Merkle Tree** is a binary tree data structure where:
- Each leaf node contains a hash of transaction data
- Each non-leaf node contains a hash of its child nodes
- The root hash (Merkle Root) represents all transactions
- Allows efficient verification of data integrity
- Enables lightweight verification without downloading entire blockchain

**Benefits:**
- Efficient data verification
- Space-efficient storage
- Quick detection of tampering
- Foundation of **Simplified Payment Verification (SPV)**

---

## 🧪 Experiments Included

### **Program 1: Basic SHA-256 Hashing**
Generate SHA-256 hash for any input string.

```python
# Input: "Atharva"
# Output: 51056b6a6a7b468483de6de32b530b482ab397dc83ec34c2ebdcf24bf6b4321d
```

### **Program 2: Hash with Nonce**
Combine input string with nonce and generate hash.

```python
# Input: "Blockchain" + Nonce: "20"
# Output: b4fba819ca27a6ad7091d9a3b02d5e5118a9b7e0158b54fe973c479703d342cf
```

### **Program 3: Proof-of-Work Mining**
Find nonce that produces hash with required leading zeros.

```python
# Input: "Atharva", Leading Zeros: 5
# Output: Nonce = 202131
# Hash: 00000935de79b5d4e83aa4f186235b24a826c8dff3122b789340ae0b5ebd7cb3
```

### **Program 4: Merkle Tree Construction**
Build Merkle tree from transaction set and compute Merkle root.

```python
# Transactions:
# - Atharva -> Manaswi : $520
# - Manaswi -> Ronit : $100
# - Ronit -> Shakti : $256
# - Shakti -> John : $300
# - John -> Manaswi : $95
# Merkle Root: 1633df9eb5cab872815c416e7c4c631208be4f0bcc07e91a7b4cb5c241594d03
```

---

## 🚀 Getting Started

### Prerequisites

```bash
Python 3.8 or higher
Jupyter Notebook or Google Colab
```

### Installation

```bash
# No external libraries required - uses built-in hashlib
pip install jupyter notebook
```

### Running the Experiments

1. **Open Jupyter Notebook:**
   ```bash
   jupyter notebook Blockchain_Lab_1.ipynb
   ```

2. **Or use Google Colab:**
   - Upload `Blockchain_Lab_1.ipynb` to Google Colab
   - Run cells sequentially

3. **Execute each program:**
   - Run cells in order
   - Enter custom inputs when prompted
   - Observe hash outputs and mining process

---

## 📊 Results & Observations

### Hash Properties Demonstration
- Different inputs produce completely different hashes
- Same input always produces identical hash
- Hash length remains constant (64 hex characters)

### Proof-of-Work Insights
- More leading zeros = exponentially more computation
- Mining difficulty directly impacts time required
- Demonstrates blockchain's energy-intensive nature

### Merkle Tree Efficiency
- Enables verification of single transaction without full dataset
- Root hash changes if any transaction is modified
- Foundation for lightweight blockchain clients

---

## 🔍 Key Takeaways

| Concept | Application in Blockchain |
|---------|--------------------------|
| **SHA-256** | Block hashing, transaction IDs, address generation |
| **Proof-of-Work** | Consensus mechanism, mining, network security |
| **Merkle Trees** | Transaction verification, SPV wallets, data integrity |
| **Nonce** | Mining process, block validation |

---

## 📖 Further Reading

- [Bitcoin Whitepaper - Satoshi Nakamoto](https://bitcoin.org/bitcoin.pdf)
- [SHA-256 Algorithm Explained](https://en.wikipedia.org/wiki/SHA-2)
- [Merkle Tree Data Structure](https://en.wikipedia.org/wiki/Merkle_tree)
- [Understanding Proof-of-Work](https://ethereum.org/en/developers/docs/consensus-mechanisms/pow/)

---

## 📁 Files

- `Blockchain_Lab_1.ipynb` - Interactive Jupyter notebook with all experiments
- `Blockchain_Lab_1.pdf` - Complete lab documentation
- `README.md` - This file

---

## 👨‍💻 Author

**Atharva Lotankar**

---

<div align="center">

### 🌟 Experiment Status: ✅ Completed

*Foundational concepts mastered - Ready for blockchain implementation!*

</div>
