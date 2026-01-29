// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract MintContract is ERC721, Ownable {
    // infinity token number 
    uint256 public mintPrice = 0.001 ether;
    uint256 private nextTokenId;
    IPermission public permission;
    IAccounting public accounting;

    constructor() payable ERC721("HEMS Donation NFT", "HEMS")Ownable(msg.sender){
       
    }
    
    
    //donation event
    event Donation(
        address indexed donor,
        uint256 indexed token,
        uint256 amount,
        uint256 timestamp);
        
    
    function mint() external payable {
        
        require(permission.isMintEnabled(), "Minting not enabled");
        require(permission.isAllowed(msg.sender), "No minting permission");
        require(msg.value >= mintPrice, "Please reach the minimum amount");
        uint256 tokenId = nextTokenId++;
        _safeMint(msg.sender, tokenId);

        //register donate event
        emit Donation(msg.sender, tokenId, msg.value, block.timestamp);

    }


}

interface IPermission {
    function isMintEnabled() external view returns (bool);
    function isAllowed(address user) external view returns (bool);
}

interface IAccounting {
    function recordDonation(address donor, uint256 tokenId, uint256 amount, uint256 timestamp) external;
}
