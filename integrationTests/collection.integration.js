const { assert } = require('chai')
const fs = require("fs");

var ethers = require('ethers')

var collectionABI = require('../artifacts/contracts/Collection.sol/Collection.json').abi;
const collectionsAddress= '0x09aa433801a8809b09fe2a8fb67c2279d4579eb2';

function mnemonic() {
    try {
        return fs.readFileSync("./mnemonic.txt").toString().trim();
    } catch (e) {
        console.log(e);
    }
    return "";
}


const provider = new ethers.providers.JsonRpcProvider(
    'https://rpc-mumbai.maticvigil.com/v1/9ca44fbe543c19857d4e47669aae2a9774e11c66'
)
// Wallet connected to a provider
const senderWalletMnemonic = ethers.Wallet.fromMnemonic(
    mnemonic(),
    "m/44'/60'/0'/0/0"
);

let signer = senderWalletMnemonic.connect(provider)

const contract = new ethers.Contract(
    collectionsAddress,
    collectionABI,
    signer,
)


async function mint(url) {
    const createTx = await contract.mint(
        url
    )
    console.log(createTx);
    const res = await createTx.wait()
    console.log(res);
}


async function mintAndTransfer(url) {
    const createTx = await contract.mintAndTransfer(
        url
    )
    console.log(createTx);
    const res = await createTx.wait()
    console.log(res);
}

async function test() {
    // mint('https://ipfs.io/ipfs/bafyreiew7lbbbxquezfdbqkjl3cmrilrqijdasv3ystjjccsp4rhgwcpq4/metadata.json')
    mintAndTransfer('https://ipfs.io/ipfs/bafyreiew7lbbbxquezfdbqkjl3cmrilrqijdasv3ystjjccsp4rhgwcpq4/metadata.json')
}

test()