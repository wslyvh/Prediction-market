var PredictionMarket = artifacts.require("./PredictionMarket.sol");

contract('PredictionMarket', function(accounts) {
  it("Add new question in the future", function() {
    return PredictionMarket.deployed().then(function(instance) {
      return instance.addQuestion.call("Will this pass?", 1, 1577880000);
    }).then(function(result) {
        assert.isTrue(result);
    });
  });
  it("Add new trusted source", function() {
    return PredictionMarket.deployed().then(function(instance) {
      return instance.addTrustedSource.call(0x1f025126500bd5ba91d8acd14996f27ce7472117);
    }).then(function(result) {
        assert.isTrue(result);
    });
  });
});