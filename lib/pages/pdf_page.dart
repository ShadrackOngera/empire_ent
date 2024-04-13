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

class PdfPage extends StatefulWidget {
  const PdfPage({super.key});

  @override
  State<PdfPage> createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> {
  final pdf = pw.Document();

  Future<void> saveFile(document, String name) async {
    try {
      final Directory dir = await getTemporaryDirectory();
      final File file = File('${dir.path}/$name.pdf');
      WidgetHelper.snackbar(
        'worked',
        'woirk',
      );
      // Get.back();

      await file.writeAsBytes(await document.save()).then((value) {
        Share.shareXFiles([XFile(value.path)]);
      }).then((value) {});
    } on Exception catch (e) {
      // TODO
      WidgetHelper.snackbar(
        'Error',
        e.toString(),
      );
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
          await savePdfFile(bytes);
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
    return pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Padding(
          padding: const pw.EdgeInsets.all(8.0),
          child: pw.Text('data'),
        );
      },
    );
  }
}
