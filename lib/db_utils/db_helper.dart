import 'dart:async';
import 'dart:io';

import 'package:NoteProject/data_objects/Slip.dart';
import 'package:NoteProject/data_objects/document.dart';
import 'package:NoteProject/data_objects/note.dart';
import 'package:NoteProject/data_objects/note_object.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../data_objects/fav_item.dart';
import '../data_objects/folder.dart';


class DBProvider {

  DBProvider._();

  static final DBProvider db = DBProvider._();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "TestDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute("CREATE TABLE MyDraft("
              "id INTEGER PRIMARY KEY,"
              "description TEXT,"
              "type INTEGER,"
              "amount INTEGER,"
              "date TEXT,"
              "date_up TEXT,"
              "parent INTEGER,"
              "sorting INTEGER,"
              "name TEXT,"
              "idList INTEGER,"
              "genre TEXT,"
              "history TEXT,"
              "date_d TEXT,"
              "mesto TEXT,"
              "theme TEXT"
              ")"
              );
          await db.execute("CREATE TABLE Favorites("
              "id INTEGER PRIMARY KEY,"
              "id_draft INTEGER,"
              "sorting INTEGER,"
              "idList INTEGER"
              ")");
          await db.execute("CREATE TABLE Notes("
              "id INTEGER PRIMARY KEY,"
              "id_draft INTEGER,"
              "date TEXT,"
              "text TEXT,"
              "file TEXT"
              ")");
          await db.execute("CREATE TABLE Notebook("
              "id INTEGER PRIMARY KEY,"
              "id_draft INTEGER,"
              "date_up TEXT,"
              "text TEXT,"
              "name TEXT,"
              "favorite INT,"
              "sorting INT"
              ")");
        });
  }
  void insert(NoteObject note) async {
    final db = await database;
    db?.insert("MyDraft", note.toJson());
  }
  Future<NoteObject> read(int id) async {
    final db = await database;
    var res = await db?.query("MyDraft", where: "id = ?", whereArgs: [id]);
    return NoteObject.fromJson(res!.first);
  }

  Future<List<NoteObject>?> getAll() async {
    final db = await database;
    var res = await db?.query("MyDraft");
    return List<NoteObject>.from(res!.map((e) => NoteObject.fromJson(e)).toList());
  }
  Future<int> getId() async {
    final db = await database;
    var table = await db!.rawQuery("SELECT MAX(id)+1 as id FROM MyDraft");
    int id = table.first["id"]==null ? 0 : table.first["id"] as int;
    return id;
  }
  Future<List<FavoritesItem>> getFavs() async {
    final db = await database;
    var res = await db?.query("Favorites");
    return List<FavoritesItem>.from(res!.map((e) => FavoritesItem.fromJson(e)).toList());
  }
  Future<int?> removeFromFavs(int id) async {
    final db  = await database;
    return await db?.delete("Favorites", where: "id_draft = ?", whereArgs: [id]);
  }
  void addToFavs(FavoritesItem item) async {
   final db = await database;
   db?.insert("Favorites", item.toJson());
  }
  Future<void> updateSorting(List<Folder> list) async {
    final db = await database;
    for(int i = 0;i<list.length;i++)
    {
      NoteObject tmp = NoteObject(name: list[i].name, description: "", date: list[i].date,
          date_up: list[i].date_up, id: list[i].id, amount: list[i].amount, parent: -1, sorting: list[i].sorting, type: 1,
          genre: '', date_d: '', mesto: '', history: '', theme: '');
      db?.update('MyDraft', tmp.toJson(),where: "id = ? ", whereArgs: [tmp.id]);
    }
  }
  void updateSortingFavs(List<FavoritesItem> list) async {
    final db = await database;
    for(int i = 0;i<list.length;i++)
    {
      db?.update('Favorites', list[i].toJson(),where: "id_draft = ? ", whereArgs: [list[i].draft_id]);
    }
  }
  Future<void> updateSortingFolder(Folder folder) async {
    final db = await database;
    for(int i = 0;i<folder.childs.length;i++)
    {
      NoteObject tmp = NoteObject(name: folder.childs[i].name, description: folder.childs[i].description, date: folder.childs[i].date,
          date_up: folder.childs[i].date_up, id: folder.childs[i].id, amount: -1,
          parent: folder.id, sorting: folder.childs[i].sorting, type: 0, mesto: '', date_d: '', genre: '', theme: '', history: '');
      db?.update('MyDraft', tmp.toJson(),where: "id = ? ", whereArgs: [folder.childs[i].id]);
    }
  }
  Future<void> updateDocument(Document document) async {
    final db = await database;
    NoteObject tmp = NoteObject(name: document.name, description: document.description, date: document.date,
        date_up: document.date_up, id: document.id, amount: -1,
        parent: document.parent, sorting: document.sorting, type: 0,
      genre: document.genre, mesto: document.mesto, date_d: document.date_d,
      history: document.history, theme: document.theme
    );
    db?.update('MyDraft', tmp.toJson(),where: "id = ? ", whereArgs: [document.id]);
  }

  Future<void> updateFolder(Folder document) async {
    final db = await database;
    NoteObject tmp = NoteObject(name: document.name, description: "", date: document.date,
        date_up: document.date_up, id: document.id, amount: -1,
        parent: -1, sorting: document.sorting, type: 1, genre: '', history: '', theme: '', mesto: '', date_d: '');
    db?.update('MyDraft', tmp.toJson(),where: "id = ? ", whereArgs: [document.id]);
  }

  Future<List<Note>> getNotes(int doc_id) async {
    final db = await database;
    var res = await db?.query("Notes", where: "id_draft = ?", whereArgs: [doc_id]);
    return List<Note>.from(res!.map((e) => Note.fromJson(e)).toList());
  }
  void addNote(Note item) async {
    final db = await database;
    db?.insert("Notes", item.toJson());
  }
  Future<int> getIdNote() async {
    final db = await database;
    var table = await db!.rawQuery("SELECT MAX(id)+1 as id FROM Notes");
    int id = table.first["id"]==null ? 0 : table.first["id"] as int;
    return id;
  }
  Future<int?> removeFromNotes(int ids) async {
    final db  = await database;
    return await db?.delete("Notes", where: "id = ?", whereArgs: [ids]);
  }
  void editNote(Note note) async {
    final db = await database;
    await db?.update('Notes', note.toJson(),where: "id = ? ", whereArgs: [note.id]);
  }

  Future<List<Slip>> getSlips(int doc_id) async {
    final db = await database;
    var res = await db?.query("Notebook", where: "id_draft = ?", whereArgs: [doc_id]);
    return List<Slip>.from(res!.map((e) => Slip.fromJson(e)).toList());
  }
  Future<void> updateSlip(Slip document) async {
    final db = await database;
    db?.update('Notebook', document.toJson(),where: "id = ? ", whereArgs: [document.id]);
  }
  Future<int?> removeSlip(int ids) async {
    final db  = await database;
    return await db?.delete("Notebook", where: "id = ?", whereArgs: [ids]);
  }
  void updateSortingSlips(List<Slip> list) async {
    final db = await database;
    for(int i = 0;i<list.length;i++)
    {
      db?.update('Notebook', list[i].toJson(),where: "id = ? ", whereArgs: [list[i].id]);
    }
  }
}