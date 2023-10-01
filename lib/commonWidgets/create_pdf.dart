import 'dart:io' as io;

import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<Uint8List> createPdf({
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
  required String AuthenticatorName,
  required String AuthenticatorHash,
  required String AuthenticatorDate,
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
                  '${i + 1}.${termsAndConditions[i]}',
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
            pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Header(
                    text: "Authenticator",
                  ),
                  pw.Text(
                    "Name:$AuthenticatorName",
                  ),
                  pw.Text(
                    "Hash:$AuthenticatorHash",
                  ),
                  pw.Text(
                    "Date:$AuthenticatorDate",
                  ),
                ]),
          ];
        }),
  );

  // Get the local directory path
  final directory = await getExternalStorageDirectory();

  // Create a file path
  final filePath = '${directory?.path}/terms_and_conditions.pdf';

  // Save the PDF to local storage
  final file = io.File(filePath);
  await file.writeAsBytes(await pdf.save());

  print('PDF saved to: $filePath');
  return pdf.save();
}
