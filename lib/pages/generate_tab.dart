import 'package:empire_ent/database/database.dart';
import 'package:empire_ent/widgets/primary_button.dart';
import 'package:empire_ent/widgets/primary_text.dart';
import 'package:empire_ent/widgets/primary_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_saver/file_saver.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show ByteData, rootBundle;

class GenerateTab extends StatefulWidget {
  const GenerateTab({super.key});

  @override
  State<GenerateTab> createState() => _GenerateTabState();
}

class _GenerateTabState extends State<GenerateTab> {
  TextEditingController ticketIdController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController ticketTypeController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  final saveDetailsKey = GlobalKey<FormState>();
  DatabaseController databaseController = Get.put(DatabaseController());
  bool isLoading = false;

  Future<void> saveFile(Uint8List bytes, String name) async {
    setState(() {
      isLoading = true;
    });

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving PDF: $e'),
        ),
      );
      setState(() {
        isLoading = false;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  void clearForm() {
    nameController.clear();
    ticketIdController.clear();
    phoneNumberController.clear();
    emailController.clear();
    ticketTypeController.clear();
    quantityController.clear();
  }

  saveAndGenerate() {
    setState(() {
      isLoading = true;
    });
    databaseController.currentName.value = nameController.text;
    databaseController.currentEmail.value = emailController.text;
    databaseController.currentPhoneNumber.value = phoneNumberController.text;
    databaseController.currentQuantity.value = quantityController.text;
    databaseController.currentTicketType.value = ticketTypeController.text;
    if (saveDetailsKey.currentState!.validate()) {
      DatabaseController()
          .saveTicket(
        nameController.text,
        ticketIdController.text,
        phoneNumberController.text,
        emailController.text,
        ticketTypeController.text,
        quantityController.text,
      )
          .then(
        (value) async {
          final doc = pw.Document();
          doc.addPage(await _generatePdf());
          var bytes = await doc.save();
          await saveFile(bytes, 'Ticket');
        },
      );
    } else {
      setState(() {
        isLoading = false;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? CircularProgressIndicator()
        : SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 13, vertical: 15),
            child: Form(
              key: saveDetailsKey,
              child: Column(
                children: [
                  PrimaryTextField(
                    label: 'Name',
                    obsecureText: false,
                    controller: nameController,
                    hintText: 'Name',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  PrimaryTextField(
                    label: 'Ticket Id',
                    obsecureText: false,
                    controller: ticketIdController,
                    hintText: 'Ticket Id',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  PrimaryTextField(
                    label: 'Phone Number',
                    obsecureText: false,
                    controller: phoneNumberController,
                    hintText: 'Phone Number',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  PrimaryTextField(
                    label: 'Email',
                    obsecureText: false,
                    controller: emailController,
                    hintText: 'Email',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  PrimaryTextField(
                    label: 'Ticket Type',
                    obsecureText: false,
                    controller: ticketTypeController,
                    hintText: 'Email',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  PrimaryTextField(
                    label: 'Quantity',
                    obsecureText: false,
                    controller: quantityController,
                    hintText: 'Quantity',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  PrimaryButton(
                    onTap: () => saveAndGenerate(),
                    child: PrimaryText(
                      text: 'Save and Generate',
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
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
      fontSize: 13,
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
                        'Email: ${databaseController.currentEmail.value}',
                        style: textStyle,
                      ),
                      pw.Text(
                        'Ticket Type: ${databaseController.currentTicketType.value}',
                        style: textStyle,
                      ),
                      pw.Text(
                        'Quantity:  ${databaseController.currentQuantity.value}',
                        style: textStyle,
                      ),
                    ],
                  ),
                  pw.BarcodeWidget(
                    barcode: pw.Barcode.qrCode(),
                    data: databaseController.currentTicketId.value,
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