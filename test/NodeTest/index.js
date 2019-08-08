const Web3 = require('web3');
const web3 = new Web3(new Web3.providers.WebsocketProvider('ws://localhost:7545'));
const Tx = require('ethereumjs-tx');
const NETWORK_ID = 5777;

web3.eth.net.isListening().then((s) => {
    console.log('We\'re still connected to the node');
}).catch((e) => {
    console.log('Lost connection to the node, reconnecting');
    web3.setProvider(new Web3.providers.HttpProvider('http://127.0.0.1:7545'));
})

const authenticationJSON = require('../../build/contracts/Authentication')
const authenticationABI = authenticationJSON.abi;
const authentication = new web3.eth.Contract(authenticationABI);

const votingJSON = require('../../build/contracts/Voting')
const votingABI = votingJSON.abi;
const voting = new web3.eth.Contract(votingABI);

console.log(web3.eth.accounts);
process.exit(0);
