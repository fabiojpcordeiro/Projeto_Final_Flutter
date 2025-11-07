import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(seedColor: Colors.blue);
    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
      ),
    );
  }
}
