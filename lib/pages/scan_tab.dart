import 'package:empire_ent/database/database.dart';
import 'package:empire_ent/widgets/primary_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class ScanTab extends StatefulWidget {
  const ScanTab({super.key});

  @override
  State<ScanTab> createState() => _ScanTabState();
}

class _ScanTabState extends State<ScanTab> {
  final TextEditingController _ticketNumberController = TextEditingController();
  final DatabaseController databaseController = Get.put(DatabaseController());
  String _scannedData = '';
  Future<void> scanQR() async {
    try {
      final scannedData = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666",
        "Cancel",
        true,
        ScanMode.QR,
      );

      if (!mounted) return;

      setState(() {
        _scannedData = scannedData;
      });

      await databaseController.markTicketAsEntered(_scannedData);
    } catch (e) {
      print('Error while scanning QR code: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PrimaryTextField(
            controller: _ticketNumberController,
            obsecureText: false,
            label: 'Ticket Number',
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              try {
                await databaseController
                    .markTicketAsEntered(_ticketNumberController.text);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Ticket marked as entered.'),
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error: $e'),
                  ),
                );
              }
            },
            child: Text('Mark as Entered'),
          ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
            onPressed: () => scanQR(),
            child: Text('Scan'),
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
