const { assert } = require('chai');
const { ethers } = require('hardhat');
const { constants } = require('@openzeppelin/test-helpers');
const { ZERO_ADDRESS } = constants;

var BN = web3.utils.BN;
let poetGalleryUserContract;
const uri = "asd";

contract('PoetGalleryUser', function (accounts) {

    before(async function () {
        [deployer, user1, user2, user3] = await ethers.getSigners();
        const PoetGalleryUser = await ethers.getContractFactory("PoetGalleryUser");

        poetGalleryUserContract = await PoetGalleryUser.deploy();
        await poetGalleryUserContract.deployed();

    });
    describe('createUser', async function () {

        it("should fail if uri is empty", async function () {
            await expect(poetGalleryUserContract.createUser("", 1)).to.be.revertedWith("Membership metadata uri can't be empty");
        });

        it("should create user", async function () {
            const events = await (await poetGalleryUserContract.createUser(uri, 1)).wait();
            const eventEmitted = events.events[0].event == "UserCreated";
            expect(eventEmitted).to.be.true;

            const memberToUri = await poetGalleryUserContract.memberToUri(deployer.address);
            const memberToRole = await poetGalleryUserContract.memberToRole(deployer.address);
            const currentRoom = await poetGalleryUserContract.currentRoom(deployer.address);

            expect(memberToUri).to.eq(uri);
            expect(memberToRole.toString()).to.eq("1");
            expect(currentRoom).to.eq(ZERO_ADDRESS)

        });

        it("should fail if the user is already created", async function () {
            await expect(poetGalleryUserContract.createUser(uri, 1)).to.be.revertedWith("Membership already created");
        });

    });
});
