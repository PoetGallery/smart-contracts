/* eslint no-use-before-define: "warn" */
const chalk = require("chalk");
const { ethers } = require("hardhat");
const { deploy } = require("./utils")

const main = async () => {
    const deployerWallet = ethers.provider.getSigner();
    const deployerWalletAddress = await deployerWallet.getAddress();

    const poemFactoryAddress = '0x78d7761a191a4ffb0f55b54ac3a2880e498edd4d';
    const poetGalleryUserAddress = '0x74E582594b58B70A650291769D6F91f6d26fFBc2';
    const RoomFactory = await deploy("RoomFactory", [poetGalleryUserAddress, poemFactoryAddress]);
    await RoomFactory.deployed();

    console.log(
        " 💾  Artifacts (address, abi, and args) saved to: ",
        chalk.blue("packages/hardhat/artifacts/"),
        "\n\n"
    );
};

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
