pragma solidity >=0.4.21 <0.6.0;
// We have to specify what version of compiler this code will compile with

contract Voting {

  // This function returns the total votes a candidate has received so far
  function totalVotesFor(bytes32 candidate) public returns (uint8,bool);

  // This function increments the vote count for the specified candidate. This
  // is equivalent to casting a vote
  function voteForCandidate(bytes32 candidate) public returns (bool,string memory);

  function getCandidateConstituency(bytes32 candidate) public returns (bool,bytes32);

  function test() public returns (bool,string memory);

  function validCandidate(bytes32 candidate) public returns (bool);

  function bytes32ToString(bytes32 x) public view returns (string memory);
}

contract Authentication {
  /* mapping field below is equivalent to an associative array or hash.
  The key of the mapping is candidate name stored as type bytes32 and value is
  an unsigned integer to store the vote count
  */

  Voting public voting;

  /* Solidity doesn't let you pass in an array of strings in the constructor (yet).
  We will use an array of bytes32 instead to store the list of candidates
  */

  bytes32[] public voterList;
  mapping (bytes32 => bytes32) public constituencyDict;

  /* This is the constructor which will be called once when you
  deploy the contract to the blockchain. When we deploy the contract,
  we will pass an array of candidates who will be contesting in the election
  */
  constructor(bytes32[] memory myList, bytes32[] memory constituencies, address addr) public {
    voterList = myList;
    for(uint i = 0; i < voterList.length; i++) {
      constituencyDict[voterList[i]] = constituencies[i];
    }
    voting = Voting(addr);
  }

  function isVoterExist(bytes32 voter) public view returns (bool,string memory) {
    for(uint i = 0; i < voterList.length; i++) {
      if (voterList[i] == voter) return (true, "success");
    }
    return (false, "Voter does not exist");
  }

  function checkConstituency(bytes32 candidate, bytes32 voter) public returns (bool, string memory) {
    bool candidateConstituencyBool;
    bytes32 candidateConstituency;
    (candidateConstituencyBool,candidateConstituency) = voting.getCandidateConstituency(candidate);
    if(candidateConstituencyBool == false) return (false, "Candidate does not exist.");
    bool isVoterExistBool;
    string memory isVoterExistString;
    (isVoterExistBool,isVoterExistString) = isVoterExist(voter);
    if(isVoterExistBool == false) return (false, "Voter does not exist.");
    if(candidateConstituency == constituencyDict[voter]) return (true,"undefined");
    return (false, "Candidate and Voter belong to different constituencies.");
  }

  // This function increments the vote count for the specified candidate. This
  // is equivalent to casting a vote
  function validVoter(bytes32 candidate, bytes32 voter) public returns (bool,string memory) {
    bool isVoterExistBool;
    bool checkConstituencyBool;
    string memory isVoterExistString;
    string memory checkConstituencyString;
    (isVoterExistBool,isVoterExistString) = isVoterExist(voter);
    (checkConstituencyBool, checkConstituencyString) = checkConstituency(candidate, voter);
    if(isVoterExistBool == false) return (false, isVoterExistString);
    if(checkConstituencyBool == false) return (false, checkConstituencyString);
    return (true, "success");
  }

  // This is the main function which checks whether a voter can vote for a candidate or not
  function isAuthentic(bytes32 candidate, bytes32 voter) public returns (bool, string memory) {
    bool validVoterBool;
    string memory validVoterString;
    (validVoterBool,validVoterString) = validVoter(candidate, voter);
    if(validVoterBool == false) return (false, validVoterString);
    return (true, "success");
  }

  // This function registers a voter
  function registerVoter(bytes32 voter, bytes32 constituency) public returns (bool, string memory) {
    bool isVoterExistBool;
    (isVoterExistBool,) = isVoterExist(voter);
    require(isVoterExistBool == false, "Voter already exists");
    voterList.push(voter);
    constituencyDict[voter] = constituency;
    return (true, "success");
  }
}
