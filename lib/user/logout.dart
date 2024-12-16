import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../comman pages/buttons.dart';

Future<void> logout(BuildContext context) async {
  // Obtain shared preferences
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  // Clear the token or any other session data
  await prefs.clear();

  // Navigate to the login screen
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(
        builder: (context) =>
            const buttons()), // Replace `LoginScreen` with your actual login widget
    (Route<dynamic> route) => false,
  );
}
