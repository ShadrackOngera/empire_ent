import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire_ent/utils/widget_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DatabaseController extends GetxController {
  Rx<String> currentName = ''.obs;
  Rx<String> currentEmail = ''.obs;
  Rx<String> currentTicketType = ''.obs;
  Rx<String> currentPhoneNumber = ''.obs;
  Rx<String> currentTicketId = ''.obs;
  Rx<String> currentQuantity = ''.obs;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference tickets =
      FirebaseFirestore.instance.collection('tickets');

  Future<bool> createUser(String username, email) async {
    try {
      await users.add({
        'username': username,
        'email': email,
        // other data
      });
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<bool> saveTicket(
    String name,
    String ticketId,
    String phoneNumber,
    String email,
    String ticketType,
    String quantity,
  ) async {
    // Get reference to the collection
    final ticketsCollection = FirebaseFirestore.instance.collection('tickets');

    try {
      final existingTicket = await ticketsCollection.doc(ticketId).get();

      if (existingTicket.exists) {
        WidgetHelper.snackbar(
          'Failded',
          'Ticket Already Exists',
        );
        return false;
      } else {
        await ticketsCollection.doc(ticketId).set({
          'Name': name,
          'Ticket Id': ticketId,
          'Phone Number': phoneNumber,
          'Email': email,
          'Ticket Type': ticketType,
          'Quantity': quantity,
          'Attended': false,
        });
      }
    } catch (e) {
      WidgetHelper.snackbar(
        'Error',
        e.toString(),
      );
      return false;
    }
    return true;
  }

  Future<void> markTicketAsEntered(String ticketNumber) async {
    try {
      // Get reference to the tickets collection
      final ticketsCollection =
          FirebaseFirestore.instance.collection('tickets');

      // Query for the ticket with the given ticketNumber
      final querySnapshot = await ticketsCollection
          .where('Ticket Id', isEqualTo: ticketNumber)
          .get();

      // Check if a ticket with the given number exists
      if (querySnapshot.docs.isNotEmpty) {
        final ticketDoc = querySnapshot.docs.first;
        final ticketData = ticketDoc.data();

        // Check if the ticket has already been attended
        if (ticketData['Attended'] == true) {
          // Inform the user that the ticket has already been marked as attended
          WidgetHelper.snackbar('Failed', 'User has Already Joined the Event');
          // throw Exception('Ticket already marked as entered.');
        } else {
          // If the user chooses to mark the ticket as entered, update the database
          await ticketsCollection.doc(ticketDoc.id).update({'Attended': true});
        }
      } else {
        WidgetHelper.snackbar('Failed', 'Ticket Not Found');
        // throw Exception('Ticket not found.');
      }
    } catch (e) {
      // Handle any errors
      throw Exception('Error: $e');
    }
  }

  Future<List<DocumentSnapshot>> getTickets() async {
    try {
      QuerySnapshot querySnapshot = await tickets.get();
      return querySnapshot.docs;
    } catch (e) {
      print("Error getting tickets: $e");
      return [];
    }
  }
}
