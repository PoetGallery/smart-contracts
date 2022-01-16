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
    Counters.Counter private collectionIDs;

    constructor(address _poemAddress) ERC721("PoetGalleryCollection", "PGC") {
        poemAddress = _poemAddress;
    }

    mapping(uint256 => string) tokenUris;
    mapping(uint256 => Shared.Archetype) public collectionToArchetype;
    mapping(uint256 => uint256) public timesMinted;
    mapping(uint256 => bool) public openForSale;
    mapping(uint256 => uint256[]) public collectionToPoem;
    mapping(uint256 => bool) public isCompleted;

    mapping(uint256 => uint256) collectionToPoemAmount;
    mapping(Shared.Archetype => uint256[]) archetypesCollections;

    event CollectionCompleted(uint256 collectionID);
    event PoemAdded(uint256 collectionID);

    address poemAddress;

    /**
     * @dev Throws if not called by Poem contract.
     */
    modifier onlyPoem() {
        require(
            poemAddress == msg.sender,
            "Can be called only by room contract."
        );
        _;
    }

    function addPoemToCollection(
        Shared.Archetype archetype,
        uint256 poemID,
        uint256 participants
    ) public onlyPoem {
        uint256 poemsAmount = participants == 3 ? 15 : 9;
        uint256[] memory archetypeCollections = archetypesCollections[
            archetype
        ];
        uint256 id = 0;
        for (uint256 i = 0; i < archetypeCollections.length; i++) {
            if (
                !isCompleted[archetypeCollections[i]] &&
                collectionToPoemAmount[archetypeCollections[i]] == poemsAmount
            ) {
                id = archetypeCollections[i];
                break;
            }
        }

        if (id == 0) {
            collectionIDs.increment();
            uint256 newCollectionID = collectionIDs.current();
            collectionToArchetype[newCollectionID] = archetype;
            collectionToPoem[newCollectionID].push(poemID);
            archetypesCollections[archetype].push(newCollectionID);
            isCompleted[newCollectionID] = false;
            openForSale[newCollectionID] = false;
            timesMinted[newCollectionID] = 0;
            collectionToPoemAmount[newCollectionID] = poemsAmount;
        } else {
            collectionToPoem[id].push(poemID);
            // complete a collection
            if (collectionToPoem[id].length == collectionToPoemAmount[id]) {
                isCompleted[id] = true;
                openForSale[id] = true;
                emit CollectionCompleted(id);
            }
        }

        emit PoemAdded(id);
    }

    function mint(uint256 collectionID, string calldata url) public {
        require(openForSale[collectionID], "Collection not open for sale");

        timesMinted[collectionID]++;
        if (timesMinted[collectionID] == 50) {
            openForSale[collectionID] = false;
        }
        _safeMint(msg.sender, collectionID);
        tokenUris[collectionID] = url;
    }

    function tokenURI(uint256 tokenID)
        public
        view
        override
        returns (string memory)
    {
        return tokenUris[tokenID];
    }

    function getPoems(uint256 tokenID) public view returns (uint256[] memory) {
        return collectionToPoem[tokenID];
    }

    function getCollectionsPerArchetype(Shared.Archetype archetype)
        public
        view
        returns (uint256[] memory)
    {
        return archetypesCollections[archetype];
    }
}
