import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class LocalizationService {
  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('ar'),
  ];

  static const String fallbackLocale = 'en';

  static Future<void> initLocalization() async {
    await EasyLocalization.ensureInitialized();
  }

  static Locale getLocaleFromLanguageCode(String languageCode) {
    return Locale(languageCode);
  }

  static String getCurrentLanguage(BuildContext context) {
    return context.locale.languageCode;
  }

  static bool isArabic(BuildContext context) {
    return context.locale.languageCode == 'ar';
  }

  static bool isEnglish(BuildContext context) {
    return context.locale.languageCode == 'en';
  }

  static Future<void> changeLanguage(BuildContext context, String languageCode) async {
    if (supportedLocales.any((locale) => locale.languageCode == languageCode)) {
      await context.setLocale(Locale(languageCode));
    }
  }

  static TextDirection getTextDirection(BuildContext context) {
    return isArabic(context) ? TextDirection.rtl : TextDirection.ltr;
  }
}
