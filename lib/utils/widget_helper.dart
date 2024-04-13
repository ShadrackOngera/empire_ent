import 'package:empire_ent/widgets/primary_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

class WidgetHelper {
  static SnackbarController snackbar(
    String title,
    String message, {
    int? duration,
    IconData? icon,
  }) =>
      Get.snackbar(
        title,
        message,
        //animationDuration: const Duration(seconds: 2),
        maxWidth: 450,
        titleText: PrimaryText(
          text: title,
          color: Colors.black,
        ),
        // titleText: Text(
        //   title,
        //   style: const TextStyle(
        //     color: Constants.blueColor,
        //   ),
        // ),
        messageText: Text(
          message,
          style: const TextStyle(
            color: Color(0xff3F3532),
          ),
        ),
        colorText: Colors.black,
        backgroundColor: Colors.white,
        duration: Duration(seconds: duration ?? 4),
        borderWidth: 1,
        borderColor: Colors.blue,
        isDismissible: true,
        margin: const EdgeInsets.only(top: 30, left: 10, right: 10),
        mainButton: TextButton(
          onPressed: () {
            Get.closeAllSnackbars();
          },
          child: const Icon(
            Icons.close,
            color: Colors.grey,
          ),
        ),
        icon: Icon(icon),
      );

  static LinearGradient customGradient() {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFF5946e0),
        Color(0xFF4c60e5),
      ],
    );
  }


  
}
