import 'package:flutter/material.dart';
import '../services/settings_service.dart';
import '../services/service_locator.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('zh'); // 设置默认值
  final ISettingsService _settingsService = getIt<ISettingsService>();

  LocaleProvider() {
    _initLocale();
  }

  Future<void> _initLocale() async {
    try {
      final savedLanguage = await _settingsService.getLanguage();
      _locale = Locale(savedLanguage);
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading language settings: $e');
      // 保持默认值 'zh'
    }
  }

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }
}
