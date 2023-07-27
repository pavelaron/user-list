import 'package:flutter/material.dart';

class ErrorSnackbar {
  static void show(BuildContext context, String message) {
    ScaffoldMessenger
      .of(context)
      .showSnackBar(SnackBar(
        backgroundColor: Colors.red[300],
          content: Row(
            children: [
              const Icon(Icons.error),
              const SizedBox(width: 20),
              Text(message),
            ],
        ),
      ));
  }
}
