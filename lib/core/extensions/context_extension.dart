import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  // Navigation
  void navigateTo(String routeName) {
    Navigator.pushNamed(this, routeName);
  }

  void navigateAndReplace(String routeName) {
    Navigator.pushReplacementNamed(this, routeName);
  }

  void navigateAndRemoveUntil(String routeName) {
    Navigator.pushNamedAndRemoveUntil(this, routeName, (route) => false);
  }

  void navigateBack() {
    Navigator.pop(this);
  }
}
