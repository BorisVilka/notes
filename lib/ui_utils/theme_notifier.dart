import 'package:flutter/material.dart';
import 'storage_manager.dart';

class ThemeNotifier with ChangeNotifier {

  final darkTheme = ThemeData(
    primarySwatch: Colors.grey,
    primaryColor: Colors.black,
    primaryColorDark: Colors.white,
    brightness: Brightness.dark,
    backgroundColor: const Color(0xFF212121),
    dividerColor: Colors.black12,
  );

  final lightTheme = ThemeData(
    primarySwatch: Colors.grey,
    primaryColor: Colors.white,
    primaryColorDark: Colors.black,
    brightness: Brightness.light,
    backgroundColor: const Color(0xFFE5E5E5),
    dividerColor: Colors.white54,
  );

  ThemeData _themeData = ThemeData.light();
  ThemeData getTheme() => _themeData;

  bool _isDark = false;
  bool isDark() => _isDark;

  ThemeNotifier() {
    StorageManager.readData('themeMode').then((value) {
      print('value read from storage: ' + value.toString());
      var themeMode = value ?? 'light';
      if (themeMode == 'light') {
        _themeData = lightTheme;
        _isDark = false;
      } else {
        print('setting dark theme');
        _themeData = darkTheme;
        _isDark = true;
      }
      notifyListeners();
    }
    );
  }

  void setDarkMode() async {
    _themeData = darkTheme;
    _isDark = true;
    StorageManager.saveData('themeMode', 'dark');
    notifyListeners();
  }

  void setLightMode() async {
    _themeData = lightTheme;
    _isDark = false;
    StorageManager.saveData('themeMode', 'light');
    notifyListeners();
  }
}