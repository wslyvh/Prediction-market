pragma solidity ^0.4.15;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";

import "../contracts/Owned.sol";
import "../contracts/Terminable.sol";
import "../contracts/SafeMath.sol";
import "../contracts/PredictionMarket.sol";

contract TestPredictionMarket {

  function testAddNewQuestion() {
    PredictionMarket market = PredictionMarket(DeployedAddresses.PredictionMarket());
    
    var expected = true;
    var result = market.addQuestion("Will this pass?", 1, 1577880000);

    Assert.equal(result, expected, "Question is not added.");
  }
}