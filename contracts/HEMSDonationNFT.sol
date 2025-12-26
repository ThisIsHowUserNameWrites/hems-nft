// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MintContract is ERC721, Ownable {
    uint256 public mintPrice = 0.005 ether;

    constructor() ERC721("HEMS Donation NFT", "HEMS")Ownable(msg.sender){

    }
}


function mint(){

}