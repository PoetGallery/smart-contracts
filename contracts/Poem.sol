//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Counters.sol";
import "./Shared.sol";

contract PoemFactory {
    event PoemStarted(uint256 poemID);
    event PoemContinued(uint256 poemID);
    event PoemFinished(uint256 poemID);

    struct Poem {
        string uri;
        Shared.Archetype archetype;
        bool isFinished;
        address[] authors;
    }

    using Counters for Counters.Counter;
    Counters.Counter private poemCounter;

    mapping(address => uint256) public poemsPerRoom;
    mapping(uint256 => Poem) public poems;

    /**
     * @dev Throws if not called by Room contract.
     */
    modifier onlyRoom(uint256 poemID) {
        require(
            poemsPerRoom[msg.sender] == poemID,
            "Can be called only by room contract."
        );
        _;
    }

    function startPoem(
        address author,
        string calldata uri,
        Shared.Archetype archetype
    ) public {
        require(bytes(uri).length > 0, "Poem uri can't be an empty string");

        address[] memory authors = new address[](1);
        authors[0] = author;

        uint256 poemID = poemCounter.current();
        poemsPerRoom[msg.sender] = poemID;
        poems[poemID] = Poem(uri, archetype, false, authors);
        poemCounter.increment();
        emit PoemStarted(poemID);
    }

    function continuePoem(string calldata uri)
        public
        onlyRoom(poemsPerRoom[msg.sender])
    {
        require(bytes(uri).length > 0, "Poem uri can't be an empty string");
        uint256 poemID = poemsPerRoom[msg.sender];

        require(bytes(poems[poemID].uri).length > 0, "Poem not found");

        poems[poemID].uri = uri;

        emit PoemContinued(poemID);
    }

    function finalizePoem(string calldata uri)
        public
        onlyRoom(poemsPerRoom[msg.sender])
    {
        require(bytes(uri).length > 0, "Poem uri can't be an empty string");

        uint256 poemID = poemsPerRoom[msg.sender];
        require(bytes(poems[poemID].uri).length > 0, "Poem not found");

        poems[poemID].uri = uri;
        poems[poemID].isFinished = true;

        // TODO: add to collection
        emit PoemContinued(poemID);
    }

    function getPoemAuthors(uint poemID) public view returns(address[] memory) {
        return poems[poemID].authors;
    }
}
