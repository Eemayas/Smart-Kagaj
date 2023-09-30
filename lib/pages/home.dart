import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:smart_kagaj/services/functions.dart';
import 'package:smart_kagaj/utils/constants.dart';
import 'package:web3dart/web3dart.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Client? httpClient;
  Web3Client? ethClient;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    httpClient = Client();
    ethClient = Web3Client(infura_url, httpClient!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Kagaj")),
      body: Container(
        padding: EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                    onPressed: () {
                      createContract(
                          ContractAddress,
                          DateTime.now().millisecondsSinceEpoch,
                          "Sample Contract",
                          "This is a Simple Contract",
                          "Sample contract content",
                          "Sample terms and conditions",
                          5,
                          "Authorized Entity",
                          "0x0077d095da19E8a3672c93FEf5c61681c7eEc813",
                          ethClient!);
                    },
                    child: Text("Start Contract")))
          ],
        ),
      ),
    );
  }
}
