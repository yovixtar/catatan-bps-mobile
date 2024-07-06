import 'package:flutter/material.dart';

class SnackbarUtils {
  static void showSuccessSnackbar(BuildContext context, String successMessage) {
    final snackBar = SnackBar(
      content: Text(
        successMessage,
        style: TextStyle(
          color: Colors.black87,
        ),
      ),
      backgroundColor: Colors.greenAccent,
      behavior: SnackBarBehavior.floating,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void showErrorSnackbar(BuildContext context, String errorMessage) {
    final snackBar = SnackBar(
      content: Text(
        errorMessage,
        style: TextStyle(
          color: Colors.black87,
        ),
      ),
      backgroundColor: Colors.red[200],
      behavior: SnackBarBehavior.floating,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
