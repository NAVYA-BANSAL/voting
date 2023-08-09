// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract VotingSystem{
    struct vote{
        address voterAddress;
        bool choice;
    }

    struct voter{
       string voterName;
       bool voted;
    }
    uint private countVotes = 0;
    uint public finalVotes = 0;
    uint public totalVoters = 0;
    uint public totalVote = 0;

    address public adminAddress;
    string public adminName;
    string public proposal;

    mapping(uint => vote) private votes;              //no of votes
    mapping(address => voter) public voterRegister;   //it tells the address of people registered for voting

    enum Situation{registered , voting , declined}
    Situation public situation;

    modifier condition(bool _condition){
        require(_condition);
        _;
    }
    modifier onlyAdmin(){
        require(msg.sender == adminAddress);
        _;
    }
    modifier inSituation(Situation _situation){
        require(situation == _situation);
        _;
    }

    constructor(string memory _adminName , string memory _proposal) {
        adminAddress = msg.sender;
        adminName = _adminName;
        proposal = _proposal;
        situation = Situation.registered;
    }

    function voterRegistration(address _voterAddress , string memory _voterName) public inSituation(Situation.registered) onlyAdmin{
        voter memory v;
        v.voterName = _voterName;
        v.voted = false;
        voterRegister[_voterAddress] = v;
        totalVoters++;
    }

    function beginVoting() public inSituation(Situation.registered) onlyAdmin{
        situation = Situation.voting;
    }

    function doVote(bool _choice) public inSituation(Situation.voting) returns(bool voted){
        bool isPresent = false;
        if(bytes(voterRegister[msg.sender].voterName).length != 0 && voterRegister[msg.sender].voted == false){
            voterRegister[msg.sender].voted = true;
            vote memory v;
            v.voterAddress = msg.sender;
            v.choice = _choice;
            if(_choice){
                countVotes++;
            }
            votes[totalVote] = v;
            totalVote++;
            isPresent = true;
        }
        return isPresent;
    }

    function endVote() public inSituation(Situation.voting) onlyAdmin{
        situation = Situation.declined;
        finalVotes = countVotes;
    }
}