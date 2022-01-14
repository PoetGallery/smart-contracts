const { assert } = require('chai');
const { ethers } = require('hardhat');

var BN = web3.utils.BN;


contract('Contract', function (accounts) {

    before(async function () {
        [deployer, ...accounts] = await ethers.getSigners();
        const Contract = await ethers.getContractFactory("Contract");

        const gigStatuses = await Contract.deploy();
        await gigStatuses.deployed();

    });
    describe('function', async function () {

        it("should pass", async function () {
            assert.isTrue(true)
        });

    });
});
