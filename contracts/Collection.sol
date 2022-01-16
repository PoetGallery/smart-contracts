//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Counters.sol";

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";

import "@openzeppelin/contracts/utils/Counters.sol";

import "./Shared.sol";

contract Collection is ERC721 {
    using Counters for Counters.Counter;
    Counters.Counter private collectionID;

    constructor() ERC721("PoetGalleryCollection", "PGC") {}
}
