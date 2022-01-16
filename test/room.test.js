const { assert } = require('chai');
const { ethers } = require('hardhat');

var BN = web3.utils.BN;
let roomFactory;
let poemFactory;
let poetGalleryUser;
const uri = "asd";
const uri2 = "uri2";
let room1;
let room2;
let poemID;
contract('RoomFactory', function (accounts) {

    before(async function () {
        [deployer, user1, user2, user3] = await ethers.getSigners();
        const RoomFactory = await ethers.getContractFactory("RoomFactory");
        const PoemFactory = await ethers.getContractFactory("PoemFactory");
        const PoetGalleryUser = await ethers.getContractFactory("PoetGalleryUser");
        const Room = await ethers.getContractFactory("Room",);

        poemFactory = await PoemFactory.deploy([]);
        await poemFactory.deployed();
        poetGalleryUser = await PoetGalleryUser.deploy([]);
        await poetGalleryUser.deployed();
        roomFactory = await RoomFactory.deploy(poetGalleryUser.address, poemFactory.address);
        await roomFactory.deployed();

    });
    describe('join', async function () {

        before(async function () {

            await (await poetGalleryUser.createUser(uri, 1)).wait();
            const events = await (await roomFactory.deployRoom(2, 2, 1, '')).wait();
            const newRoomAddr = events.events[0].args['roomAddress'];
            expect(events.events[0].event == "RoomCreated").to.be.true;

            const currentRoom = await poetGalleryUser.currentRoom(deployer.address);

            room1 = await ethers.getContractAt("Room", newRoomAddr);

            await (await poetGalleryUser.connect(user1).createUser(uri, 1)).wait();
            const events2 = await (await roomFactory.connect(user1).deployRoom(2, 2, 1, '')).wait();

            const newRoomAddr2 = events2.events[0].args['roomAddress'];
            expect(events2.events[0].event == "RoomCreated").to.be.true;

            const allRooms = await roomFactory.getAllRooms();

            const currentRoom2 = await poetGalleryUser.currentRoom(user1.address);
            room2 = await ethers.getContractAt("Room", newRoomAddr);

            expect(await roomFactory.isRoom(newRoomAddr2)).to.be.true;
            expect(allRooms[1]).to.eq(newRoomAddr2);
            expect(currentRoom2).to.eq(newRoomAddr2);

            expect(await roomFactory.isRoom(newRoomAddr)).to.be.true;
            expect(allRooms[0]).to.eq(newRoomAddr);
            expect(currentRoom).to.eq(newRoomAddr);

        });

        it("should fail if the user is not registered yet", async function () {
            await expect(room1.connect(user2).join()).to.be.revertedWith("Should create a profile first");
        });

        it("should fail if the user is already in another room", async function () {
            await expect(room1.connect(user1).join()).to.be.revertedWith("Already in an active room");
        });

        it("should join a room", async function () {
            await (await poetGalleryUser.connect(user2).createUser(uri, 1)).wait();
            const events = await (await room1.connect(user2).join()).wait();
            expect(events.events[0].event == 'ParticipantJoined').to.be.true;
            expect(await room1.isParticipant(user2.address)).to.be.true;
            expect(await room1.currentParticipantsAmount()).to.eq("2");
        });

        it("should fail when max amount of participants is reached", async function () {
            await expect(room1.connect(user1).join()).to.be.revertedWith("Already in an active room");
        });
    });
    describe('startPoem', async function () {
        it("should fail if the user is not participant", async function () {
            await expect(room1.connect(user3).startPoem(uri)).to.be.revertedWith("Only participants can continue poems");
        });

        it("should start a poem and set uri", async function () {
            await (await room1.connect(user2).startPoem(uri)).wait();

            poemID = await poemFactory.poemsPerRoom(room1.address);
            const poem = await poemFactory.poems(poemID);
            const authors = await poemFactory.getPoemAuthors(poemID);
            expect(authors.length).to.eq(1);
            expect(authors[0]).to.eq(user2.address);
            expect(poem.uri).to.eq(uri);
            expect(poem.archetype).to.eq(2);
            expect(poem.isFinished).to.be.false;
        });
    });


    describe('continuePoem', async function () {
        it("should fail if the user is not participant", async function () {
            await expect(room1.connect(user3).continuePoem(uri2)).to.be.revertedWith("Only participants can continue poems");
        });

        it("should continue the poem and set uri", async function () {
            await (await room1.connect(user2).continuePoem(uri2)).wait();
            const poem = await poemFactory.poems(poemID);
            const authors = await poemFactory.getPoemAuthors(poemID);
            expect(authors.length).to.eq(1);
            expect(authors[0]).to.eq(user2.address);
            expect(poem.uri).to.eq(uri2);
            expect(poem.archetype).to.eq(2);
            expect(poem.isFinished).to.be.false;
        });
    });
});
