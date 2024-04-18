import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire_ent/controllers/database_controller.dart';
import 'package:empire_ent/services/pdf/pdf_generator.dart';
import 'package:empire_ent/utils/widget_helper.dart';
import 'package:empire_ent/widgets/primary_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class OverviewTab extends StatefulWidget {
  const OverviewTab({super.key});

  @override
  State<OverviewTab> createState() => _OverviewTabState();
}

class _OverviewTabState extends State<OverviewTab> {
  late Future<List<DocumentSnapshot>> _ticketsFuture;
  bool isLoading = false;
  Future<void> saveFile(Uint8List bytes, String name) async {
    setState(() {
      isLoading = true;
    });

    try {
      final Directory dir = await getTemporaryDirectory();
      final File file = File('${dir.path}/$name.pdf');
      await file.writeAsBytes(bytes);

      Share.shareFiles(['${dir.path}/$name.pdf']);
    } catch (e) {
      WidgetHelper.snackbar(
        '',
        'Error saving PDF: $e',
      );
      setState(() {
        isLoading = false;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _ticketsFuture = _fetchTickets();
  }

  DatabaseController databaseController = Get.put(DatabaseController());
  Future<List<DocumentSnapshot>> _fetchTickets() async {
    return databaseController.getTickets();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          FutureBuilder<List<DocumentSnapshot>>(
            future: _ticketsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                int attendedCount = snapshot.data
                        ?.where((doc) => doc['Attended'] == true)
                        .length ??
                    0;
                int notAttended = snapshot.data
                        ?.where((doc) => doc['Attended'] == false)
                        .length ??
                    0;
                return Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        PrimaryText(
                          text: "$attendedCount Attended",
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                        PrimaryText(
                          text: "$notAttended Not Attended",
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        var ticketData = snapshot.data?[index].data()
                            as Map<String, dynamic>;
                        var name = ticketData['Name'] as String? ?? 'No Name';
                        var email =
                            ticketData['Email'] as String? ?? 'No Email';
                        var ticketId = ticketData['Ticket Id'] as String? ??
                            'No Ticket Id';
                        var phoneNumber =
                            ticketData['Phone Number'] as String? ??
                                'No Phone Number';
                        var attended = ticketData['Attended'] ?? false;
                        var quantity = ticketData['Quantity'] as int? ?? 1;
                        var ticketType =
                            ticketData['Ticket Type'] as String? ?? 'Invalid';
                        return ListTile(
                          leading: Icon(
                            attended ? Icons.check_rounded : Icons.cancel,
                            size: 20,
                          ),
                          title: PrimaryText(
                            text: name,
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                          subtitle: Row(
                            children: [
                              PrimaryText(
                                text: quantity.toString(),
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.0),
                                child: Icon(
                                  Icons.circle,
                                  size: 5,
                                  color: Colors.green,
                                ),
                              ),
                              PrimaryText(
                                text: ticketType,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            onPressed: () async {
                              var doc = await generatePdf(
                                email: email,
                                ticketType: ticketType,
                                quantity: quantity,
                                ticketId: ticketId,
                              );
                              var bytes = await doc.save();
                              await saveFile(bytes, 'Ticket');
                            },
                            icon: Icon(
                              Icons.gesture_sharp,
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
