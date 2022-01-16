//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Counters.sol";

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";

import "@openzeppelin/contracts/utils/Counters.sol";

import "./Shared.sol";

contract CollectionNFT is ERC721 {
    using Counters for Counters.Counter;
    Counters.Counter private collectionID;

    mapping(uint => uint) copiesSold; 

    constructor() ERC721("PoetGalleryCollection", "PGC") {}

    // add collection whenever there are enough poems
    function addCompletedCollection() public {

    }

    function mint(address to, string calldata uri) public {


    }
}
