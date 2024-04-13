import 'package:cloud_firestore/cloud_firestore.dart';
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
    try {
      await tickets.add({
        'Name': name,
        'Ticket Id': ticketId,
        'Phone Number': phoneNumber,
        'Email': email,
        'Ticket Type': ticketType,
        'Quantity': quantity,
        // other data
      });
    } catch (e) {
      return false;
    }
    return true;
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
