import 'dart:io';
import 'dart:typed_data';
import 'package:empire_ent/utils/widget_helper.dart';
import 'package:empire_ent/widgets/primary_text.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_saver/file_saver.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show ByteData, rootBundle;

class PdfPage extends StatefulWidget {
  const PdfPage({super.key});

  @override
  State<PdfPage> createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> {
  final pdf = pw.Document();

  Future<void> saveFile(Uint8List bytes, String name) async {
    try {
      final Directory dir = await getTemporaryDirectory();
      final File file = File('${dir.path}/$name.pdf');
      await file.writeAsBytes(bytes);

      // Show a snackbar or any other feedback that the file has been saved
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('PDF saved successfully'),
      ));

      // Share the saved file
      Share.shareFiles(['${dir.path}/$name.pdf']);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error saving PDF: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('sdfghjk'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/images/image-two.png',
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.width * .6,
                  width: MediaQuery.of(context).size.width * .5,
                  // width: Media,
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    color: Colors.blue,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Center(
                          child: PrimaryText(
                            text: 'Thank You for buying :)',
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ),
                        PrimaryText(
                          text: "Receipt",
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                        PrimaryText(
                          text: 'Name: Shadrack Ongera',
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                        PrimaryText(
                          text: 'Ticket Type: Group',
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                        PrimaryText(
                          text: 'Quantity: 1',
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                        Center(
                          child: QrImageView(
                            data: '1234567890',
                            version: QrVersions.auto,
                            size: 90.0,
                          ),
                        ),
                        Center(
                          child: PrimaryText(
                            fontSize: 10,
                            text: 'Carry this document for verification',
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: ElevatedButton(
        onPressed: () async {
          final doc = pw.Document();
          doc.addPage(await _generatePdf());
          var bytes = await doc.save();
          await saveFile(bytes, 'Ticket');
        },
        child: PrimaryText(
          text: 'Export as PDF',
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
    );
  }

  Future<void> savePdfFile(Uint8List bytes) async {
    await FileSaver.instance.saveFile(
      name: 'name',
      bytes: bytes,
      ext: 'pdf',
    );
  }

  Future<pw.Page> _generatePdf() async {
    final ByteData data = await rootBundle.load('assets/images/image-two.png');
    final List<int> bytes = data.buffer.asUint8List();

    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/image-two.png');
    await tempFile.writeAsBytes(bytes);

    final image = pw.MemoryImage(tempFile.readAsBytesSync());
    pw.TextStyle textStyle = pw.TextStyle(
      color: const PdfColor.fromInt(0xFF00004d),
      fontSize: 16,
      fontWeight: pw.FontWeight.bold,
    );

    return pw.Page(
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
                        'Name: Shadrack Ongera',
                        style: textStyle,
                      ),
                      pw.Text(
                        'Ticket Type: Group',
                        style: textStyle,
                      ),
                      pw.Text(
                        'Quantity: 1',
                        style: textStyle,
                      ),
                    ],
                  ),
                  pw.BarcodeWidget(
                    barcode: pw.Barcode.qrCode(),
                    data: '1234567890', // Your data here
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
    );
  }
}
