// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract OptimalBankingDApp {
    mapping(address => uint256) private balances;

    event Deposit(address indexed account, uint256 amount);
    event Withdrawal(address indexed account, uint256 amount);
    event Transfer(address indexed sender, address indexed receiver, uint256 amount);

    // Explicit non-reverting constructor
    constructor() {}

    function deposit() external payable {
        require(msg.value > 0, "Deposit amount must be greater than zero");
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 _amount) external {
        require(_amount > 0, "Withdrawal amount must be greater than zero");
        require(balances[msg.sender] >= _amount, "Insufficient bank balance");

        balances[msg.sender] -= _amount;

        (bool success, ) = payable(msg.sender).call{value: _amount}("");
        require(success, "Ether transfer failed");

        emit Withdrawal(msg.sender, _amount);
    }

    function transferFunds(address payable _to, uint256 _amount) external {
        require(_to != address(0), "Invalid recipient address");
        require(_to != msg.sender, "Cannot transfer to self");
        require(_amount > 0, "Transfer amount must be greater than zero");
        require(balances[msg.sender] >= _amount, "Insufficient balance");

        balances[msg.sender] -= _amount;
        balances[_to] += _amount;

        emit Transfer(msg.sender, _to, _amount);
    }

    function getBalance(address _account) external view returns (uint256) {
        return balances[_account];
    }
}