// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MemoryGames {
    address public owner;
    uint public factCount;
    
    struct Fact {
        uint id;
        string question;
        string answer;
        bool isActive;
    }

    mapping(uint => Fact) public facts;
    mapping(address => uint) public playerScores;

    event FactAdded(uint factId, string question, string answer);
    event GameCompleted(address player, uint score);
    event FactRevealed(address player, string answer);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can add facts.");
        _;
    }

    modifier isActiveFact(uint factId) {
        require(facts[factId].isActive, "Fact is not active.");
        _;
    }

    constructor() {
        owner = msg.sender;
        factCount = 0;
    }

    function addFact(string memory question, string memory answer) public onlyOwner {
        factCount++;
        facts[factCount] = Fact(factCount, question, answer, true);
        emit FactAdded(factCount, question, answer);
    }

    function revealFact(uint factId) public isActiveFact(factId) {
        string memory factAnswer = facts[factId].answer;
        emit FactRevealed(msg.sender, factAnswer);
    }

    function completeGame(uint[] memory factIds) public {
        uint score = 0;
        for (uint i = 0; i < factIds.length; i++) {
            require(facts[factIds[i]].isActive, "Fact is not active.");
            score += 1;  // Earn 1 point per fact answered
        }
        playerScores[msg.sender] += score;
        emit GameCompleted(msg.sender, score);
    }

    function deactivateFact(uint factId) public onlyOwner {
        facts[factId].isActive = false;
    }

    function getFact(uint factId) public view returns (string memory question, string memory answer, bool isActive) {
        Fact memory fact = facts[factId];
        return (fact.question, fact.answer, fact.isActive);
    }

    function getPlayerScore(address player) public view returns (uint) {
        return playerScores[player];
    }
}
