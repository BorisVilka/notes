import 'package:NoteProject/data_objects/document.dart';
import 'package:NoteProject/generated/l10n.dart';
import 'package:NoteProject/ui/PersonPage.dart';
import 'package:NoteProject/ui/note_page.dart';
import 'package:NoteProject/ui/notebook_page.dart';
import 'package:NoteProject/ui/pad_page.dart';
import 'package:NoteProject/ui/plot_page.dart';
import 'package:flutter/material.dart';

class TabsPage extends StatelessWidget {
  S s = S();
  Document document;
  TabsPage({required this.document});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      // initialIndex: 1,
      length: 4,
      child: Scaffold(
          bottomNavigationBar: TabBar(
            indicatorColor: Colors.amber,
            tabs: <Widget>[
              Text(s.plot,textAlign: TextAlign.center, maxLines: 1,style: TextStyle(fontSize: 12), ),
              Text(s.characters,textAlign: TextAlign.center,maxLines: 1,style: TextStyle(fontSize: 12),),
              Text(s.notebook,textAlign: TextAlign.center,maxLines: 1,style: TextStyle(fontSize: 12),),
              Text(s.notes,textAlign: TextAlign.center,maxLines: 1,style: TextStyle(fontSize: 12),),
            ],
          ),
          body: TabBarView(
            children: <Widget>[
              PlotPage(document: document),
              PersonPage(document: document),
              NotebookPage(document: document),
              NotePage(document: document,)
            ],
          )
      ),
    );
  }
}