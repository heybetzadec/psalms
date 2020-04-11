import 'package:flutter/material.dart';

typedef void LocaleChangeCallback(Locale locale);

class LocaleUtil {
  // Support languages list
  final List<String> supportedLanguages = ['en', 'tr'];

  // Support Locales list
  Iterable<Locale> supportedLocales() =>
      supportedLanguages.map<Locale>((lang) => new Locale(lang, ''));

  // Callback for manual locale changed
  LocaleChangeCallback onLocaleChanged;

  Locale locale;
  String languageCode;

  static final LocaleUtil _localeUtil = new LocaleUtil._internal();

  factory LocaleUtil() {
    return _localeUtil;
  }

  LocaleUtil._internal();

  /// Get the current system language
  String getLanguageCode() {
    if (languageCode == null) {
      return "en";
    }
    return languageCode;
  }
}

LocaleUtil localeUtil = new LocaleUtil();
