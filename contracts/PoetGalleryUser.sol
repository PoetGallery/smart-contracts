//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title User
 *
 * @dev Implementation of the User concept in the scope of the PoetGallery project
 * @author PoetGallery
 */

contract PoetGalleryUser {

    enum Role {
        NONE,
        ARTIST,
        POET,
        COLLECTOR
    }
    event UserCreated();
    mapping(address => string) public memberToUri;
    mapping(address => Role) public memberToRole;
    mapping(address => address) public currentRoom;

    function createUser(string calldata uri, Role role) public {
        require(!isUser(msg.sender), "Membership already created");
        require(bytes(uri).length > 0, "Membership metadata uri can't be empty");

        memberToUri[msg.sender] = uri;
        memberToRole[msg.sender] = role;
        emit UserCreated();
    }

    function isUser(address member) public view returns(bool) {
        return memberToRole[member] != Role.NONE;
    }

    function assignRoom(address user, address room) public { 
        currentRoom[user] = room;
    }
   
}
