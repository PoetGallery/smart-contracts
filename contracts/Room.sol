//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./Shared.sol";
import "./PoetGalleryUser.sol";
import "./Poem.sol";

contract Room {
    event ParticipantJoined();
    event PoemStarted(uint256 poemID);
    event PoemContinued(uint256 poemID);
    event PoemFinished(uint256 poemID);

    PoetGalleryUser poetGalleryUser;
    mapping(address => bool) public isParticipant;
    uint256 public totalParticipants;
    uint256 public currentParticipantsAmount;
    Shared.Archetype public archetype;
    bool public isClosed;

    PoemFactory poem;

    constructor(
        address _creator,
        Shared.Archetype _archetype,
        uint256 _totalParticipants,
        address _poetGalleryUser,
        address _poem
    ) {
        isParticipant[_creator] = true;
        archetype = _archetype;
        totalParticipants = _totalParticipants;
        poetGalleryUser = PoetGalleryUser(_poetGalleryUser);
        isClosed = false;
        currentParticipantsAmount = 1;
        poem = PoemFactory(_poem);
    }

    function join() public {
        require(
            currentParticipantsAmount <= totalParticipants,
            "Max amount of participants reached."
        );

        require(
            poetGalleryUser.isUser(msg.sender),
            "Should create a profile first"
        );
        require(
            poetGalleryUser.currentRoom(msg.sender) == address(0) ||
                Room(poetGalleryUser.currentRoom(msg.sender)).isClosed(),
            "Already in an active room"
        );

        isParticipant[msg.sender] = true;
        currentParticipantsAmount++;

        emit ParticipantJoined();
    }

    function continuePoem(string calldata uri) public {
        require(
            isParticipant[msg.sender],
            "Only participants can continue poems"
        );

        poem.continuePoem(uri);
    }

    function startPoem(string calldata uri) public {
        require(
            isParticipant[msg.sender],
            "Only participants can continue poems"
        );

        poem.startPoem(msg.sender, uri, archetype);
    }
}
