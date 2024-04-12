import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class Database extends GetxController {
  // Rx<String> username = ''.obs;
  // Rx<String> email = ''.obs;
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

  Future<bool> saveTicket(String ticketId, phoneNumber) async {
    try {
      await tickets.add({
        'Ticket Id': ticketId,
        'Phone Number': phoneNumber,
        // other data
      });
    } catch (e) {
      return false;
    }
    return true;
  }
}
