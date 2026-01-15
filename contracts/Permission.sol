// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract PermissionManager is Ownable {
    bool public isMintEnabled;
    mapping(address => bool) public isAllowed;

    event UserPermissionSet(address indexed user, bool allowed);

    constructor() Ownable(msg.sender) {}

    //global minting control
    function toggleMintPermission() external onlyOwner{
        isMintEnabled = !isMintEnabled;
    }

    function setUserPermission(address user, bool allowed) external onlyOwner {
        isAllowed[user] = allowed;
        emit UserPermissionSet(user, allowed);
    }
}