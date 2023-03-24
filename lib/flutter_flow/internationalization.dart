import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kLocaleStorageKey = '__locale_key__';

class FFLocalizations {
  FFLocalizations(this.locale);

  final Locale locale;

  static FFLocalizations of(BuildContext context) =>
      Localizations.of<FFLocalizations>(context, FFLocalizations)!;

  static List<String> languages() => ['en', 'es'];

  static late SharedPreferences _prefs;
  static Future initialize() async =>
      _prefs = await SharedPreferences.getInstance();
  static Future storeLocale(String locale) =>
      _prefs.setString(_kLocaleStorageKey, locale);
  static Locale? getStoredLocale() {
    final locale = _prefs.getString(_kLocaleStorageKey);
    return locale != null && locale.isNotEmpty ? createLocale(locale) : null;
  }

  String get languageCode => locale.toString();
  String? get languageShortCode =>
      _languagesWithShortCode.contains(locale.toString())
          ? '${locale.toString()}_short'
          : null;
  int get languageIndex => languages().contains(languageCode)
      ? languages().indexOf(languageCode)
      : 0;

  String getText(String key) =>
      (kTranslationsMap[key] ?? {})[locale.toString()] ?? '';

  String getVariableText({
    String? enText = '',
    String? esText = '',
  }) =>
      [enText, esText][languageIndex] ?? '';

  static const Set<String> _languagesWithShortCode = {
    'ar',
    'az',
    'ca',
    'cs',
    'da',
    'de',
    'dv',
    'en',
    'es',
    'et',
    'fi',
    'fr',
    'gr',
    'he',
    'hi',
    'hu',
    'it',
    'km',
    'ku',
    'mn',
    'ms',
    'no',
    'pt',
    'ro',
    'ru',
    'rw',
    'sv',
    'th',
    'uk',
    'vi',
  };
}

class FFLocalizationsDelegate extends LocalizationsDelegate<FFLocalizations> {
  const FFLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    final language = locale.toString();
    return FFLocalizations.languages().contains(
      language.endsWith('_')
          ? language.substring(0, language.length - 1)
          : language,
    );
  }

  @override
  Future<FFLocalizations> load(Locale locale) =>
      SynchronousFuture<FFLocalizations>(FFLocalizations(locale));

  @override
  bool shouldReload(FFLocalizationsDelegate old) => false;
}

Locale createLocale(String language) => language.contains('_')
    ? Locale.fromSubtags(
        languageCode: language.split('_').first,
        scriptCode: language.split('_').last,
      )
    : Locale(language);

final kTranslationsMap = <Map<String, Map<String, String>>>[
  // HomePage
  {
    'ywzp11ty': {
      'en': 'Page Title',
      'es': '',
    },
    '17gkisys': {
      'en': 'Home',
      'es': '',
    },
  },
  // EventList
  {
    'x6xgfglx': {
      'en': 'Events',
      'es': '',
    },
    'sg0n9ec4': {
      'en': 'Upcoming events from the groups you follow.',
      'es': '',
    },
    'm7bfeuf8': {
      'en': 'Athletics',
      'es': '',
    },
    'l6szdyen': {
      'en':
          'Task Description here this one is really long and it goes over maybe? And goes to two lines.',
      'es': '',
    },
    'd1q6rzo4': {
      'en': 'Due',
      'es': '',
    },
    'if8lw8cq': {
      'en': 'Today, 5:30pm',
      'es': '',
    },
    '9fhqyeuo': {
      'en': 'Task Type',
      'es': '',
    },
    'ab8llgfw': {
      'en':
          'Task Description here this one is really long and it goes over maybe? And goes to two lines.',
      'es': '',
    },
    'x3ddntsu': {
      'en': 'Due',
      'es': '',
    },
    'noz70g2w': {
      'en': 'Today, 5:30pm',
      'es': '',
    },
    'gunauo5k': {
      'en': 'Page Title',
      'es': '',
    },
    '0qwb30s9': {
      'en': 'Home',
      'es': '',
    },
  },
].reduce((a, b) => a..addAll(b));
