import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:psalms/help/locale_util.dart';
import 'package:psalms/help/translations.dart';
import 'package:psalms/tabs/controller/app.dart';

void main() {
  runApp(Main());
}

class Main extends StatefulWidget {
  Main({Key key}) : super(key: key);

  static void setLocale(BuildContext context, Locale newLocale) async {
    _MainState state = context.findAncestorStateOfType<_MainState>();
    state.changeLanguage(newLocale);
  }

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  Locale _locale = Locale('en');

  changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  _MainState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        const TranslationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      locale: _locale,
      supportedLocales: localeUtil.supportedLocales(),
      localeResolutionCallback:
          (Locale locale, Iterable<Locale> supportedLocales) {
        return locale;
      },
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: App(),
    );
  }
}
