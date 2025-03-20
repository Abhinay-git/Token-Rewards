// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract CharityToken {
    string public name = "CharityToken";
    string public symbol = "CHT";
    uint8 public decimals = 18;
    uint256 public totalSupply;
    address public owner;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    mapping(address => bool) public approvedCharities;
    mapping(address => uint256) public donations;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event CharityApproved(address indexed charity, bool status);
    event DonationReceived(address indexed donor, address indexed charity, uint256 amount);
    event TokensRewarded(address indexed donor, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not contract owner");
        _;
    }

    constructor() {
        owner = msg.sender;
        totalSupply = 1000000 * 10 ** uint256(decimals);
        balanceOf[msg.sender] = totalSupply;
    }

    function approveCharity(address charity) external onlyOwner {
        approvedCharities[charity] = true;
        emit CharityApproved(charity, true);
    }

    function removeCharity(address charity) external onlyOwner {
        approvedCharities[charity] = false;
        emit CharityApproved(charity, false);
    }

    function donate(address charity) external payable {
        require(approvedCharities[charity], "Charity not approved");
        require(msg.value > 0, "Donation must be greater than zero");
        
        donations[msg.sender] += msg.value;
        emit DonationReceived(msg.sender, charity, msg.value);
        
        uint256 rewardAmount = msg.value / 10**16; // Reward calculation (1 token per 0.01 ETH)
        balanceOf[msg.sender] += rewardAmount;
        totalSupply += rewardAmount;
        emit TokensRewarded(msg.sender, rewardAmount);
    }

    function transfer(address to, uint256 value) external returns (bool) {
        require(balanceOf[msg.sender] >= value, "Insufficient balance");
        balanceOf[msg.sender] -= value;
        balanceOf[to] += value;
        emit Transfer(msg.sender, to, value);
        return true;
    }

    function approve(address spender, uint256 value) external returns (bool) {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) external returns (bool) {
        require(balanceOf[from] >= value, "Insufficient balance");
        require(allowance[from][msg.sender] >= value, "Allowance exceeded");
        
        balanceOf[from] -= value;
        balanceOf[to] += value;
        allowance[from][msg.sender] -= value;
        emit Transfer(from, to, value);
        return true;
    }
}

