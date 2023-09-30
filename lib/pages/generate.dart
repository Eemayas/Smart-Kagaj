// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smart_kagaj/commonWidgets/animated_button.dart';
import 'package:smart_kagaj/constant/fonts.dart';

import '../constant/colors.dart';

class PDFView extends StatefulWidget {
  const PDFView({super.key});

  @override
  State<PDFView> createState() => _PDFViewState();
}

class _PDFViewState extends State<PDFView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColorAppBar,
        title: Text(
          "Contracts",
          style: kwhiteTextStyle,
        ),
        actions: [
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () => {}),
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
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
              build: (format) => _createPdf(
                format: format,
                contractTitle: "Contract Title",
                contractDescription:
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Nunc mi ipsum faucibus vitae aliquet nec. Nibh cras pulvinar mattis nunc sed blandit libero volutpat. Vitae elementum curabitur vitae nunc sed velit. Nibh tellus molestie nunc non blandit massa. Bibendum enim facilisis gravida neque. Arcu cursus euismod quis viverra nibh cras pulvinar mattis. Enim diam vulputate ut pharetra sit. Tellus pellentesque eu tincidunt tortor aliquam nulla facilisi cras fermentum.",
                termsAndConditions: [
                  'Item 1',
                  'Item 2',
                  'Item 3',
                ],
                partyOneName: "partyOneName",
                partyOneHash: "partyOneHash",
                partyOneDate: "partyOneDate",
                partyTwoName: "partyTwoName",
                partyTwoHash: "partyTwoHash",
                partyTwoDate: "partyTwoDate",
                contractCreatedDate: "contractCreatedDate",
              ),
            ),
          ),
          RiveAnimatedBtn(
              label: "label",
              iconData: Icon(Icons.abc),
              onTap: () {
                // AdminDB.initializeDataInFirestore();
                // AdminDB.addAdminToListInFirestore(
                //     newAdminUser: "prashantmanandhar202@gmail.com",
                //     context: context);
                // AdminDB.fetchAdminListFromFirestore();
                // AdminDB.deleteContractFromFirestore(
                //     dataToDelete: "prashantmanandhar202@gmail.com");
              })
        ],
      )),
    );
  }

  Future<Uint8List> _createPdf({
    required PdfPageFormat format,
    required String contractTitle,
    required String contractDescription,
    required List termsAndConditions,
    required String partyOneName,
    required String partyOneHash,
    required String partyOneDate,
    required String partyTwoName,
    required String partyTwoHash,
    required String partyTwoDate,
    required String contractCreatedDate,
  }) async {
    final pdf = pw.Document(
      version: PdfVersion.pdf_1_4,
      compress: true,
    );

    pdf.addPage(
      pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context) {
            return <pw.Widget>[
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
                pw.Text(
                  "Date: $contractCreatedDate",
                ),
              ]),
              pw.Header(
                  level: 1,
                  child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: <pw.Widget>[
                        pw.Text(
                          contractTitle,
                          textScaleFactor: 2,
                        ),
                      ])),
              pw.SizedBox(height: 20),
              pw.Paragraph(
                text: contractDescription,
              ),
              pw.Header(
                text: "Term and Conditions:",
              ),
              for (int i = 0; i < termsAndConditions.length; i++)
                pw.Padding(
                  padding: pw.EdgeInsets.only(top: 10),
                  child: pw.Text(
                    '$i.${termsAndConditions[i]}',
                    style: const pw.TextStyle(fontSize: 12.0),
                  ),
                ),
              pw.SizedBox(height: 20),
              pw.Header(
                text: "Signatures:",
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Header(
                          text: "Party 1",
                        ),
                        pw.Text(
                          "Name:$partyOneName",
                        ),
                        pw.Text(
                          "Hash:$partyOneHash",
                        ),
                        pw.Text(
                          "Date:$partyOneDate",
                        ),
                      ]),
                  pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Header(
                          text: "Party 2",
                        ),
                        pw.Text(
                          "Name:$partyTwoName",
                        ),
                        pw.Text(
                          "Hash:$partyTwoHash",
                        ),
                        pw.Text(
                          "Date:$partyTwoDate",
                        ),
                      ]),
                ],
              ),
              pw.Padding(padding: const pw.EdgeInsets.all(10)),
            ];
          }),
    );

    // Get the local directory path
    final directory = await getExternalStorageDirectory();

    // Create a file path
    final filePath = '${directory?.path}/terms_and_conditions.pdf';

    // Save the PDF to local storage
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    print('PDF saved to: $filePath');
    return pdf.save();
  }
}

// Future<void> generatePDF() async {
//   final pdf = pw.Document();

//   // Function to add content to the PDF
//   void addContentToPDF() {
//     // Replace this with your own content generation logic.
//     for (int i = 0; i < 50; i++) {
//       pdf.addPage(
//         pw.Page(
//           build: (pw.Context context) {
//             return pw.Text('Content $i on page ${pdf.pagesCount + 1}');
//           },
//         ),
//       );
//     }
//   }

//   // Define the maximum content height before creating a new page (adjust as needed).
//   final double maxContentHeight = PdfPageFormat.letter.height - 72.0;

//   // Generate PDF content
//   while (true) {
//     // Check if adding this page would exceed the max content height
//     if (pdf.pagesCount > 0 &&
//         pdf.pages.last.pageFormat.availableHeight < maxContentHeight) {
//       pdf.addPage(
//         pw.Page(
//           build: (pw.Context context) {
//             return pw.Container(); // Empty container for a new page
//           },
//         ),
//       );
//     } else {
//       // Add content to the current page
//       addContentToPDF();
//     }

//     // You can adjust the number of pages generated or break out of the loop based on your requirements.
//     if (pdf.pagesCount >= 5) {
//       break;
//     }
//   }

//   // Save the PDF to a file
//   final dir = await getApplicationDocumentsDirectory();
//   final file = File('${dir.path}/example.pdf');
//   await file.writeAsBytes(await pdf.save());
// }
