import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire_ent/database/database.dart';
import 'package:empire_ent/widgets/primary_text.dart';
import 'package:flutter/material.dart';

class OverviewTab extends StatefulWidget {
  const OverviewTab({super.key});

  @override
  State<OverviewTab> createState() => _OverviewTabState();
}

class _OverviewTabState extends State<OverviewTab> {
  late Future<List<DocumentSnapshot>> _ticketsFuture;

  @override
  void initState() {
    super.initState();
    _ticketsFuture = _fetchTickets();
  }

  Future<List<DocumentSnapshot>> _fetchTickets() async {
    DatabaseController database = DatabaseController();
    return database.getTickets();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder<List<DocumentSnapshot>>(
          future: _ticketsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data?.length ?? 0,
                itemBuilder: (context, index) {
                  var ticketData =
                      snapshot.data?[index].data() as Map<String, dynamic>;
                  var name = ticketData['Name'] as String? ?? 'No Name';
                  var phoneNumber = ticketData['Phone Number'] as String? ??
                      'No Phone Number';
                  var email = ticketData['Email'] as String? ?? 'No Email';
                  var quantity = ticketData['Quantity'] as String? ?? 'Null';
                  var ticketType =
                      ticketData['Ticket Type'] as String? ?? 'Invalid';
                  return ListTile(
                    leading: Icon(
                      Icons.check_rounded,
                      size: 20,
                    ),
                    title: PrimaryText(
                      text: name,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                    subtitle: Row(
                      children: [
                        PrimaryText(
                          text: quantity,
                          color: Theme.of(context).colorScheme.inversePrimary,
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
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.gesture_sharp,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ],
    );
  }
}
