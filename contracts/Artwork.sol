//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./Shared.sol";
import "./PoetGalleryUser.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Artwork {
    event ArtworkAdded(uint256 artworkID);

    using Counters for Counters.Counter;
    Counters.Counter private artworkID;

    struct ArtworkDetails {
        string uri;
        address owner;
        Shared.Archetype archetype;
    }

    mapping(Shared.Archetype => uint[]) archetypeToArtwork;
    mapping(uint => ArtworkDetails) artworkDetails;

    PoetGalleryUser poetGalleryUsers;
    constructor(address _poetGalleryUser) {
        poetGalleryUsers = PoetGalleryUser(_poetGalleryUser);
        artworkID.increment();
    }
    
    function addArtwork(string calldata uri, Shared.Archetype archetype) public {
        require(
            poetGalleryUsers.isUser(msg.sender),
            "Should create a profile first"
        );

        uint artID = artworkID.current();
        artworkDetails[artID] = ArtworkDetails(uri, msg.sender, archetype);
        archetypeToArtwork[archetype].push(artID);

        artworkID.increment();
        emit ArtworkAdded(artID);
    }
}
