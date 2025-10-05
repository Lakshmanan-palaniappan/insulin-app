import 'package:flutter/material.dart';
import 'package:insulin/services/local_database_services.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  final LocalDatabaseServices _localDatabaseServices = LocalDatabaseServices();

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _saveThemeToPrefs();
    notifyListeners();
  }

  Future<void> loadThemeFromPrefs() async {
    final isDarkMode = await _localDatabaseServices.getThemeMode();
    _isDarkMode = isDarkMode;
    notifyListeners();
  }

  void _saveThemeToPrefs() async {
    await _localDatabaseServices.setThemeMode(_isDarkMode);
  }
}
