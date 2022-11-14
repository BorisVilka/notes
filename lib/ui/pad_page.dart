


import 'dart:convert';

import 'package:NoteProject/data_objects/Slip.dart';
import 'package:NoteProject/db_utils/db_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:intl/intl.dart';

import '../data_objects/document.dart';

class PadPage extends StatefulWidget {


  Slip document;
  quill.Document? doc;
  PadPage({required this.document, required this.doc});

  @override
  _PageState createState() => _PageState();

}

class _PageState extends State<PadPage> {

  late Slip document;
  bool first = true;
  late quill.QuillController _controller;
  final TextEditingController _title = TextEditingController();


  @override
  void dispose() {
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    document = widget.document;
    _title.text = document.name;
    setState(() {
      var tmp =  quill.QuillController.basic();
      if(widget.doc!=null) {
        _controller = quill.QuillController(document: widget.doc!,
          selection: tmp.selection
        );
      } else {
        _controller = quill.QuillController.basic();
      }
    });
    _controller.addListener(() async {
      document.name = _title.text;
      var date = DateTime.now();
      var formatter = DateFormat('dd.MM.yyyy HH:mm');
      document.date = formatter.format(date);
      document.text = jsonEncode(_controller.document.toDelta().toJson());
      await DBProvider.db.updateSlip(document);
    });
  }

  void save() async {
    document.name = _title.text;
    var date = DateTime.now();
    var formatter = DateFormat('dd.MM.yyyy HH:mm');
    document.date = formatter.format(date);
    document.text = jsonEncode(_controller.document);
    await DBProvider.db.updateSlip(document);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: EditableText(
        controller: _title,
        focusNode: FocusNode(),
        style: TextStyle(fontSize: 18,color: Theme.of(context).primaryColorDark),
        cursorColor: Theme.of(context).primaryColor,
        backgroundCursorColor: Theme.of(context).primaryColor,
        onChanged: (d) async {
          document.name = _title.text;
          var date = DateTime.now();
          var formatter = DateFormat('dd.MM.yyyy HH:mm');
          document.date = formatter.format(date);
          await DBProvider.db.updateSlip(document);
        },
        ),
        actions: [
          IconButton(onPressed: () async {
           _displayFoldersDialog(context);
          }, icon: Icon(Icons.delete_outline))
        ],
        backgroundColor: Colors.amber,
      ),
      body: Column(
        children: [
         Container(
           color: Colors.grey,
           padding: EdgeInsets.all(10),
           child:  quill.QuillToolbar.basic(controller: _controller,
             showAlignmentButtons: true,
             showBackgroundColorButton: false,
             showHeaderStyle: false,
             showSearchButton: false,
             showLink: false,
             showFontFamily: false,
             showListCheck: false,
             showCodeBlock: false,
             showQuote: false,
             showIndent: false,
             showInlineCode: false,
             showClearFormat: false,
           ),
         ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20),
              child: quill.QuillEditor.basic(
                controller: _controller,
                readOnly: false,
              ),
            ),
          )
        ],
      ),
    );
  }



  Future<void> _displayFoldersDialog(BuildContext context) async {
    var name = '';
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Вы уверены, что хотите удалить заметку?'),
            actions: <Widget>[
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                  child: Text('Нет')
              ),
              ElevatedButton(
                  onPressed: () async {
                    await DBProvider.db.removeSlip(document.id);
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                  child: Text('Да')
              ),
            ],
          );
        });
  }
}