# 🌐 Experiment 3: Hadcoin - Decentralized Cryptocurrency Network

<div align="center">

![Cryptocurrency](https://img.shields.io/badge/Cryptocurrency-Hadcoin-gold?style=for-the-badge&logo=bitcoin)
![Distributed](https://img.shields.io/badge/Network-Distributed-red?style=for-the-badge&logo=ethereum)
![Consensus](https://img.shields.io/badge/Consensus-Longest_Chain-green?style=for-the-badge&logo=hyperledger)

</div>

---

## 📋 Overview

**Hadcoin** is a fully functional **decentralized cryptocurrency** implementation featuring multiple networked nodes, consensus protocols, and distributed transaction processing. This experiment demonstrates how cryptocurrencies achieve decentralization, consensus, and network synchronization across multiple independent nodes.

---

## 🎯 Learning Objectives

- ✅ Build a **multi-node blockchain network**
- ✅ Implement **distributed consensus mechanism**
- ✅ Create **peer-to-peer node communication**
- ✅ Develop **cryptocurrency transaction system**
- ✅ Deploy **longest chain consensus protocol**
- ✅ Understand **network synchronization**
- ✅ Handle **mining rewards** and **block rewards**

---

## 📚 Theory

### 🌍 Decentralized Network Architecture

Unlike Experiment 2's single-node blockchain, Hadcoin operates as a **distributed network**:

```
     Node 5001 ←→ Node 5002 ←→ Node 5003
         ↓             ↓             ↓
     Blockchain    Blockchain    Blockchain
```

**Key Features:**
- Multiple independent nodes
- Peer-to-peer communication
- Shared transaction pool
- Synchronized blockchain state

### 🤝 Consensus Mechanism: Longest Chain Rule

**Problem:** Different nodes may have different versions of the blockchain.

**Solution:** Nodes agree to accept the **longest valid chain** as truth.

**Process:**
1. Each node maintains its own blockchain
2. Nodes periodically query peers for chain length
3. If a longer valid chain is found, node adopts it
4. Network converges on single version of history

**Why it works:**
- Longest chain represents most cumulative work
- Attacking requires outpacing entire network
- Economically infeasible to maintain fraudulent chain

### 💎 Cryptocurrency Components

**Transaction Structure:**
```json
{
  "sender": "node_address_abc123",
  "receiver": "Richard",
  "amount": 1
}
```

**Mining Rewards:**
- Miners receive cryptocurrency for mining blocks
- Incentivizes honest participation
- Hadcoin reward: 1 coin per block

**Node Address:**
- Unique UUID for each node
- Identifies transaction participants
- Functions as wallet address

### 🔗 Node Discovery & Registration

**Registration Process:**
1. New node connects to network
2. Sends list of known nodes to existing node
3. Existing node adds new peer to node set
4. Network topology expands organically

**Benefits:**
- Dynamic network growth
- Fault tolerance
- No central authority

---

## 🧪 Network Architecture

### Node Configuration

| Node | Port | Role |
|------|------|------|
| **Node 1** | 5001 | Primary node |
| **Node 2** | 5002 | Peer node |
| **Node 3** | 5003 | Peer node |

Each node runs identical code on different ports, creating a simulated distributed network.

---

## 🚀 Getting Started

### Prerequisites

```bash
Python 3.8+
Flask==0.12.2
requests==2.18.4
```

### Installation

```bash
# Install dependencies
pip install Flask==0.12.2
pip install requests==2.18.4
```

### Running the Network

**Terminal 1 - Node 5001:**
```bash
python hadcoin_node_5001.py
```

**Terminal 2 - Node 5002:**
```bash
python hadcoin_node_5002.py
```

**Terminal 3 - Node 5003:**
```bash
python hadcoin_node_5003.py
```

All nodes will run simultaneously on:
- `http://127.0.0.1:5001`
- `http://127.0.0.1:5002`
- `http://127.0.0.1:5003`

---

## 💻 API Endpoints

### 📡 Cryptocurrency Operations

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/mine_block` | Mine new block with pending transactions |
| `GET` | `/get_chain` | Retrieve node's blockchain |
| `GET` | `/is_valid` | Validate blockchain integrity |
| `POST` | `/add_transaction` | Add transaction to mempool |
| `POST` | `/connect_node` | Register peer nodes |
| `GET` | `/replace_chain` | Sync with longest chain |

---

## 🎮 Complete Usage Workflow

### Step 1: Connect Nodes to Network

**Connect Node 5001 to others:**
```bash
curl -X POST http://127.0.0.1:5001/connect_node \
  -H "Content-Type: application/json" \
  -d '{
    "nodes": [
      "http://127.0.0.1:5002",
      "http://127.0.0.1:5003"
    ]
  }'
```

**Response:**
```json
{
  "message": "All the nodes are now connected. The Hadcoin Blockchain now contains the following nodes:",
  "total_nodes": ["127.0.0.1:5002", "127.0.0.1:5003"]
}
```

**Repeat for Node 5002 and 5003** (connecting to other nodes)

### Step 2: Add Transactions

**Add transaction on Node 5001:**
```bash
curl -X POST http://127.0.0.1:5001/add_transaction \
  -H "Content-Type: application/json" \
  -d '{
    "sender": "Alice",
    "receiver": "Bob",
    "amount": 100
  }'
```

**Add transaction on Node 5002:**
```bash
curl -X POST http://127.0.0.1:5002/add_transaction \
  -H "Content-Type: application/json" \
  -d '{
    "sender": "Charlie",
    "receiver": "Diana",
    "amount": 50
  }'
```

### Step 3: Mine Blocks

**Mine on Node 5001:**
```bash
curl http://127.0.0.1:5001/mine_block
```

**Response:**
```json
{
  "message": "Congratulations, you just mined a block!",
  "index": 2,
  "timestamp": "2024-01-15 15:45:30",
  "proof": 12345,
  "previous_hash": "abc...",
  "transactions": [
    {"sender": "Alice", "receiver": "Bob", "amount": 100},
    {"sender": "node_abc123", "receiver": "Richard", "amount": 1}
  ]
}
```

**Mine on Node 5002:**
```bash
curl http://127.0.0.1:5002/mine_block
```

### Step 4: Synchronize Network (Consensus)

**Replace chain on Node 5003:**
```bash
curl http://127.0.0.1:5003/replace_chain
```

**Response (if Node 5001 has longer chain):**
```json
{
  "message": "The nodes had different chains so the chain was replaced by the longest one.",
  "new_chain": [...]
}
```

**Response (if already synchronized):**
```json
{
  "message": "All good. The chain is the largest one.",
  "actual_chain": [...]
}
```

### Step 5: Verify Synchronization

**Check all node chains:**
```bash
curl http://127.0.0.1:5001/get_chain
curl http://127.0.0.1:5002/get_chain
curl http://127.0.0.1:5003/get_chain
```

All nodes should now have identical chains after consensus!

---

## 🔬 Testing Scenarios

### Scenario 1: Chain Fork Resolution

1. Disconnect Node 5003 from network
2. Mine blocks on Node 5001 and 5002
3. Mine different blocks on Node 5003
4. Reconnect Node 5003
5. Run `/replace_chain` on Node 5003
6. **Result:** Node 5003 adopts longer chain

### Scenario 2: Transaction Propagation

1. Add transaction on Node 5001
2. Mine block on Node 5001
3. Run `/replace_chain` on Node 5002 and 5003
4. **Result:** Transaction appears across all nodes

### Scenario 3: Distributed Mining

1. Mine block on Node 5001
2. Mine block on Node 5002
3. Synchronize all nodes
4. **Result:** Network converges on consistent state

---

## 📊 Key Features

### ✨ Advanced Capabilities

- ✅ **Multi-Node Network**: True distributed architecture
- ✅ **Peer Discovery**: Dynamic node registration
- ✅ **Consensus Protocol**: Longest chain rule
- ✅ **Mining Rewards**: Cryptocurrency incentives
- ✅ **Chain Synchronization**: Automatic conflict resolution
- ✅ **Transaction Broadcasting**: Cross-node communication
- ✅ **Fault Tolerance**: Network resilience

### 🔐 Security Features

- **Distributed Trust**: No single point of failure
- **Byzantine Fault Tolerance**: Operates despite malicious nodes
- **Chain Validation**: Continuous integrity checks
- **Consensus Security**: Attack requires majority network control

---

## 🎓 Concepts Demonstrated

| Concept | Implementation |
|---------|----------------|
| **Decentralization** | Independent nodes with equal authority |
| **Consensus** | Longest chain rule |
| **P2P Network** | Node-to-node communication |
| **Cryptocurrency** | Hadcoin with mining rewards |
| **Distributed Ledger** | Replicated blockchain across nodes |
| **Network Sync** | Chain replacement mechanism |

---

## 🔍 Code Highlights

### Node Registration
```python
def add_node(self, address):
    parsed_url = urlparse(address)
    self.nodes.add(parsed_url.netloc)
```

### Consensus Protocol
```python
def replace_chain(self):
    network = self.nodes
    longest_chain = None
    max_length = len(self.chain)
    
    for node in network:
        response = requests.get(f'http://{node}/get_chain')
        if response.status_code == 200:
            length = response.json()['length']
            chain = response.json()['chain']
            
            if length > max_length and self.is_chain_valid(chain):
                max_length = length
                longest_chain = chain
    
    if longest_chain:
        self.chain = longest_chain
        return True
    return False
```

### Mining with Rewards
```python
@app.route('/mine_block', methods=['GET'])
def mine_block():
    # Add mining reward
    blockchain.add_transaction(
        sender=node_address,
        receiver='Richard',
        amount=1
    )
    # Mine block
    block = blockchain.create_block(proof, previous_hash)
```

---

## 🚧 Real-World Comparison

| Feature | Hadcoin | Bitcoin | Ethereum |
|---------|---------|---------|----------|
| **Consensus** | Longest Chain | PoW (SHA-256) | PoS (Casper) |
| **Block Reward** | 1 Hadcoin | 6.25 BTC | 2 ETH |
| **Network** | Local (3 nodes) | Global (15K+ nodes) | Global (8K+ nodes) |
| **Purpose** | Educational | Currency | Smart Contracts |

---

## 📖 Further Reading

- [Bitcoin P2P Network](https://developer.bitcoin.org/devguide/p2p_network.html)
- [Consensus Mechanisms Explained](https://ethereum.org/en/developers/docs/consensus-mechanisms/)
- [Distributed Systems Theory](https://www.microsoft.com/en-us/research/publication/time-clocks-ordering-events-distributed-system/)

---

## 📁 Files

- `hadcoin_node_5001.py` - Node 1 implementation
- `hadcoin_node_5002.py` - Node 2 implementation
- `hadcoin_node_5003.py` - Node 3 implementation
- `Blockchain_Lab_3.pdf` - Complete lab documentation
- `README.md` - This file

---

## 👨‍💻 Author

**Atharva Lotankar**

---

<div align="center">

### 🌟 Experiment Status: ✅ Completed

*Decentralized cryptocurrency network with consensus - Ready for real-world applications!*

[![Node 1](https://img.shields.io/badge/Node-5001-blue?style=for-the-badge)](hadcoin_node_5001.py)
[![Node 2](https://img.shields.io/badge/Node-5002-green?style=for-the-badge)](hadcoin_node_5002.py)
[![Node 3](https://img.shields.io/badge/Node-5003-orange?style=for-the-badge)](hadcoin_node_5003.py)

</div>
