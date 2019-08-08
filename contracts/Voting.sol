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
    if (validCandidateBool == false) return (0,false);
    return (votesReceived[candidate],true);
  }

  // This function increments the vote count for the specified candidate. This
  // is equivalent to casting a vote
  function voteForCandidate(bytes32 candidate) public returns (bool,string memory){

    bool validCandidateBool;
    string memory validCandidateString;

    (validCandidateBool,validCandidateString) = validCandidate(candidate);

    if (validCandidateBool == false){
      return (false,validCandidateString);
    }
    votesReceived[candidate] += 1;
    return (true,"success");
  }

  function getCandidateConstituency(bytes32 candidate) public view returns (bool,bytes32) {

    bytes32 my_null;
    bool validCandidateBool;
    string memory validCandidateString;
     (validCandidateBool,validCandidateString) = validCandidate(candidate);
    if (validCandidateBool == false)
    return (false, my_null);
    return (true,constituencyDict[candidate]);
  }

  function test () public pure returns (bool,string memory){
    return (true,"success");
  }

  function validCandidate(bytes32 candidate) public view returns (bool,string memory) {
    for(uint i = 0; i < candidateList.length; i++) {
      if (candidateList[i] == candidate) {
        return (true,"success");
      }
    }
    return (false,"candidate doesnot exist");
  }

  function bytes32ToString(bytes32 x) public pure returns (string memory) {
    bytes memory bytesString = new bytes(32);
    uint charCount = 0;
    uint j;
    for (j = 0; j < 32; j++) {
        byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
        if (char != 0) {
            bytesString[charCount] = char;
            charCount++;
        }
    }
    bytes memory bytesStringTrimmed = new bytes(charCount);
    for (j = 0; j < charCount; j++) {
        bytesStringTrimmed[j] = bytesString[j];
    }
    return string(bytesStringTrimmed);
  }
}