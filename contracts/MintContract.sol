// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract MintContract is ERC721, Ownable {
    // infinity token number 
    uint256 public mintPrice = 0.001 ether;
    uint256 private nextTokenId = 1;
    IPermission public permission;
    IAccounting public accounting;

    constructor(address permissionAddress) payable ERC721("HEMS Donation NFT", "HEMS")Ownable(msg.sender){
       permission = IPermission(permissionAddress);
       //accounting = IAccounting(accountingAddress);
       require(permissionAddress != address(0), "Null address");
       //require(accountingAddress != address(0), "Null address");
    }
    
    
    //donation event
    event Donation(
        address indexed donor,
        uint256 indexed token,
        uint256 amount,
        uint256 timestamp);

    function setAccounting(address accountingAddress) external onlyOwner {
        require(accountingAddress != address(0), "Null address");
        accounting = IAccounting(accountingAddress);
        
    }
    
    function mint() external payable returns (uint256 tokenId){
        
        require(permission.isMintEnabled(), "Minting not enabled");
        require(permission.isAllowed(msg.sender), "No minting permission");
        require(msg.value >= mintPrice, "Please reach the minimum amount");

        tokenId = nextTokenId;
        nextTokenId++;
        _safeMint(msg.sender, tokenId);

        //register donate event
        emit Donation(msg.sender, tokenId, msg.value, block.timestamp);
        accounting.recordDonation(msg.sender, tokenId, msg.value, block.timestamp);
        
    }


}

interface IPermission {
    function isMintEnabled() external view returns (bool);
    function isAllowed(address user) external view returns (bool);
}

interface IAccounting {
    function recordDonation(address donor, uint256 tokenId, uint256 amount, uint256 timestamp) external;
}
