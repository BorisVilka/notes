// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Subscription`
  String get sub {
    return Intl.message(
      'Subscription',
      name: 'sub',
      desc: '',
      args: [],
    );
  }

  /// `Theme`
  String get theme {
    return Intl.message(
      'Theme',
      name: 'theme',
      desc: '',
      args: [],
    );
  }

  /// `Exit`
  String get exit {
    return Intl.message(
      'Exit',
      name: 'exit',
      desc: '',
      args: [],
    );
  }

  /// `Add a folder`
  String get add_a_folder {
    return Intl.message(
      'Add a folder',
      name: 'add_a_folder',
      desc: '',
      args: [],
    );
  }

  /// `Add a document`
  String get add_a_document {
    return Intl.message(
      'Add a document',
      name: 'add_a_document',
      desc: '',
      args: [],
    );
  }

  /// `Folder name`
  String get folder_name {
    return Intl.message(
      'Folder name',
      name: 'folder_name',
      desc: '',
      args: [],
    );
  }

  /// `Document name`
  String get document_name {
    return Intl.message(
      'Document name',
      name: 'document_name',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get description {
    return Intl.message(
      'Description',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message(
      'Add',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Do you really want to delete the folder `
  String get access_folder {
    return Intl.message(
      'Do you really want to delete the folder ',
      name: 'access_folder',
      desc: '',
      args: [],
    );
  }

  /// `Do you really want to delete the document `
  String get access_document {
    return Intl.message(
      'Do you really want to delete the document ',
      name: 'access_document',
      desc: '',
      args: [],
    );
  }

  /// `Enter the text`
  String get enter_the_text {
    return Intl.message(
      'Enter the text',
      name: 'enter_the_text',
      desc: '',
      args: [],
    );
  }

  /// `Notes`
  String get notes {
    return Intl.message(
      'Notes',
      name: 'notes',
      desc: '',
      args: [],
    );
  }

  /// `Notebook`
  String get notebook {
    return Intl.message(
      'Notebook',
      name: 'notebook',
      desc: '',
      args: [],
    );
  }

  /// `Plot`
  String get plot {
    return Intl.message(
      'Plot',
      name: 'plot',
      desc: '',
      args: [],
    );
  }

  /// `Characters`
  String get characters {
    return Intl.message(
      'Characters',
      name: 'characters',
      desc: '',
      args: [],
    );
  }

  /// `Note`
  String get note {
    return Intl.message(
      'Note',
      name: 'note',
      desc: '',
      args: [],
    );
  }

  /// `Add a note`
  String get add_note {
    return Intl.message(
      'Add a note',
      name: 'add_note',
      desc: '',
      args: [],
    );
  }

  /// `Note name`
  String get note_name {
    return Intl.message(
      'Note name',
      name: 'note_name',
      desc: '',
      args: [],
    );
  }

  /// `Annotation`
  String get annotation {
    return Intl.message(
      'Annotation',
      name: 'annotation',
      desc: '',
      args: [],
    );
  }

  /// `Sorting`
  String get sort {
    return Intl.message(
      'Sorting',
      name: 'sort',
      desc: '',
      args: [],
    );
  }

  /// `Genre`
  String get genre {
    return Intl.message(
      'Genre',
      name: 'genre',
      desc: '',
      args: [],
    );
  }

  /// `History of the world`
  String get history {
    return Intl.message(
      'History of the world',
      name: 'history',
      desc: '',
      args: [],
    );
  }

  /// `Time of action`
  String get date_d {
    return Intl.message(
      'Time of action',
      name: 'date_d',
      desc: '',
      args: [],
    );
  }

  /// `Place of action`
  String get mesto {
    return Intl.message(
      'Place of action',
      name: 'mesto',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
