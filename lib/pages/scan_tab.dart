import 'package:empire_ent/database/database.dart';
import 'package:empire_ent/widgets/primary_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScanTab extends StatefulWidget {
  const ScanTab({super.key});

  @override
  State<ScanTab> createState() => _ScanTabState();
}

class _ScanTabState extends State<ScanTab> {
  final TextEditingController _ticketNumberController = TextEditingController();
  final DatabaseController databaseController = Get.put(DatabaseController());
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
              label: 'Ticket Number'),
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
        ],
      ),
    );
  }
}
