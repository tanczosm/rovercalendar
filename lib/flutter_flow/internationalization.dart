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
    'px4xz5rh': {
      'en': 'Events',
      'es': '',
    },
    '89938v1p': {
      'en': 'Upcoming events from the groups you follow.',
      'es': '',
    },
    '89bud7w5': {
      'en': 'Athletics',
      'es': '',
    },
    '4dibv8rq': {
      'en':
          'Task Description here this one is really long and it goes over maybe? And goes to two lines.',
      'es': '',
    },
    'hmcbi2yi': {
      'en': 'Due',
      'es': '',
    },
    '892oc98g': {
      'en': 'Today, 5:30pm',
      'es': '',
    },
    'bhf1fxm4': {
      'en': 'Task Type',
      'es': '',
    },
    'kh70cagx': {
      'en':
          'Task Description here this one is really long and it goes over maybe? And goes to two lines.',
      'es': '',
    },
    'ihsznmlc': {
      'en': 'Due',
      'es': '',
    },
    'pjojkhl7': {
      'en': 'Today, 5:30pm',
      'es': '',
    },
    '7t6rmpzu': {
      'en': 'Page Title',
      'es': '',
    },
    'q2lurmhw': {
      'en': 'Home',
      'es': '',
    },
  },
].reduce((a, b) => a..addAll(b));
