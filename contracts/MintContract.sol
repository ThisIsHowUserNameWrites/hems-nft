// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MintContract is ERC721, Ownable {
    // infinity token number 
    uint256 public mintPrice = 0.001 ether;
    uint256 private nextTokenId;
    bool public isMintEnabled;

    // user minting permission
    mapping(address => bool) isAllowed;

    constructor() payable ERC721("HEMS Donation NFT", "HEMS")Ownable(msg.sender){
        isMintEnabled = false;
    }
    
    function toggleMintPermission() external onlyOwner{
        isMintEnabled = !isMintEnabled;
    }

    function setUserPermission(address user, bool allowed) external onlyOwner{
        isAllowed[user] = allowed;
    }

    function mint() external payable {
        require(isMintEnabled, "Minting not enabled");
        require(isAllowed, "Minting denied");
        require(msg.value >= mintPrice, "Please reach the minimum amount");
        uint256 tokenId = nextTokenId++;
        _safeMint(msg.sender, tokenId);

    }


}


