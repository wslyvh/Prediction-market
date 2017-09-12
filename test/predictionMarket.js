const Web3 = require('web3');
const web3 = new Web3();

const TestRPC = require('ethereumjs-testrpc');
web3.setProvider(TestRPC.provider());

const Promise = require('bluebird');
Promise.promisifyAll(web3.eth, { suffix: "Promise" });
Promise.promisifyAll(web3.version, { suffix: "Promise" });

const assert = require('assert-plus');

const truffleContract = require("truffle-contract");

const Owned = truffleContract(require(__dirname + "/../build/contracts/Owned.json"));
Owned.setProvider(web3.currentProvider);
const Terminable = truffleContract(require(__dirname + "/../build/contracts/Terminable.json"));
Terminable.setProvider(web3.currentProvider);
const SafeMath = truffleContract(require(__dirname + "/../build/contracts/SafeMath.json"));
SafeMath.setProvider(web3.currentProvider);
const PredictionMarket = truffleContract(require(__dirname + "/../build/contracts/PredictionMarket.json"));
PredictionMarket.setProvider(web3.currentProvider);

describe("PredictionMarket", function() {
    var accounts, networkId, owned, terminable, safeMath, predictionMarket;

    before("get accounts", function() {
        return web3.eth.getAccountsPromise()
            .then(_accounts => accounts = _accounts)
            .then(() => web3.version.getNetworkPromise())
            .then(_networkId => {
                networkId = _networkId;
                Owned.setNetwork(networkId);
                Terminable.setNetwork(networkId);
                SafeMath.setNetwork(networkId);
                PredictionMarket.setNetwork(networkId);
            });
    });
});