import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_kagaj/utils/constants.dart';
import 'package:web3dart/web3dart.dart';

Future<DeployedContract> loadContract() async {
  final abi = await rootBundle.loadString("assets/abi.json");
  String contractAddress = ContractAddress;
  final contract = DeployedContract(ContractAbi.fromJson(abi, "Kagaj"),
      EthereumAddress.fromHex(contractAddress));
  return contract;
}

Future<String> callFunction(String functionName, List<dynamic> args,
    Web3Client ethClient, String privateKey) async {
  try {
    EthPrivateKey credentials = EthPrivateKey.fromHex(privateKey);
    DeployedContract contract = await loadContract();
    final ethFunction = contract.function(functionName);
    final result = await ethClient.sendTransaction(
        credentials,
        Transaction.callContract(
          contract: contract,
          function: ethFunction,
          parameters: args,
        ),
        chainId: null,
        fetchChainIdFromNetworkId: true);
    return result;
  } catch (e) {
    print("Error sending transaction: $e");
    return "Error: $e";
  }
}

Future<String> createContract(
    String contractHash,
    int date,
    String name,
    String description,
    String content,
    String terms,
    int totalSigners,
    String authName,
    String authHash,
    Web3Client ethClient) async {
  try {
    BigInt dateBigInt = BigInt.from(date);
    BigInt totalSignersBigInt = BigInt.from(totalSigners);
    var response = await callFunction(
        "createContract",
        [
          contractHash,
          dateBigInt,
          name,
          description,
          content,
          terms,
          totalSignersBigInt,
          authName,
          authHash
        ],
        ethClient,
        user_private_key_);
    print("Contract Created Successfully");
    return response;
  } catch (e) {
    print("Error creating contract: $e");
    return "Error: $e";
  }
}

Future<String> getContract(String contractHash, Web3Client ethClient) async {
  var response = await callFunction(
      "getContract",
      [
        contractHash,
      ],
      ethClient,
      authenticator_private_key);
  print("Contract Got Successfully");
  return response;
}

Future<String> sign(String contractHash, String name, String hash, int date,
    Web3Client ethClient) async {
  var response = await callFunction(
      "sign",
      [
        contractHash,
        name,
        hash,
        date,
      ],
      ethClient,
      authenticator_private_key);
  print("Contract Got Successfully");
  return response;
}


// Future<void> getContractStage(String contractHash) async {
//     try {
//       String abi = await rootBundle.loadString("assets/abi.json");
//       final contract =
//           DeployedContract(ContractAbi.fromJson(abi, "Kagaj"), contractAddress);

//       // Use the correct function name "stage" to get the contract stage.
//       final ethFunction = contract.function("getContractStage");

//       try {
//         final result = await client.call(
//             contract: contract,
//             function: ethFunction,
//             params: [BigInt.from(0), contractHash]);
//         final stageValue = result[0];

//         // Convert the result to a human-readable stage
//         String stage;
//         switch (stageValue) {
//           case 0:
//             stage = "SIGNING";
//             break;
//           case 1:
//             stage = "VERIFIED";
//             break;
//           default:
//             stage = "UNKNOWN";
//             break;
//         }
//         print("Contract Stage : $stage");
//       } catch (e) {
//         print("Error fetching contract stage: $e");
//       }
//     } catch (e) {
//       print("Erroreeees fetching contract stage: $e");
//     }
//   }
