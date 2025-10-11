import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService extends ChangeNotifier {
  static const String _languageKey = 'selected_language';
  
  Locale _currentLocale = const Locale('zh', 'CN');
  
  Locale get currentLocale => _currentLocale;
  
  static const List<Locale> supportedLocales = [
    Locale('zh', 'CN'), // 中文
    Locale('en', 'US'), // 英文
  ];
  
  static const Map<String, String> languageNames = {
    'zh_CN': '中文',
    'en_US': 'English',
  };
  
  Future<void> loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_languageKey);
    
    if (languageCode != null) {
      final parts = languageCode.split('_');
      if (parts.length == 2) {
        _currentLocale = Locale(parts[0], parts[1]);
        notifyListeners();
      }
    }
  }
  
  Future<void> changeLanguage(Locale locale) async {
    if (supportedLocales.contains(locale)) {
      _currentLocale = locale;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, '${locale.languageCode}_${locale.countryCode}');
      notifyListeners();
    }
  }
  
  String getLanguageName(Locale locale) {
    final key = '${locale.languageCode}_${locale.countryCode}';
    return languageNames[key] ?? locale.languageCode;
  }
}





