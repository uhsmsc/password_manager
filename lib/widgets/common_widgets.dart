import 'package:flutter/material.dart';

class SnackbarHandler {
  static void showSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(
      duration: const Duration(seconds: 3),
      content: Text(message),
    );
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
