// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

contract Bank {
    mapping(address => uint256) private balances;
    mapping(address => bool) private isUser;

    event AccountCreated(address indexed user, uint256 initialDeposit);
    event Deposit(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);

    // Function to create an account (with optional initial deposit)
    function createAccount() public payable {
        require(!isUser[msg.sender], "Account already exists");
        isUser[msg.sender] = true;
        balances[msg.sender] = msg.value;
        emit AccountCreated(msg.sender, msg.value);
    }

    // Deposit money (takes amount as argument)
    function deposit(uint256 amount) public payable {
        require(isUser[msg.sender], "Account not found");
        require(msg.value == amount, "Sent Ether must match the amount");
        require(amount > 0, "Deposit amount must be greater than 0");

        balances[msg.sender] += amount;
        emit Deposit(msg.sender, amount);
    }

    // Withdraw money
    function withdraw(uint256 amount) public {
        require(isUser[msg.sender], "Account not found");
        require(amount > 0, "Amount must be greater than 0");
        require(balances[msg.sender] >= amount, "Insufficient balance");

        balances[msg.sender] -= amount;

        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Withdrawal failed");

        emit Withdraw(msg.sender, amount);
    }

    // Show current balance
    function getBalance() public view returns (uint256) {
        require(isUser[msg.sender], "Account not found");
        return balances[msg.sender];
    }
}

//1000000000000000000