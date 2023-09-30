// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

contract Kagaj {
    enum Stage {
        SIGNING,
        VERIFIED
    }

    struct Signer {
        string name; //name of signer
        string hash; //recreatable hash of signer
        uint256 dateSigned; //date of signing (unix timestamp)
    }

    struct Contract {
        Stage stage;
        uint256 date; //creation date of contract (unix timestamp)
        string name; //name of contract
        string description; //description of contract
        string content;
        string termsNconditions;
        Signer[] signers;
        uint128 totalSignerCount; //total number of signers
        Signer authenticator; //final authenticator
    }

    address public authenticator;
    mapping(string => Contract) contracts;
    string[] public contract_hash;

    constructor() {
        authenticator = msg.sender; //msg.sender will be  the person who's currently connecting with the contract
    }

    modifier onlyAuthenticator() {
        require(
            msg.sender == authenticator,
            "Only authenticator is allowed to call this function."
        );
        _;
    }

    modifier onlyVerified(string memory contractHash) {
        // It ensures that the contract with the given hash is in the Verified state
        require(
            contracts[contractHash].stage == Stage.VERIFIED,
            "Contract is not verified yet."
        );
        _;
    }

    modifier onlySigning(string memory contractHash) {
        require(
            contracts[contractHash].stage == Stage.SIGNING,
            "Contract is not in signing stage."
        );
        _;
    }

    modifier onlyAvailable(string memory contractHash) {
        uint128 i;
        bool isFound = false;
        for (i = 0; i < contract_hash.length; i++) {
            bytes memory storageRef = bytes(contract_hash[i]);
            bytes memory memVar = bytes(contractHash);
            if (keccak256(storageRef) == keccak256(memVar)) {
                isFound = true;
                break;
            }
        }
        require(isFound, "Contract is not available.");
        _;
    }

    function createContract(
        string memory contractHash,
        uint256 _date,
        string memory _name,
        string memory _description,
        string memory _content,
        string memory _terms,
        uint128 _totalSignerCount,
        string memory _authName,
        string memory _authHash
    ) public onlyAuthenticator {
        contracts[contractHash].stage = Stage.SIGNING;
        contracts[contractHash].authenticator.name = _authName;
        contracts[contractHash].authenticator.hash = _authHash;
        contracts[contractHash].authenticator.dateSigned = _date;
        contracts[contractHash].date = _date;
        contracts[contractHash].name = _name;
        contracts[contractHash].description = _description;
        contracts[contractHash].content = _content;
        contracts[contractHash].termsNconditions = _terms;
        contracts[contractHash].totalSignerCount = _totalSignerCount;
        contract_hash.push(contractHash);
    }

    // function getContract(string memory contractHash) public onlyVerified(contractHash) view returns(
    //     uint256,
    //     string memory,
    //     string memory,
    //     string memory,
    //     string memory,
    //     Signer[] memory,
    //     string memory
    // ) {
    //     uint256 _date = contracts[contractHash].date;
    //     string memory _name = contracts[contractHash].name;
    //     string memory _description = contracts[contractHash].description;
    //     string memory _content = contracts[contractHash].content;
    //     string memory _termsNconditions = contracts[contractHash].termsNconditions;
    //     Signer[] memory _signers = contracts[contractHash].signers;
    //     string memory _authName = contracts[contractHash].authenticator.name;

    //     return (
    //         _date,
    //         _name,
    //         _description,
    //         _content,
    //         _termsNconditions,
    //         _signers,
    //         _authName
    //     );
    // }

    function getContract(
        string memory contractHash
    )
        public
        view
        onlyVerified(contractHash)
        onlyAvailable(contractHash)
        returns (Contract memory)
    {
        return contracts[contractHash];
    }

    event signingComplete(
        string contractHash,
        Signer[] signers,
        Signer authenticator
    );

    function getContractStage(
        string memory contractHash
    ) public view onlyAvailable(contractHash) returns (Stage) {
        return contracts[contractHash].stage;
    }

    function sign(
        string memory contractHash,
        string memory _name,
        string memory _hash,
        uint256 _date
    ) public onlySigning(contractHash) onlyAvailable(contractHash) {
        Signer memory signer;
        signer.name = _name;
        signer.hash = _hash;
        signer.dateSigned = _date;
        contracts[contractHash].signers.push(signer);

        if (
            contracts[contractHash].signers.length ==
            contracts[contractHash].totalSignerCount
        ) {
            //emit event
            Signer[] memory _signers = contracts[contractHash].signers;
            Signer memory _authenticator = contracts[contractHash]
                .authenticator;
            contracts[contractHash].stage = Stage.VERIFIED;
            emit signingComplete(contractHash, _signers, _authenticator);
        }
    }
}
