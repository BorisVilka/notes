
import 'dart:convert';

import 'package:NoteProject/data_objects/document.dart';
import 'package:NoteProject/ui/doc_page.dart';
import 'package:NoteProject/ui/pad_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:intl/intl.dart';

import '../data_objects/Slip.dart';
import '../db_utils/db_helper.dart';
import '../generated/l10n.dart';

class NotebookPage extends StatefulWidget {

  Document document;

  NotebookPage({required this.document});

  @override
  NotebookState createState() => NotebookState();

}

class NotebookState extends State<NotebookPage> {

  late Document document;
  List<Slip> data = [];
  List<Slip> favs = [];
  bool first = true;
  final TextEditingController _title = TextEditingController();

  @override
  Widget build(BuildContext context) {
    document = widget.document;
    _title.text = document.name;
    if(first) {
      getData();
      first = false;
    }
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //_displayFoldersDialog(context);
          final db = await DBProvider.db.database;
          var table = await db!.rawQuery("SELECT MAX(id)+1 as id FROM Notebook");
          var date = DateTime.now();
          var formatter = DateFormat('dd.MM.yyyy HH:mm');
          int id = table.first["id"]==null ? 0 : table.first["id"] as int;
          var note = Slip(
              id: id, id_draft: document.id,
              name: "Заметка", text: "",date: formatter.format(date),
            favs: 0, sort: 0
          );
          await db.insert("Notebook", note.toJson());
          await Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PadPage(document: note,doc: null,)));
          getData();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
      appBar: AppBar(
         backgroundColor: Colors.amber,
        actions: [
          GestureDetector(
            onTap: () async {
             await Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DocumentPage(document: document)));
             setState(() {});
            },
            child: Container(
              padding: EdgeInsets.only(right: 20),
              child: Icon(Icons.settings),
            ),
          )
        ],
        title: EditableText(
          controller: _title,
          focusNode: FocusNode(),
          style: TextStyle(fontSize: 18,color: Theme.of(context).primaryColorDark),
          cursorColor: Theme.of(context).primaryColor,
          backgroundCursorColor: Theme.of(context).primaryColor,
          onChanged: (d) async {
            document.name = _title.text;
            var date = DateTime.now();
            var formatter = DateFormat('dd.MM.yyyy');
            document.date_up = formatter.format(date);
            await DBProvider.db.updateDocument(document);
          },
        ),
      ),
      body: SingleChildScrollView(

        child: Column(
          children: [
            ReorderableListView(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              proxyDecorator: (w,i,a) {
                return w;
              },
              onReorder: (int start, int current) {
                if (start < current) {
                  int end = current - 1;
                  Slip startItem = favs[start];
                  int i = 0;
                  int local = start;
                  do {
                    favs[local+1].sort--;
                    favs[local].sort++;
                    favs[local] = favs[++local];
                    i++;
                  } while (i < end - start);
                  favs[end] = startItem;
                }
                // dragging from bottom to top
                else if (start > current) {
                  Slip startItem = favs[start];
                  for (int i = start; i > current; i--) {
                    favs[i].sort--;
                    favs[i-1].sort++;
                    favs[i] = favs[i - 1];
                  }
                  favs[current] = startItem;
                }
                DBProvider.db.updateSortingSlips(favs);
                setState(() {});
              },
              children: favs.map((e) {
                var s = "";
                quill.Document? doc;
                try {
                  doc = quill.Document.fromJson(jsonDecode(e.text));
                  s = doc.toPlainText();
                } on FormatException {

                }
                //print(doc+" | "+data[ind].name);
                return GestureDetector(
                  key: UniqueKey(),
                  onTap: () async {
                    await Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PadPage(document: e, doc: doc)));
                    getData();
                    setState(() {});
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 2,horizontal: 10),
                    child: Card(
                      elevation: 1,
                      child: Container(
                        padding: EdgeInsets.all(15),
                        constraints: BoxConstraints(minHeight: 100),
                        child: Stack(
                          fit: StackFit.passthrough,
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(e.name,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(s,
                                    maxLines: 2,
                                    style: TextStyle(
                                        overflow: TextOverflow.ellipsis
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment.bottomRight,
                              child: Text(e.date),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: GestureDetector(
                                onTap: () async {
                                  final tmp = e;
                                  tmp.favs = 0; tmp.sort = 0;
                                  await DBProvider.db.updateSlip(tmp);
                                  getData();
                                  setState(() {

                                  });
                                },
                                child: Icon(Icons.push_pin),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            ListView(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              children: data.map((e) {
                var s = "";
                quill.Document? doc;
                try {
                  doc = quill.Document.fromJson(jsonDecode(e.text));
                  s = doc.toPlainText();
                } on FormatException {

                }
                //print(doc+" | "+data[ind].name);
                return Container(
                  key: UniqueKey(),
                  padding: EdgeInsets.symmetric(vertical: 2,horizontal: 10),
                  child: GestureDetector(
                    onTap: () async {
                      await Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PadPage(document: e, doc: doc)));
                      getData();
                      setState(() {});
                    },
                    child: Card(
                      elevation: 1,
                      child: Container(
                        padding: EdgeInsets.all(15),
                        constraints: BoxConstraints(minHeight: 100),
                        child: Stack(
                          fit: StackFit.passthrough,
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: GestureDetector(
                                onTap: () async {
                                  final tmp = e;
                                  tmp.favs = 1; tmp.sort = favs.length;
                                  await DBProvider.db.updateSlip(tmp);
                                  getData();
                                  setState(() {

                                  });
                                },
                                child: Icon(Icons.push_pin_outlined),
                              ),
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(e.name,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(s,
                                    maxLines: 2,
                                    style: TextStyle(
                                        overflow: TextOverflow.ellipsis
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment.bottomRight,
                              child: Text(e.date),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      )
    );
  }

  void getData() async {
    var tmp = await DBProvider.db.getSlips(document.id);
    setState(() {
      data.clear();
      favs.clear();
      for(Slip i in tmp) {
        if(i.favs==1) favs.add(i);
        else data.add(i);
      }
      var formatter = DateFormat('dd.MM.yyyy HH:mm');
      data.sort((s1,s2){
        var date1 = formatter.parse(s1.date);
        var date2 = formatter.parse(s2.date);
        return date2.compareTo(date1);
      });
      favs.sort((s1,s2){
        return s1.sort.compareTo(s2.sort);
      });
    });
    var note = await DBProvider.db.read(document.id);
    setState(() {
      document = Document(name: note.name, sorting: note.sorting,
        parent: note.parent, date_up: note.date_up, date: note.date, description: note.description, id: note.id,
        genre: note.genre, date_d: note.date_d, mesto: note.mesto, history: note.history, theme: note.theme,
      );
    });
  }

  S s = S();
  final TextEditingController _folders_conrtl = TextEditingController();
  Future<void> _displayFoldersDialog(BuildContext context) async {
    var name = '';
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(s.add_note),
            content: TextField(
              onChanged: (value) {
                setState((){
                  name = value;
                  print(_folders_conrtl.text+" "+name);
                });
              },
              controller: _folders_conrtl,
              decoration: InputDecoration(hintText: s.note_name),
            ),
            actions: <Widget>[
              ElevatedButton(
                  onPressed: () {
                    _folders_conrtl.text = '';
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                  child: Text(s.cancel)
              ),
              ElevatedButton(
                  onPressed: () async {
                    final db = await DBProvider.db.database;
                    var table = await db!.rawQuery("SELECT MAX(id)+1 as id FROM Notebook");
                    var date1 = DateTime.now();
                    var formatter1 = DateFormat('dd.MM.yyyy HH:mm');
                    int id = table.first["id"]==null ? 0 : table.first["id"] as int;
                    var note = Slip(
                      id: id, id_draft: document.id,
                      name: _folders_conrtl.text, text: "",date: formatter1.format(date1),
                      favs: 0, sort: 0
                    );
                    await db.insert("Notebook", note.toJson());
                    _folders_conrtl.text = '';
                    getData();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                  child: Text(s.add)
              ),
            ],
          );
        });
  }

}