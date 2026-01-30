// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.20;

contract MintAccounting {
    uint256 public totalRaised;
    uint256 public totalTokens;

    address public mintContract;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier onlyMintContract() {
        require(msg.sender == mintContract, "Not authorized");
        _;
    }

    function setMintContract(address mintContractAddress) external onlyOwner {
        require(mintContractAddress != address(0), "Null address");
        mintContract = mintContractAddress;
    }

    function recordDonation(address donor, uint256 tokenId, uint256 amount, uint256 timestamp) external onlyMintContract{
        totalRaised += amount;
        totalTokens += 1;
    }
}
