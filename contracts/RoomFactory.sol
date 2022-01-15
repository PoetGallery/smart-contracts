//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Room.sol";
import "./PoetGalleryUser.sol";
import "./Shared.sol";

contract RoomFactory {
    mapping(address => bool) public isRoom;
    address[] rooms;
    PoetGalleryUser poetGalleryUser;
    address poemFactory;

    event RoomCreated(address roomAddress);

    constructor(address membershipAddress, address poemFactoryAddress) {
        poetGalleryUser = PoetGalleryUser(membershipAddress);
        poemFactory = poemFactoryAddress;
    }

    function deployRoom(Shared.Archetype archetype, uint totalParticipants) public {
        require(poetGalleryUser.isUser(msg.sender), "User has no account");

        address newRoomAddr = address(new Room(msg.sender, archetype, totalParticipants, address(poetGalleryUser), poemFactory));
        rooms.push(newRoomAddr);
        isRoom[newRoomAddr] = true;

        poetGalleryUser.assignRoom(msg.sender, newRoomAddr);

        emit RoomCreated(newRoomAddr);
    }

    function getAllRooms() public view returns(address[] memory) {
        return rooms;
    }
}
