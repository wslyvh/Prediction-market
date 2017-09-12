var Owned = artifacts.require("./Owned.sol");
var Terminable = artifacts.require("./Terminable.sol");
var SafeMath = artifacts.require("./SafeMath.sol");
var PredictionMarket = artifacts.require("./PredictionMarket.sol");

module.exports = function(deployer) {
  deployer.deploy(Owned);
  deployer.link(Owned, [Terminable, PredictionMarket]);
  deployer.deploy(Terminable);
  deployer.link(Terminable, PredictionMarket);
  deployer.deploy(SafeMath);
  deployer.link(SafeMath, PredictionMarket);
  deployer.deploy(PredictionMarket);
};
