pragma solidity ^0.8.0;

contract Reputation {
    struct Attestation {
        address from;
        address to;
        string skill;
        string details;
        uint256 timestamp;
        string[] comments;
        address[] endorsements;
    }

    mapping(address => Attestation[]) public attestations;
    mapping(address => uint) public reputationScores;

    event AttestationCreated(address indexed from, address indexed to, string skill, string details);
    event CommentAdded(address indexed from, address indexed to, uint256 attestationIndex, string comment);
    event EndorsementAdded(address indexed from, address indexed to, uint256 attestationIndex);

    function attest(address to, string memory skill, string memory details) public {
        Attestation memory newAttestation = Attestation({
            from: msg.sender,
            to: to,
            skill: skill,
            details: details,
            timestamp: block.timestamp,
            comments: new string ,
            endorsements: new address 
        });
        attestations[to].push(newAttestation);
        reputationScores[to]++;
        emit AttestationCreated(msg.sender, to, skill, details);
    }

    function addComment(address to, uint256 index, string memory comment) public {
        require(index < attestations[to].length, "Invalid attestation index");
        attestations[to][index].comments.push(comment);
        emit CommentAdded(msg.sender, to, index, comment);
    }

    function endorse(address to, uint256 index) public {
        require(index < attestations[to].length, "Invalid attestation index");
        attestations[to][index].endorsements.push(msg.sender);
        emit EndorsementAdded(msg.sender, to, index);
    }

    function getAttestations(address user) public view returns (Attestation[] memory) {
        return attestations[user];
    }

    function getProfile(address user) public view returns (uint reputationScore, Attestation[] memory) {
        return (reputationScores[user], attestations[user]);
    }
}
