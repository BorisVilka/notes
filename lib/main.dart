
import 'package:NoteProject/generated/l10n.dart';
import 'package:NoteProject/ui/home_page.dart';
import 'package:NoteProject/ui_utils/storage_manager.dart';
import 'package:NoteProject/ui_utils/theme_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n/all_locates.dart';
import 'ui_utils/locale_provider.dart';

void main() {
  return runApp(
     ChangeNotifierProvider<LocaleProvider>(
       create: (_) => LocaleProvider(),
       child:  ChangeNotifierProvider<ThemeNotifier>(
         create: (_) => ThemeNotifier(),
         child: MyApp(),
       ),
     )
  );
}

class MyApp extends StatefulWidget {


  @override
  MyAppState createState() => MyAppState();


  static void setLocale(BuildContext context, Locale newLocale) async {
    MyAppState state = context.findAncestorStateOfType<MyAppState>()!;
    state.changeLanguage(newLocale);
  }

}
class MyAppState extends State<MyApp> {


  Locale? _locale;

  changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
      StorageManager.saveData('locale', _locale!.languageCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Consumer<LocaleProvider>(
      builder: (context, prov,_) => Consumer<ThemeNotifier>(
          builder: (context, theme, _) =>
              MaterialApp(
            theme: theme.getTheme(),
            supportedLocales: AllLocale.all,
            locale: prov.locale,
            localizationsDelegates: const [
              AppLocalizationDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            debugShowCheckedModeBanner: false,
            routes: {
              '/': (BuildContext c) => HomePage(notifier1: theme, prov: prov),
            },
          )
      ),
    );
  }
}