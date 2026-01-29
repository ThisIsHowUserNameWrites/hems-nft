// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title Accounting
 * @notice Simple on-chain accounting for HEMS donations.
 *         - Accepts donations (payable) and mints a receipt NFT per donation
 *         - Tracks totals and per-donor / per-token donation amounts
 *         - Allows the owner to withdraw raised funds to a beneficiary address
 *
 * This contract is intentionally minimal and transparent for an academic project.
 */
contract Accounting is ERC721, Ownable {
    // --- Config ---
    uint256 public minimumDonation;          // optional minimum (can be 0)
    address public beneficiary;              // where withdrawals go (can be updated)

    // --- State / accounting ---
    uint256 public totalAmountRaised;        // sum of all donations ever received (in wei)
    uint256 public totalTokenNumber;         // number of receipt NFTs minted
    uint256 private _nextTokenId;

    mapping(uint256 => uint256) public donationAmountOfToken; // tokenId => amount
    mapping(uint256 => uint256) public donationTimestampOfToken; // tokenId => timestamp
    mapping(address => uint256) public totalDonatedBy;         // donor => total amount donated

    // --- Events ---
    event DonationReceived(address indexed donor, uint256 indexed tokenId, uint256 amount, uint256 timestamp);
    event BeneficiaryUpdated(address indexed oldBeneficiary, address indexed newBeneficiary);
    event MinimumDonationUpdated(uint256 oldMinimum, uint256 newMinimum);
    event Withdrawal(address indexed to, uint256 amount);

    constructor(
        string memory name_,
        string memory symbol_,
        address beneficiary_,
        uint256 minimumDonation_
    )
        ERC721(name_, symbol_)
        Ownable(msg.sender)
    {
        beneficiary = beneficiary_;
        minimumDonation = minimumDonation_;
    }

    // --------- Admin setters 
