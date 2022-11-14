
import 'package:NoteProject/db_utils/db_helper.dart';
import 'package:NoteProject/data_objects/folder.dart';
import 'package:NoteProject/ui/third_page.dart';
import 'package:NoteProject/ui_utils/theme_notifier.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'doc_page.dart';
import '../data_objects/document.dart';
import '../data_objects/fav_item.dart';
import '../generated/l10n.dart';

class FolderPage extends StatefulWidget {

  Folder folder;

  FolderPage({required this.folder});


  @override
  _FolderState createState() => _FolderState();

}
class _FolderState extends State<FolderPage> {

  late Folder _folder;
  List<FavoritesItem> list = [];
  bool first  = true;
  S s  = S();
  TextEditingController _title = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    _folder = widget.folder;
    _title.text = _folder.name;
    if(first) {
      first = false;
      getFavs();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: EditableText(controller: _title,
          focusNode: FocusNode(),
          style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColorDark),
          cursorColor: Theme.of(context).primaryColor,
          backgroundCursorColor: Theme.of(context).primaryColor,
        onChanged: (d) async {
          _folder.name = _title.text;
          var date = DateTime.now();
          var formatter = DateFormat('dd.MM.yyyy');
          _folder.date_up = formatter.format(date);
          await DBProvider.db.updateFolder(_folder);
           },
        ),
      ),
      //backgroundColor: Colors.grey[900],
      body: SingleChildScrollView(
        child: ReorderableListView(
          physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
          onReorder: (int start, int current) {
              if (start < current) {
                int end = current - 1;
            Document startItem = _folder.childs[start];
            int i = 0;
            int local = start;
            do {
              _folder.childs[local+1].sorting--;
              _folder.childs[local].sorting++;
              _folder.childs[local] = _folder.childs[++local];
              i++;
            } while (i < end - start);
              _folder.childs[end] = startItem;
          }
          // dragging from bottom to top
          else if (start > current) {
            Document startItem = _folder.childs[start];
            for (int i = start; i > current; i--) {
              _folder.childs[i].sorting--;
              _folder.childs[i-1].sorting++;
              _folder.childs[i] = _folder.childs[i - 1];
            }
            _folder.childs[current] = startItem;
          }
          DBProvider.db.updateSortingFolder(_folder);
          setState(() {});
          },
          children: _folder.childs.map((e) =>
              GestureDetector(
                key: Key("${e.id}"),
            onTap: () async {
              //await Navigator.push(context, MaterialPageRoute(builder: (context) => DocumentPage(document: e)));
              await Navigator.push(context, MaterialPageRoute(builder: (context) => TabsPage(document: e,)));
              setState((){});
            },
            child: Dismissible(
              background: Container(
                color: Colors.blue,
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 8),
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.only(right: 30),
                  child: const Icon(
                    Icons.delete,
                    //: Colors.white,
                  ),
                ),
              ),
              direction: DismissDirection.startToEnd,
              key: UniqueKey(),
              child: Dismissible(
                direction: DismissDirection.endToStart,
                confirmDismiss: (d) async {
                  var f =  await showAccessDocumentDialog(e);
                  return f[0] as bool;
                },
                onDismissed: (d) async {
                  var i = await DBProvider.db.removeFromFavs(e.id);
                  final db = await DBProvider.db.database;
                  await db?.delete("MyDraft",where: "id = ?",whereArgs: [e.id]);
                  _folder.childs.remove(e);
                },
                background: Container(
                  color: Colors.red,
                  margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.only(right: 30),
                    child: const Icon(
                      Icons.delete,
                     // color: Colors.white,
                    ),
                  ),
                ),
                key: UniqueKey(),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  constraints: const BoxConstraints(minHeight: 90,maxHeight: 90),
                  alignment: Alignment.center,
                  child: Card(
                  //  color: Colors.white,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Padding(padding: EdgeInsets.only(left: 20),child: Icon(Icons.description),),
                            Container(
                              width: 270,
                              padding: const EdgeInsets.only(left: 30),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    e.name,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                  Expanded(
                                      child: Text(e.description,maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      )
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        contains(e) ? GestureDetector(
                          onTap: () {
                            DBProvider.db.removeFromFavs(e.id);
                            getFavs();
                          },
                          child: Container(
                            padding: const EdgeInsets.only(right: 20),
                            child: const Icon(Icons.star,color: Colors.amberAccent,),
                          ),
                        )
                            : GestureDetector(
                          onTap: () async {
                            final db = await DBProvider.db.database;
                            var table = await db!.rawQuery("SELECT MAX(id)+1 as id FROM Favorites");
                            int id = table.first["id"]==null ? 0 : table.first["id"] as int;
                            FavoritesItem item =
                            FavoritesItem(id: id, draft_id: e.id, sorting: list.length, idList: 0);
                            DBProvider.db.addToFavs(item);
                            getFavs();
                          },
                          child: Container(
                            padding: const EdgeInsets.only(right: 20),
                            child: const Icon(Icons.star,color: Colors.grey,),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
                ),
            )
          ).toList(),
        ),
      ),
    );
  }
  void getFavs() async {
    var tmp = await DBProvider.db.getFavs();
    setState((){
      list.clear();
      list.addAll(tmp);
    });
  }
  bool contains(Document document) {
    for(int i = 0;i<list.length;i++) {
      if(list[i].draft_id==document.id) return true;
    }
    return false;
  }

  Future showAccessDocumentDialog(Document document) {
    return showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text(s.delete),
        titleTextStyle:
        const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20),
        actionsOverflowButtonSpacing: 20,
        actions: [
          ElevatedButton(onPressed: (){
            Navigator.pop(context,[false]);
          }, child: Text(s.cancel)),
          ElevatedButton(onPressed: (){
            Navigator.pop(context,[true]);
          }, child: Text(s.delete)),
        ],
        content: Text('${s.access_document}"${document.name}?"'),
      );
    });
  }
}
