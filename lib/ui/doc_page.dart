
import 'package:NoteProject/db_utils/db_helper.dart';
import 'package:NoteProject/data_objects/document.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../generated/l10n.dart';

class DocumentPage extends StatefulWidget {

  Document document;
  DocumentPage({required this.document});

  @override
  _DocumentState createState() => _DocumentState();

}
class _DocumentState extends State<DocumentPage> {

 Document? document;

  final TextEditingController _controller = TextEditingController();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _theme = TextEditingController();
  final TextEditingController _mesto = TextEditingController();
  final TextEditingController _time = TextEditingController();
  final TextEditingController _history = TextEditingController();
  final TextEditingController _genre = TextEditingController();
  S s = S();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    document ??= widget.document;
    _title.text = document!.name;
    _controller.text = document!.description;
    _theme.text = document!.theme;
    _mesto.text = document!.mesto;
    _time.text = document!.date_d;
    _history.text = document!.history;
    _genre.text = document!.genre;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: EditableText(
          controller: _title,
          focusNode: FocusNode(),
          style: TextStyle(fontSize: 18,color: Theme.of(context).primaryColorDark),
          cursorColor: Theme.of(context).primaryColor,
          backgroundCursorColor: Theme.of(context).primaryColor,
        onChanged: (d) async {
          document!.name = _title.text;
          var date = DateTime.now();
          var formatter = DateFormat('dd.MM.yyyy');
          document!.date_up = formatter.format(date);
          await DBProvider.db.updateDocument(document!);
          },
        ),
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: TextField(
                  decoration: InputDecoration(hintText: s.enter_the_text,
                    label: Text(s.annotation,style: TextStyle(color: Colors.amber),)),
                   keyboardType: TextInputType.multiline,
                  maxLines: null,
                  minLines: 3,
                  autofocus: true,
                  controller: _controller,
                  onChanged: (value) async {
                    document!.description = _controller.text;
                    var date = DateTime.now();
                    var formatter = DateFormat('dd.MM.yyyy');
                    document!.date_up = formatter.format(date);
                    await DBProvider.db.updateDocument(document!);
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 20),
                child: TextField(
                  decoration: InputDecoration(hintText: s.enter_the_text,
                      label: Text(s.theme,style: TextStyle(color: Colors.amber),)),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  minLines: 1,
                  autofocus: true,
                  controller: _theme,
                  onChanged: (value) async {
                    document!.theme = _theme.text;
                    var date = DateTime.now();
                    var formatter = DateFormat('dd.MM.yyyy');
                    document!.date_up = formatter.format(date);
                    await DBProvider.db.updateDocument(document!);
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 20),
                child: TextField(
                  decoration: InputDecoration(hintText: s.enter_the_text,
                      label: Text(s.mesto,style: TextStyle(color: Colors.amber),)),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  minLines: 1,
                  autofocus: true,
                  controller: _mesto,
                  onChanged: (value) async {
                    document!.mesto = _mesto.text;
                    var date = DateTime.now();
                    var formatter = DateFormat('dd.MM.yyyy');
                    document!.date_up = formatter.format(date);
                    await DBProvider.db.updateDocument(document!);
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 20),
                child: TextField(
                  decoration: InputDecoration(hintText: s.enter_the_text,
                      label: Text(s.date_d,style: TextStyle(color: Colors.amber),)),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  minLines: 1,
                  autofocus: true,
                  controller: _time,
                  onChanged: (value) async {
                    document!.date_d = _time.text;
                    var date = DateTime.now();
                    var formatter = DateFormat('dd.MM.yyyy');
                    document!.date_up = formatter.format(date);
                    await DBProvider.db.updateDocument(document!);
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 20),
                child: TextField(
                  decoration: InputDecoration(hintText: s.enter_the_text,
                      label: Text(s.history,style: TextStyle(color: Colors.amber),)),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  minLines: 1,
                  autofocus: true,
                  controller: _history,
                  onChanged: (value) async {
                    document!.history = _history.text;
                    var date = DateTime.now();
                    var formatter = DateFormat('dd.MM.yyyy');
                    document!.date_up = formatter.format(date);
                    await DBProvider.db.updateDocument(document!);
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 20),
                child: TextField(
                  decoration: InputDecoration(hintText: s.enter_the_text,
                      label: Text(s.genre,style: TextStyle(color: Colors.amber),)),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  minLines: 1,
                  autofocus: true,
                  controller: _genre,
                  onChanged: (value) async {
                    document!.genre = _genre.text;
                    var date = DateTime.now();
                    var formatter = DateFormat('dd.MM.yyyy');
                    document!.date_up = formatter.format(date);
                    await DBProvider.db.updateDocument(document!);
                  },
                ),
              ),
            ],
          ),
        ),
    );
  }

}