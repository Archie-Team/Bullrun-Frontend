import 'package:flutter/material.dart';
import 'package:get/get.dart';

showSnackbar(String title, String content, IconData icon) {
  if (!Get.isSnackbarOpen) {
    Get.snackbar(title, content,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        backgroundColor: Colors.black.withOpacity(0.5),
        icon: Icon(
          icon,
          color: Colors.white,
          size: 30,
        ));
  }
}

Widget showLoading() {
  return const CircularProgressIndicator(
    color: Colors.white,
  );
}

void showGetDialog(
    {required String title, required Widget content, bool cancelable = true}) {
  Get.defaultDialog(
    title: title,
    titleStyle: const TextStyle(fontWeight: FontWeight.bold),
    titlePadding: const EdgeInsets.only(top: 16),
    contentPadding: const EdgeInsets.only(left: 20, right: 20, top: 10),
    backgroundColor: const Color(0xff31463A),
    content: content,
    barrierDismissible: cancelable,
    onWillPop: () async => false,
  );
}
