
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data_objects/document.dart';
import '../db_utils/db_helper.dart';
import 'doc_page.dart';

class PlotPage extends StatefulWidget {

  Document document;

  PlotPage({required this.document});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PlotState();
  }

}

class PlotState extends State<PlotPage> {

  late Document document;
  final TextEditingController _title = TextEditingController();
  bool first = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    document = widget.document;
    _title.text = document.name;
    return Scaffold(
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
            await DBProvider.db.updateDocument(document!);
          },
        ),
      ),
    );
  }

}