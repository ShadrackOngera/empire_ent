import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show ByteData, rootBundle;

Future<pw.Document> generatePdf({
  String? email,
  String? ticketType,
  int? quantity,
  String? ticketId,
}) async {
  final ByteData data = await rootBundle.load('assets/images/image-two.png');
  final List<int> bytes = data.buffer.asUint8List();

  final tempDir = await getTemporaryDirectory();
  final tempFile = File('${tempDir.path}/image-two.png');
  await tempFile.writeAsBytes(bytes);

  final image = pw.MemoryImage(tempFile.readAsBytesSync());
  pw.TextStyle textStyle = pw.TextStyle(
    color: const PdfColor.fromInt(0xFF00004d),
    fontSize: 13,
    fontWeight: pw.FontWeight.bold,
  );

  final doc = pw.Document();
  doc.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Padding(
          padding: const pw.EdgeInsets.all(8.0),
          child: pw.Column(
            children: [
              pw.SizedBox(height: 20),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                children: [
                  pw.ClipRRect(
                    horizontalRadius: 10,
                    verticalRadius: 10,
                    child: pw.Image(
                      image,
                      width: 100,
                      height: 100,
                    ),
                  ),
                  pw.Text(
                    'Thank You for buying :)',
                    style: textStyle,
                  ),
                ],
              ),
              pw.SizedBox(height: 80),
              pw.Text(
                "Receipt",
                style: textStyle,
              ),
              pw.SizedBox(height: 20),
              pw.Divider(),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Email: $email',
                        style: textStyle,
                      ),
                      pw.Text(
                        'Ticket Type: $ticketType',
                        style: textStyle,
                      ),
                      pw.Text(
                        'Quantity:  $quantity',
                        style: textStyle,
                      ),
                    ],
                  ),
                  pw.BarcodeWidget(
                    barcode: pw.Barcode.qrCode(),
                    data: ticketId!,
                    width: 100,
                    height: 100,
                  ),
                ],
              ),
              pw.SizedBox(height: 90),
              pw.Center(
                child: pw.Text(
                  'Carry this document for verification',
                  style: textStyle,
                ),
              ),
            ],
          ),
        );
      },
    ),
  );

  return doc;
}
