pragma solidity >=0.4.21 <0.6.0;
// We have to specify what version of compiler this code will compile with

contract Voting {
  /* mapping field below is equivalent to an associative array or hash.
  The key of the mapping is candidate name stored as type bytes32 and value is
  an unsigned integer to store the vote count
  */

  mapping (bytes32 => uint8) public votesReceived;

  /* Solidity doesn't let you pass in an array of strings in the constructor (yet).
  We will use an array of bytes32 instead to store the list of candidates
  */

  bytes32[] public candidateList;
  mapping (bytes32 => bytes32) public constituencyDict;
  mapping (bytes32 => bool) public voterDict;

  /* This is the constructor which will be called once when you
  deploy the contract to the blockchain. When we deploy the contract,
  we will pass an array of candidates who will be contesting in the election
  */
  constructor(bytes32[] memory candidateNames, bytes32[] memory constituencies) public {
    candidateList = candidateNames;
    for(uint i = 0; i < candidateNames.length; i++) {
      constituencyDict[candidateNames[i]] = constituencies[i];
    }
  }

  // This function returns the total votes a candidate has received so far
  function totalVotesFor(bytes32 candidate) public view returns (uint8,bool) {
    bool validCandidateBool;
    string memory validCandidateString;
    (validCandidateBool,validCandidateString) = validCandidate(candidate);
    if (validCandidateBool == false) return (0, false);
    return (votesReceived[candidate],true);
  }

  /* This function increments the vote count for the specified candidate. This
  is equivalent to casting a vote
  */
  function voteForCandidate(bytes32 candidate, bytes32 voter) public returns (bool,string memory) {
    bool validCandidateBool;
    string memory validCandidateString;
    (validCandidateBool,validCandidateString) = validCandidate(candidate);
    require(validCandidateBool == true, validCandidateString);
    require(voterDict[voter] == false, "You have already voted");
    voterDict[voter] = true;
    votesReceived[candidate] += 1;
    return (true,"success");
  }

  function getCandidateConstituency(bytes32 candidate) public view returns (bool,bytes32) {
    bytes32 my_null;
    bool validCandidateBool;
    string memory validCandidateString;
    (validCandidateBool,validCandidateString) = validCandidate(candidate);
    if (validCandidateBool == false) return (false, my_null);
    return (true,constituencyDict[candidate]);
  }

  function validCandidate(bytes32 candidate) public view returns (bool,string memory) {
    for(uint i = 0; i < candidateList.length; i++) {
      if (candidateList[i] == candidate) return (true, "success");
    }
    return (false, "Candidate does not exist");
  }

  // This function registers a candidate
  function registerCandidate(bytes32 candidate, bytes32 constituency) public returns (bool,string memory) {
    bool validCandidateBool;
    (validCandidateBool,) = validCandidate(candidate);
    require(validCandidateBool == false, "Candidate already exists");
    candidateList.push(candidate);
    constituencyDict[candidate] = constituency;
    return (true, "success");
  }
}