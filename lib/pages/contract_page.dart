// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, avoid_print, unnecessary_null_comparison, unused_element, depend_on_referenced_packages
import 'dart:io';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:smart_kagaj/commonWidgets/create_pdf.dart';
import 'package:smart_kagaj/commonWidgets/custom_snackbar.dart';
import 'package:smart_kagaj/commonWidgets/hashgenerator.dart';
import 'package:smart_kagaj/commonWidgets/smooth_navigation.dart';
import 'package:smart_kagaj/database/contact.dart';
import 'package:smart_kagaj/database/firebase.dart';
import 'package:smart_kagaj/pages/check_MPIN.dart';
import '../commonWidgets/animated_button.dart';
import '../commonWidgets/custom_button.dart';
import '../constant/fonts.dart';
import 'package:pdf/widgets.dart' as pw;

class ContractPage extends StatefulWidget {
  const ContractPage({super.key, required this.documentName});
  static String id = 'DocumentPage_id';
  final String documentName;

  @override
  State<ContractPage> createState() => _DocumentPageState();
}

class _DocumentPageState extends State<ContractPage> {
  User user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
          onPressed: () async {},
          icon: Icon(Icons.file_copy_outlined),
        ),
      ]),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.all(20.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            FutureBuilder<Map<String, dynamic>?>(
              future: ContractDB.fetchContractFromFirestore(
                  contractAddress: widget.documentName,
                  context: context), // Replace with your data fetching function
              builder: (BuildContext context,
                  AsyncSnapshot<Map<String, dynamic>?> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  EasyLoading.show(
                    dismissOnTap: true,
                    status: 'Processing...',
                    maskType: EasyLoadingMaskType.black,
                  );
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  EasyLoading.dismiss();
                  print(snapshot);
                  final documentNames = snapshot.data ?? [];
                  print(documentNames);
                  return Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: PdfPreview(
                            pdfFileName: "Prashant",
                            pageFormats: const {
                              'A4': PdfPageFormat.a4,
                            },
                            useActions: false,
                            canChangeOrientation: false,
                            canChangePageFormat: false,
                            // actions: [Text("data")],
                            allowPrinting: false,
                            allowSharing: false,
                            loadingWidget: const CircularProgressIndicator(),
                            build: (format) => createPdf(
                                  contractCreatedDate: ContractDB.date!,
                                  contractDescription:
                                      ContractDB.contractDescription!,
                                  partyOneDate: ".............",
                                  partyOneHash: ".............",
                                  partyOneName: ".............",
                                  partyTwoDate: "..............",
                                  partyTwoHash: ".............",
                                  partyTwoName: "............",
                                  AuthenticatorDate: "..............",
                                  AuthenticatorHash: ".............",
                                  AuthenticatorName: "............",
                                  termsAndConditions: ContractDB
                                      .contractTermsAndCondition!
                                      .split('|'),
                                  format: format,
                                  contractTitle: ContractDB.contractName!,
                                )
                            //d generatePdfContent()
                            ),
                      ),
                    ],
                  );
                }
              },
            ),
            RiveAnimatedBtn(
              label: "Sign Contract",
              onTap: () async {
                EasyLoading.show(
                  status: 'Processing...',
                  maskType: EasyLoadingMaskType.black,
                );
                Navigator.of(context).push(SmoothSlidePageRoute(
                    page: CheckMPIN(
                        isContract: true,
                        contractAddress: widget.documentName,
                        nextPage: ContractPage(
                          documentName: widget.documentName,
                        ))));
                // if (ContractDB.Signers?[0]["hash"] == "........") {
                //   ContractDB.editContractInFirestore(
                //       context: context,
                //       contractAddress: widget.documentName,
                //       updatedContractData: {
                //         "date": ContractDB.date,
                //         "contractName": ContractDB.contractName,
                //         "contractDescription": ContractDB.contractDescription,
                //         "contractContent": ContractDB.contractContent,
                //         "contractTermsAndCondition":
                //             ContractDB.contractTermsAndCondition,
                //         "contractTotalSigners": ContractDB.contractTotalSigners,
                //         "contractAuthName": ContractDB.contractAuthName,
                //         "contractAuthHash": ContractDB.contractAuthHash,
                //         "contractAddress": widget.documentName,
                //         "Signers": [
                //           {
                //             "date": DateFormat('yyyy-MM-dd')
                //                 .format(DateTime.now())
                //                 .toString(),
                //             "name": FirebaseDB.userName,
                //             "hash": calculateMD5(
                //                 "$FirebaseDB.userName$FirebaseDB.citizenshipNumber"),
                //           },
                //           {
                //             "date": ".........",
                //             "name": ".........",
                //             "hash": "........"
                //           },
                //         ]
                //       });
                //   customSnackbar(
                //     context: context,
                //     text: "Contract is sucessfully signed",
                //     icons: Icons.done,
                //     iconsColor: Colors.green,
                //   );
                // } else {
                //   ContractDB.editContractInFirestore(
                //       context: context,
                //       contractAddress: widget.documentName,
                //       updatedContractData: {
                //         "date": ContractDB.date,
                //         "contractName": ContractDB.contractName,
                //         "contractDescription": ContractDB.contractDescription,
                //         "contractContent": ContractDB.contractContent,
                //         "contractTermsAndCondition":
                //             ContractDB.contractTermsAndCondition,
                //         "contractTotalSigners": ContractDB.contractTotalSigners,
                //         "contractAuthName": ContractDB.contractAuthName,
                //         "contractAuthHash": ContractDB.contractAuthHash,
                //         "contractAddress": widget.documentName,
                //         "Signers": [
                //           {
                //             "date": ContractDB.Signers?[0]["date"],
                //             "name": ContractDB.Signers?[0]["name"],
                //             "hash": ContractDB.Signers?[0]["hash"],
                //           },
                //           {
                //             "date": DateFormat('yyyy-MM-dd')
                //                 .format(DateTime.now())
                //                 .toString(),
                //             "name": FirebaseDB.userName,
                //             "hash": calculateMD5(
                //                 "$FirebaseDB.userName$FirebaseDB.citizenshipNumber"),
                //           },
                //         ]
                //       });
                //   customSnackbar(
                //     context: context,
                //     text: "Contract is sucessfully signed",
                //     icons: Icons.done,
                //     iconsColor: Colors.green,
                //   );
                // }
                setState(() {});
                EasyLoading.dismiss();
              },
              iconData: Icon(
                Icons.note_add_outlined,
                color: Colors.black,
              ),
            ),
          ]),
        )),
      ),
    );
  }

//   Future<Uint8List> _createPdf({
//     required PdfPageFormat format,
//     required String contractTitle,
//     required String contractDescription,
//     required List termsAndConditions,
//     required String partyOneName,
//     required String partyOneHash,
//     required String partyOneDate,
//     required String partyTwoName,
//     required String partyTwoHash,
//     required String partyTwoDate,
//     required String AuthenticatorName,
//     required String AuthenticatorHash,
//     required String AuthenticatorDate,
//     required String contractCreatedDate,
//   }) async {
//     final pdf = pw.Document(
//       version: PdfVersion.pdf_1_4,
//       compress: true,
//     );
//     pdf.addPage(
//       pw.MultiPage(
//           pageFormat: PdfPageFormat.a4,
//           margin: const pw.EdgeInsets.all(32),
//           build: (pw.Context context) {
//             return <pw.Widget>[
//               pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
//                 pw.Text(
//                   "Date: $contractCreatedDate",
//                 ),
//               ]),
//               pw.Header(
//                   level: 1,
//                   child: pw.Row(
//                       mainAxisAlignment: pw.MainAxisAlignment.center,
//                       children: <pw.Widget>[
//                         pw.Text(
//                           contractTitle,
//                           textScaleFactor: 2,
//                         ),
//                       ])),
//               pw.SizedBox(height: 20),
//               pw.Paragraph(
//                 text: contractDescription,
//               ),
//               pw.Header(
//                 text: "Term and Conditions:",
//               ),
//               for (int i = 0; i < termsAndConditions.length; i++)
//                 pw.Padding(
//                   padding: pw.EdgeInsets.only(top: 10),
//                   child: pw.Text(
//                     '${i + 1}.${termsAndConditions[i]}',
//                     style: const pw.TextStyle(fontSize: 12.0),
//                   ),
//                 ),
//               pw.SizedBox(height: 20),
//               pw.Header(
//                 text: "Signatures:",
//               ),
//               pw.Row(
//                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                 children: [
//                   pw.Column(
//                       mainAxisAlignment: pw.MainAxisAlignment.start,
//                       crossAxisAlignment: pw.CrossAxisAlignment.start,
//                       children: [
//                         pw.Header(
//                           text: "Party 1",
//                         ),
//                         pw.Text(
//                           "Name:$partyOneName",
//                         ),
//                         pw.Text(
//                           "Hash:$partyOneHash",
//                         ),
//                         pw.Text(
//                           "Date:$partyOneDate",
//                         ),
//                       ]),
//                   pw.Column(
//                       mainAxisAlignment: pw.MainAxisAlignment.start,
//                       crossAxisAlignment: pw.CrossAxisAlignment.start,
//                       children: [
//                         pw.Header(
//                           text: "Party 2",
//                         ),
//                         pw.Text(
//                           "Name:$partyTwoName",
//                         ),
//                         pw.Text(
//                           "Hash:$partyTwoHash",
//                         ),
//                         pw.Text(
//                           "Date:$partyTwoDate",
//                         ),
//                       ]),
//                 ],
//               ),
//               pw.Padding(padding: const pw.EdgeInsets.all(10)),
//               // pw.Column(
//               //     mainAxisAlignment: pw.MainAxisAlignment.start,
//               //     crossAxisAlignment: pw.CrossAxisAlignment.start,
//               //     children: [
//               //       pw.Header(
//               //         text: "Authenticator",
//               //       ),
//               //       pw.Text(
//               //         "Name:$AuthenticatorName",
//               //       ),
//               //       pw.Text(
//               //         "Hash:$AuthenticatorHash",
//               //       ),
//               //       pw.Text(
//               //         "Date:$AuthenticatorDate",
//               //       ),
//               //     ]),
//             ];
//           }),
//     );
//     // Get the local directory path
//     final directory = await getExternalStorageDirectory();

//     // Create a file path
//     final filePath = '${directory?.path}/terms_and_conditions.pdf';

//     // Save the PDF to local storage
//     final file = File(filePath);
//     await file.writeAsBytes(await pdf.save());

//     print('PDF saved to: $filePath');
//     return pdf.save();
//   }
}

class ImageViewer extends StatelessWidget {
  const ImageViewer({
    super.key,
    required this.imgURL,
    required this.user,
    required this.onDelete,
  });
  final Function onDelete;
  final User user;
  final String imgURL;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 15),
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    height: MediaQuery.of(context).size.height * 0.4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.transparent,
                      border: Border.all(
                        color: Colors.white,
                        width: 2.0, // Border width
                      ),
                    ),
                    child: Container()),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(imgURL), // Replace with your image URL
                    fit: BoxFit.cover, // You can adjust the fit as needed
                  ),
                ),
                // child: CachedNetworkImage(
                //   imageUrl: imgURL,
                //   placeholder: (context, url) => CircularProgressIndicator(),
                //   errorWidget: (context, url, error) => Icon(Icons.error),
                // ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: CustomProgressButton(
              label: Text(
                "Delete",
                style: kwhiteTextStyle,
              ),
              icons: Icon(Icons.delete_forever),
              onTap: () {
                onDelete();
              },
            ),
          )
        ],
      ),
    );
  }
}

void _showCreateDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // Return an AlertDialog with a TextField and a Create button
      return AlertDialog(
        title: Text('Create Something'),
        content: TextField(
          decoration: InputDecoration(
            hintText: 'Enter something',
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Create'),
            onPressed: () {
              // Handle the "Create" button press here
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
        ],
      );
    },
  );
}
