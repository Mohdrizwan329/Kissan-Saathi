import 'package:flutter/material.dart';

class AppBarStyle {
  static const gradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1B5E20), Color(0xFF388E3C)],
  );

  static Widget flexibleSpace() {
    return Container(
      decoration: const BoxDecoration(gradient: gradient),
    );
  }
}
