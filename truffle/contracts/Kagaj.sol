// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

contract Contract {
    struct Signer {
        address addr;
        string name; //name of signer
        string hash; //recreatable hash of signer
        uint256 dateSigned; //date of signing (unix timestamp)
    }

    enum Stage{ SIGNING, VERIFYING, VERIFIED }

    Stage public stage = Stage.SIGNING;
    uint256 public date; //creation date of contract (unix timestamp)
    string public name; //name of contract
    string public description; //description of contract
    string public content;
    string[] public termsNconditions;
    Signer[] public signers;
    uint128 totalSignerCount; //total number of signers
    Signer public authenticator; //final authenticator

    /* only authenticator can call constructor */
    constructor(
        uint256 _date, 
        string memory _name, 
        string memory _description, 
        string memory _content, 
        string[] memory _terms, 
        uint128 _totalSignerCount,
        string memory _authName,
        string memory _authHash
    ) {
        date = _date;
        name = _name;
        description = _description;
        content = _content;
        termsNconditions = _terms;
        totalSignerCount = _totalSignerCount;
        authenticator.addr = msg.sender;
        authenticator.name = _authName;
        authenticator.hash = _authHash;
    }

    modifier onlySigning {
        require(stage == Stage.SIGNING);
        _;
    }

    modifier onlyVerifying {
        require(stage == Stage.VERIFYING);
        _;
    }

    modifier onlyAuthenticator {
        require(msg.sender == authenticator.addr);
        _;
    }

    event signingComplete(string[] signers);

    function sign(string memory _name, string memory _hash, uint256 _date) public onlySigning{
        Signer memory newSigner;
        newSigner.addr = msg.sender;
        newSigner.name = _name;
        newSigner.hash = _hash;
        newSigner.dateSigned = _date;
        signers.push(newSigner);

        if (signers.length == totalSignerCount) {
            //emit event
            string[] memory _signers = new string[](totalSignerCount);
            uint i;
            for (i = 0; i < totalSignerCount; i++) {
                _signers[i] = signers[i].name;
            }
            stage = Stage.VERIFYING;
            emit signingComplete(_signers);
        }
    }
}