import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class OverviewController {
  static Future<void> contactActionOnTap(
      String? sendTo, String? contactDetails) {
    // print('object');
    switch (sendTo) {
      case 'email':
        sendEmail() async {
          final Uri emailLaunchUri = Uri(
            scheme: 'mailto',
            path: "$contactDetails",
          );
          launchUrl(emailLaunchUri);
        }
        return sendEmail();

      case 'whatsapp':
        String url = "";
        //https://wa.me/$contactDetails/?text=''

        if (kIsWeb) {
          url = "https://wa.me/$contactDetails/?text=''";
        } else {
          if (Platform.isIOS) {
            url =
                "whatsapp://wa.me/$contactDetails/?text=${Uri.encodeFull("")}";
          } else {
            url =
                "whatsapp://send?phone=$contactDetails&text=${Uri.encodeFull("")}";
          }
          launchUrl(Uri.parse(url));
        }

        return launchUrl(Uri.parse(url));

      default:
        defaultAction() async {}
        return defaultAction();
    }
  }
}
