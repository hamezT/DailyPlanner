import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;
  Color _bottomNavBarColor = Colors.blueAccent; // Default color for Bottom Navigation Bar
  String _selectedFont = 'Arial'; // Default font

  bool get isDarkMode => _isDarkMode;
  Color get bottomNavBarColor => _bottomNavBarColor;
  String get selectedFont => _selectedFont;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void updateBottomNavBarColor(Color newColor) {
    _bottomNavBarColor = newColor;
    notifyListeners(); // Notify listeners to update
  }

  void updateSelectedFont(String newFont) {
    _selectedFont = newFont;
    notifyListeners(); // Notify listeners to update
  }
}
