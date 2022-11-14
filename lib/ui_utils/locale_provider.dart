
import 'package:NoteProject/l10n/all_locates.dart';
import 'package:NoteProject/ui_utils/storage_manager.dart';
import 'package:flutter/cupertino.dart';

class LocaleProvider with ChangeNotifier {
  Locale _locale = const Locale('ru');
  Locale get locale => _locale;
  void setLocale(Locale locale) {
    if (!AllLocale.all.contains(locale)) return;
    _locale = locale;
    StorageManager.saveData('locale', _locale.languageCode);
    notifyListeners();
  }
  LocaleProvider() {
    StorageManager.readData('locale').then((value) {
       _locale = Locale(value ?? 'ru');
        setLocale(_locale);
        notifyListeners();
      }
    );
  }

}