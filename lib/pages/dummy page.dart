import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rive/rive.dart';
import 'package:smart_kagaj/commonWidgets/animated_button.dart';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr/qr.dart';

class dummy extends StatelessWidget {
  const dummy({super.key});

  @override
  Widget build(BuildContext context) {
    return Placeholder(
      child: RiveAnimatedBtn(
          label: "label", iconData: Icon(Icons.abc_outlined), onTap: () {}),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Generator'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _textController,
            ),
            SizedBox(height: 10),
            QrImageView(
              backgroundColor: Colors.white,
              data: _textController.text,
            ),
          ],
        ),
      ),
    );
  }
}

// class MyWidget extends StatefulWidget {
//   const MyWidget({super.key});

//   @override
//   State<MyWidget> createState() => _MyWidgetState();
// }

// class _MyWidgetState extends State<MyWidget> {
//   final TextEditingController _textController = TextEditingController();
//   String _scannedCode = '';

//   Future<void> scanQRCode() async {
//     final scanResult = await BarcodeScanner.scan();

//     setState(() {
//       _scannedCode = scanResult.code;
//     });
//   }

//   Future<void> generateQRCode() async {
//     final qrCode = QrCodeView(data: _textController.text);

//     setState(() {
//       _scannedCode = qrCode.toString();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('QR Code Generator and Scanner'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: _textController,
//             ),
//             SizedBox(height: 10),
//             QrImageView(
//               data: _scannedCode,
//             ),
//             SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ElevatedButton(
//                   onPressed: scanQRCode,
//                   child: Text('Scan QR Code'),
//                 ),
//                 SizedBox(width: 10),
//                 ElevatedButton(
//                   onPressed: generateQRCode,
//                   child: Text('Generate QR Code'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class ScanQRCode extends StatefulWidget {
//   const ScanQRCode({super.key});

//   @override
//   State<ScanQRCode> createState() => _ScanQRCodeState();
// }

// class _ScanQRCodeState extends State<ScanQRCode> {
//   String qrResult = 'Scanned Data will Appear here';
//   Future<void> scanQR() async {
//     try {
//       final qrCode = await FlutterBarcodeScanner.scanBarcode(
//           '#ff6666', 'Cancel', true, ScanMode.QR);
//       if (!mounted) return;
//       setState(() {
//         this.qrResult = qrCode.toString();
//       });
//     } on PlatformException {
//       qrResult = 'Fail to read QR';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('QR Code Scanner'),
//       ),
//       body: Center(
//         Child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SizedBox(
//               height: 30,
//             ),
//             Text(
//               '$qrResult',
//               style: TextStyle(color: Colors.black),
//             ),
//             SizedBox(
//               height: 30,
//             ),
//             ElevatedButton(onPressed: scanQr, child: Text('Scan Code'))
//           ],
//         ),
//       ),
//     );
//   }
// }
