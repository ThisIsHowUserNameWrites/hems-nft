// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract PermissionManager is Ownable {
    enum Role { None, Admin, User }
    mapping(address => Role) public roles;
    mapping(address => bool) public isAllowed;
    bool public isMintEnabled;

    event RoleAssigned(address indexed user, Role role);

    modifier onlyAdmin() {
        require(roles[msg.sender] == Role.Admin || msg.sender == owner(), "Error: Permission denied");
        _;
    }

    constructor() Ownable(msg.sender) {
        roles[msg.sender] = Role.Admin ;
        emit RoleAssigned(msg.sender, Role.Admin);
    }
    function promoteToAdmin(address user) external onlyAdmin {
        roles[user] = Role.Admin;
        emit RoleAssigned(user, Role.Admin);
    }

    function toggleMintPermission() external onlyAdmin {
        isMintEnabled = !isMintEnabled;
    }

    function setUserPermission(address user, bool allowed) external onlyAdmin {
        isAllowed[user] = allowed;
    }

    function isAdmin(address user) public view returns (bool) {
        return roles[user] == Role.Admin;
    }
}