import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  Color _primaryColor = const Color(0xFF667EEA);
  Color _accentColor = const Color(0xFF764BA2);
  String _projectName = '未命名主题';
  int _currentIndex = 0;
  
  Color get primaryColor => _primaryColor;
  Color get accentColor => _accentColor;
  String get projectName => _projectName;
  int get currentIndex => _currentIndex;

  void setPrimaryColor(Color color) {
    _primaryColor = color;
    notifyListeners();
  }

  void setAccentColor(Color color) {
    _accentColor = color;
    notifyListeners();
  }

  void setProjectName(String name) {
    _projectName = name;
    notifyListeners();
  }

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  List<Color> get gradientColors => [_primaryColor, _accentColor];
}
