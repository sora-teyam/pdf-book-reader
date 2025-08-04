import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  final SharedPreferences _prefs;
  
  SettingsProvider(this._prefs) {
    _loadSettings();
  }

  // Язык
  Locale? _locale;
  Locale? get locale => _locale;

  // Тема
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  // Настройки чтения
  double _fontSize = 16.0;
  double get fontSize => _fontSize;

  double _brightness = 1.0;
  double get brightness => _brightness;

  bool _keepScreenOn = true;
  bool get keepScreenOn => _keepScreenOn;

  // Сортировка
  BookSortType _sortType = BookSortType.dateAdded;
  BookSortType get sortType => _sortType;

  bool _sortAscending = false;
  bool get sortAscending => _sortAscending;

  void _loadSettings() {
    // Загрузка языка
    final languageCode = _prefs.getString('language_code');
    final countryCode = _prefs.getString('country_code');
    if (languageCode != null) {
      _locale = Locale(languageCode, countryCode);
    } else {
      // Автоопределение языка системы
      final systemLocale = PlatformDispatcher.instance.locale;
      final supportedLanguages = ['en', 'ru', 'sk', 'uk'];
      
      if (supportedLanguages.contains(systemLocale.languageCode)) {
        _locale = Locale(systemLocale.languageCode);
      } else {
        _locale = const Locale('en'); // Английский по умолчанию
      }
    }

    // Загрузка темы
    final themeIndex = _prefs.getInt('theme_mode') ?? 0;
    _themeMode = ThemeMode.values[themeIndex];

    // Загрузка настроек чтения
    _fontSize = (_prefs.getDouble('font_size') ?? 16.0).clamp(12.0, 24.0);
    _brightness = (_prefs.getDouble('brightness') ?? 1.0).clamp(0.3, 1.0);
    _keepScreenOn = _prefs.getBool('keep_screen_on') ?? true;

    // Загрузка сортировки
    final sortIndex = _prefs.getInt('sort_type') ?? 0;
    _sortType = BookSortType.values[sortIndex];
    _sortAscending = _prefs.getBool('sort_ascending') ?? false;

    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    await _prefs.setString('language_code', locale.languageCode);
    if (locale.countryCode != null) {
      await _prefs.setString('country_code', locale.countryCode!);
    }
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    _themeMode = themeMode;
    await _prefs.setInt('theme_mode', themeMode.index);
    notifyListeners();
  }

  Future<void> setFontSize(double fontSize) async {
    _fontSize = fontSize.clamp(12.0, 24.0); // Ограничиваем диапазон
    await _prefs.setDouble('font_size', _fontSize);
    notifyListeners();
  }

  Future<void> setBrightness(double brightness) async {
    _brightness = brightness.clamp(0.3, 1.0); // Ограничиваем диапазон
    await _prefs.setDouble('brightness', _brightness);
    notifyListeners();
  }

  Future<void> setKeepScreenOn(bool keepScreenOn) async {
    _keepScreenOn = keepScreenOn;
    await _prefs.setBool('keep_screen_on', keepScreenOn);
    notifyListeners();
  }

  Future<void> setSortType(BookSortType sortType) async {
    _sortType = sortType;
    await _prefs.setInt('sort_type', sortType.index);
    notifyListeners();
  }

  Future<void> setSortAscending(bool ascending) async {
    _sortAscending = ascending;
    await _prefs.setBool('sort_ascending', ascending);
    notifyListeners();
  }

  // Поддерживаемые языки
  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('ru'),
    Locale('sk'),
    Locale('uk'),
  ];

  static const Map<String, String> languageNames = {
    'en': 'English',
    'ru': 'Русский',
    'sk': 'Slovenčina',
    'uk': 'Українська',
  };
}

enum BookSortType {
  name,
  dateAdded,
  progress,
}