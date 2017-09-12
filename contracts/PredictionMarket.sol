pragma solidity ^0.4.15;

import "./Owned.sol";
import "./Terminable.sol";
import "./SafeMath.sol";

contract PredictionMarket is Terminable {
    
    struct TrustedSource {
        address trustedSourceAddress;
        bool active;
        uint index;
    }
    
    struct Question { 
        string statement;
        uint stake;
        uint deadline;
        bool hasOutcome;
        bool outcome;
        uint balance;
        uint betsPlaced;
        uint positives;
        uint negatives;
        mapping(address => Bet) bets;
        uint index;
    }
    
    struct Bet { 
        bool prediction;
        bool isClaimed;
    }
    
    mapping(address => TrustedSource) public trustedSources;
    mapping(uint => Question) public questions;
    
    address[] private trustedSourceIndex;
    uint[] private questionIndex;
    
    event LogAddTrustedSource(address source);
    event LogRemoveTrustedSource(address source);
    event LogAddQuestion(uint questionId, string statement, uint deadline);
    event LogAnswerQuestion(uint questionId, string statement, bool outcome);
    event LogAddPrediction(uint questionId, address better, uint amount, bool prediction);
    event LogClaim(uint questionId, address better, uint amount);
    
    modifier onlyTrustedSource {
        require(trustedSources[msg.sender].active);
        _;
    }
    
    function PredictionMarket() { 
        
    }

    function addTrustedSource(address _source) public onlyOwner returns (bool success) { 
        require(_source > address(0));
        
        if (trustedSources[_source].index > 0) {
            trustedSources[_source].active = true;
            return true;
        }
        
        trustedSources[_source].trustedSourceAddress = _source;
        trustedSources[_source].active = true;
        trustedSources[_source].index = trustedSourceIndex.push(_source)-1;
        
        LogAddTrustedSource(_source);
        return true;
    }

    function removeTrustedSource(address _source) public onlyOwner returns (bool success) { 
        require(_source > address(0));
        require(trustedSources[_source].index > 0);
        
        trustedSources[_source].active = false;
        
        LogRemoveTrustedSource(_source);
        return true;
    }
    
    function addQuestion(string _statement, uint _stake, uint _deadline) public onlyOwner returns (bool success) { 
        require(bytes(_statement).length > 0);
        require(_deadline > block.timestamp);
        
        var index = questionIndex.length;
        questions[index].statement = _statement;
        questions[index].stake = _stake;
        questions[index].deadline = _deadline;
        questions[index].index = index;
        questionIndex.push(index);
        
        LogAddQuestion(index, _statement, _deadline);
        return true;
    }
    
    function answerQuestion(uint _questionId, bool _result) public onlyTrustedSource returns (bool success) { 
        require(questions[_questionId].index == _questionId);
        require(questions[_questionId].deadline > block.timestamp);
        
        questions[_questionId].outcome = _result;
        questions[_questionId].hasOutcome = true;
        
        LogAnswerQuestion(_questionId, questions[_questionId].statement, _result);
        return true;
    }

    function addPrediction(uint _questionId, bool _prediction) public payable returns (bool success) { 
        require(questions[_questionId].index == _questionId);
        require(questions[_questionId].deadline < block.timestamp);
        require(questions[_questionId].hasOutcome == false);
        require(questions[_questionId].stake == msg.value);
        require(msg.value > 0);
        
        questions[_questionId].bets[msg.sender] = Bet(_prediction, false);
        questions[_questionId].balance += msg.value;
        questions[_questionId].betsPlaced++;
        
        if (_prediction) {
            questions[_questionId].positives++;
        }
        else { 
            questions[_questionId].negatives++;
        }
        
        LogAddPrediction(_questionId, msg.sender, msg.value, _prediction);
        return true;
    }
    
    function claim(uint _questionId) public returns (bool success) { 
        require(questions[_questionId].index == _questionId);
        require(questions[_questionId].deadline > block.timestamp);
        require(questions[_questionId].hasOutcome == true);
        require(questions[_questionId].bets[msg.sender].isClaimed == false);
        require(questions[_questionId].outcome == questions[_questionId].bets[msg.sender].prediction);
        
        uint winners = 0;
        if (questions[_questionId].outcome) {
            winners = questions[_questionId].positives;
        }
        else { 
            winners = questions[_questionId].negatives;
        }
        
        var payout = SafeMath.safeDiv(questions[_questionId].balance, winners);
        msg.sender.transfer(payout);
        questions[_questionId].bets[msg.sender].isClaimed = true;
        
        LogClaim(_questionId, msg.sender, payout);
        return true;
    }
}