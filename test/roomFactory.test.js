const { ethers } = require('hardhat');

var BN = web3.utils.BN;
let roomFactory;
let poemFactory;
let poetGalleryUser;
const uri = "asd";

contract('RoomFactory', function (accounts) {

    before(async function () {
        [deployer, user1, user2, user3] = await ethers.getSigners();
        const RoomFactory = await ethers.getContractFactory("RoomFactory");
        const PoemFactory = await ethers.getContractFactory("PoemFactory");
        const PoetGalleryUser = await ethers.getContractFactory("PoetGalleryUser");

        poemFactory = await PoemFactory.deploy([]);
        await poemFactory.deployed();
        poetGalleryUser = await PoetGalleryUser.deploy([]);
        await poetGalleryUser.deployed();
        roomFactory = await RoomFactory.deploy(poetGalleryUser.address, poemFactory.address);
        await roomFactory.deployed();

    });
    describe('deployRoom', async function () {

        it("should fail if the user is not registered yet", async function () {
            await expect(roomFactory.deployRoom(2, 10)).to.be.revertedWith("User has no account");
        });

        it("should deploy a room", async function () {
            await (await poetGalleryUser.createUser(uri, 1)).wait();
            const events = await (await roomFactory.deployRoom(2, 10)).wait();
            const eventEmitted = events.events[0].event == "RoomCreated";
            const newRoomAddr = events.events[0].args['roomAddress'];
            expect(eventEmitted).to.be.true;

            const allRooms = await roomFactory.getAllRooms();
            const isRoom = await roomFactory.isRoom(newRoomAddr);

            expect(isRoom).to.be.true;
            expect(allRooms[0]).to.eq(newRoomAddr);
        });
    });
});
