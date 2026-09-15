# ⛓️ Experiment 2: Building a Complete Blockchain with REST API

<div align="center">

![Blockchain](https://img.shields.io/badge/Blockchain-Implementation-purple?style=for-the-badge&logo=bitcoin)
![Flask](https://img.shields.io/badge/Flask-REST_API-black?style=for-the-badge&logo=flask)
![Python](https://img.shields.io/badge/Python-3.8+-blue?style=for-the-badge&logo=python)

</div>

---

## 📋 Overview

This experiment demonstrates the **complete implementation of a functional blockchain** from scratch using Python. It includes core blockchain functionality, transaction management, mining capabilities, and a **Flask-based REST API** for interaction. This is a working prototype that mimics real blockchain behavior.

---

## 🎯 Learning Objectives

- ✅ Build a **complete blockchain data structure**
- ✅ Implement **Proof-of-Work mining algorithm**
- ✅ Create **transaction management system**
- ✅ Develop **REST API** for blockchain interaction
- ✅ Validate blockchain integrity
- ✅ Understand **mempool** (transaction pool) mechanics

---

## 📚 Theory

### 🧱 Blockchain Architecture

A blockchain is a distributed ledger consisting of:

**Block Structure:**
```json
{
  "index": 1,
  "timestamp": "2024-01-15 10:30:45",
  "proof": 12345,
  "previous_hash": "abc123...",
  "transactions": [...]
}
```

**Key Components:**
- **Index**: Sequential block number
- **Timestamp**: Block creation time
- **Proof**: Nonce found through PoW mining
- **Previous Hash**: Links block to previous (chain integrity)
- **Transactions**: List of pending transactions included in block

### 💰 Transaction Lifecycle

1. **Transaction Creation**: User submits transaction to mempool
2. **Mempool Storage**: Transaction waits for mining
3. **Mining**: Miner includes transactions in new block
4. **Block Addition**: Valid block added to chain
5. **Mempool Clearing**: Mined transactions removed from pool

### ⛏️ Mining Process

```python
# Mining Algorithm
1. Get pending transactions from mempool
2. Get previous block's proof
3. Find new proof (solve PoW puzzle)
4. Calculate previous block's hash
5. Create new block with proof and hash
6. Clear mempool
7. Return mined block
```

**Proof-of-Work Puzzle:**
```
Find nonce where: SHA256(new_proof² - previous_proof²) starts with '000'
```

### ✅ Chain Validation

Validation ensures:
- Each block's `previous_hash` matches actual hash of previous block
- Each block's proof-of-work is valid
- No blocks have been tampered with
- Chain maintains continuity

---

## 🧪 API Endpoints

### 📡 Available Routes

| Method | Endpoint | Description |
|--------|----------|-------------|
| `POST` | `/add_transaction` | Add transaction to mempool |
| `GET` | `/mine_block` | Mine pending transactions |
| `GET` | `/get_chain` | Retrieve entire blockchain |
| `GET` | `/is_valid` | Validate blockchain integrity |

---

## 🚀 Getting Started

### Prerequisites

```bash
Python 3.8+
Flask 0.12.2+
```

### Installation

```bash
# Install Flask
pip install Flask

# Or use requirements
pip install flask jsonify
```

### Running the Blockchain

1. **Start the Flask Server:**
   ```bash
   python blockchain_exp_2.py
   ```

2. **Server will run on:**
   ```
   http://localhost:5000
   ```

---

## 💻 Usage Examples

### 1️⃣ Add Transaction

**Request:**
```bash
curl -X POST http://localhost:5000/add_transaction \
  -H "Content-Type: application/json" \
  -d '{
    "sender": "Alice",
    "receiver": "Bob",
    "amount": 50
  }'
```

**Response:**
```json
{
  "message": "Transaction will be added to Block 2"
}
```

### 2️⃣ Mine Block

**Request:**
```bash
curl http://localhost:5000/mine_block
```

**Response:**
```json
{
  "message": "Block mined successfully!",
  "index": 2,
  "timestamp": "2024-01-15 14:30:22",
  "proof": 45678,
  "previous_hash": "abc123...",
  "transactions": [
    {
      "sender": "Alice",
      "receiver": "Bob",
      "amount": 50
    }
  ]
}
```

### 3️⃣ Get Full Chain

**Request:**
```bash
curl http://localhost:5000/get_chain
```

**Response:**
```json
{
  "chain": [...],
  "length": 2
}
```

### 4️⃣ Validate Chain

**Request:**
```bash
curl http://localhost:5000/is_valid
```

**Response:**
```json
{
  "message": "The Blockchain is valid."
}
```

---

## 🔬 Testing Workflow

### Complete Test Scenario

```bash
# Step 1: Start server
python blockchain_exp_2.py

# Step 2: Add multiple transactions
curl -X POST http://localhost:5000/add_transaction \
  -H "Content-Type: application/json" \
  -d '{"sender":"Alice","receiver":"Bob","amount":50}'

curl -X POST http://localhost:5000/add_transaction \
  -H "Content-Type: application/json" \
  -d '{"sender":"Bob","receiver":"Charlie","amount":30}'

# Step 3: Mine block
curl http://localhost:5000/mine_block

# Step 4: View chain
curl http://localhost:5000/get_chain

# Step 5: Validate integrity
curl http://localhost:5000/is_valid
```

---

## 📊 Key Features

### ✨ Implemented Functionality

- ✅ **Genesis Block Creation**: Automatic initialization
- ✅ **Transaction Management**: Add and store transactions
- ✅ **Proof-of-Work Mining**: Computational puzzle solving
- ✅ **Chain Validation**: Integrity verification
- ✅ **REST API**: HTTP endpoints for interaction
- ✅ **JSON Serialization**: Standardized data format
- ✅ **Mempool Management**: Transaction pool handling

### 🔐 Security Features

- **Hash Linking**: Each block cryptographically linked to previous
- **PoW Protection**: Prevents spam and manipulation
- **Immutability**: Previous blocks cannot be altered
- **Validation**: Continuous integrity checking

---

## 🎓 Concepts Demonstrated

| Concept | Implementation |
|---------|----------------|
| **Blockchain Data Structure** | List of linked blocks |
| **Hashing** | SHA-256 for block integrity |
| **Proof-of-Work** | Mining with difficulty constraint |
| **Transactions** | Mempool and block inclusion |
| **REST API** | Flask-based HTTP interface |
| **Validation** | Chain integrity verification |

---

## 🔍 Code Highlights

### Block Creation
```python
def create_block(self, proof, previous_hash):
    block = {
        'index': len(self.chain) + 1,
        'timestamp': str(datetime.datetime.now()),
        'proof': proof,
        'previous_hash': previous_hash,
        'transactions': self.transactions
    }
    self.transactions = []  # Clear mempool
    self.chain.append(block)
    return block
```

### Proof-of-Work
```python
def proof_of_work(self, previous_proof):
    new_proof = 1
    while True:
        hash_operation = hashlib.sha256(
            str(new_proof**2 - previous_proof**2).encode()
        ).hexdigest()
        
        if hash_operation[:3] == '000':
            return new_proof
        new_proof += 1
```

---

## 🚧 Limitations & Future Enhancements

### Current Limitations
- Single node (no networking)
- No consensus mechanism
- No peer-to-peer communication
- Centralized architecture

### Possible Enhancements
- 🌐 Multi-node networking
- 🤝 Consensus protocol
- 💼 Wallet implementation
- 🔐 Digital signatures
- 📊 Block explorer UI

---

## 📖 Further Reading

- [Building Blockchain in Python](https://www.activestate.com/blog/how-to-build-a-blockchain-in-python/)
- [Flask REST API Documentation](https://flask.palletsprojects.com/)
- [Blockchain Architecture Patterns](https://www.blockchain-council.org/blockchain/blockchain-architecture-basics/)

---

## 📁 Files

- `blockchain_exp_2.py` - Complete blockchain implementation with Flask API
- `Blockchain_Lab_2.ipynb` - Jupyter notebook version
- `Blockchain_Lab_2.docx.pdf` - Lab documentation
- `README.md` - This file

---

## 👨‍💻 Author

**Atharva Lotankar**

---

<div align="center">

### 🌟 Experiment Status: ✅ Completed

*Full blockchain implementation with REST API - Ready for distributed systems!*

[![Run](https://img.shields.io/badge/Run-python_blockchain__exp__2.py-success?style=for-the-badge)](blockchain_exp_2.py)

</div>
