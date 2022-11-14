
import 'package:boardview/board_item.dart';
import 'package:boardview/board_list.dart';
import 'package:boardview/boardview.dart';
import 'package:boardview/boardview_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../db_utils/db_helper.dart';
import 'doc_page.dart';
import '../data_objects/document.dart';
import '../data_objects/fav_item.dart';
import '../data_objects/folder.dart';
import 'folder_page.dart';
import '../data_objects/note_object.dart';

class BoardPage extends StatefulWidget {

  @override
  BoardState createState() => BoardState();

}
class BoardState extends State<BoardPage> {

  List<NoteObject> data = [];
  List<Folder> folders = [];
  List<Document> favorites = [];
  List<FavoritesItem> list = [];
  Map<int, Folder> map = {};
  Map<int, Document> docs = {};
  BoardViewController controller = BoardViewController();


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if(folders.isEmpty) {
      print(" DATA");
      getData();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('Канбан'),
      ),
      body: BoardView(
        boardViewController: controller,
        lists: ((folders.isNotEmpty) ? getList() : []),
      ),
    );
  }

  List<BoardList> getList() {
    List<BoardList> tmp = [];
    for(int i = 0;i<folders.length;i++) {
      tmp.add(
          BoardList(
        onStartDragList: (listIndex) {

        },
        onTapList: (listIndex) async {
          await Navigator.push(context, MaterialPageRoute(builder: (context)=>FolderPage(folder: folders[listIndex!])));
          getData();
        },
        onDropList: (listIndex, oldListIndex) async {
          Folder doc = folders[oldListIndex!];
          doc.sorting = listIndex!;
          for(int j = oldListIndex;j<listIndex;j++) {
            if(j==oldListIndex) continue;
            Folder doc1 = folders[j];
            doc1.sorting-=1;
            folders[j] = doc1;
           // print('${folders[listIndex].childs[j].sorting} ${folders[listIndex].childs[j].name}');
          }
          //print('${folders[listIndex].childs[itemIndex].sorting} ${folders[listIndex].childs[itemIndex].name}');
          for(int j = listIndex;j<oldListIndex;j++) {
            if(j==oldListIndex) continue;
            Folder doc1 = folders[j];
            doc1.sorting+=1;
            folders[j] = doc1;
            //print('${folders[listIndex].childs[j].sorting} ${folders[listIndex].childs[j].name}');
          }
          for(int j = listIndex;j>oldListIndex;j--) {
            if(j==oldListIndex) continue;
            Folder doc1 = folders[j];
            doc1.sorting-=1;
            folders[j] = doc1;
            //print('${folders[listIndex].childs[j].sorting} ${folders[listIndex].childs[j].name}');
          }
          folders.sort((f1,f2) {
            return f1.sorting-f2.sorting;
          });
          await DBProvider.db.updateSorting(folders);
        },
        headerBackgroundColor: Colors.amber,
        backgroundColor: Theme.of(context).primaryColorDark,
        header: [
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    folders[i].name,
                    style: const TextStyle(fontSize: 20),
                  ))),
        ],
        items: getItems(folders[i].childs),
        )
      );
    }
    return tmp;
  }

  List<BoardItem> getItems(List<Document> list) {
    List<BoardItem> tmp = [];
    for(int i = 0;i<list.length;i++) {
      tmp.add(
          BoardItem(
              onStartDragItem: (listIndex, itemIndex, state) {

              },
              onDropItem: (listIndex, itemIndex, oldListIndex,
                  oldItemIndex, state) async {
                print("drop item");
                print('${folders[listIndex!].id} ${folders[oldListIndex!].id}');
                if(listIndex!=oldListIndex) {
                  Document doc = folders[oldListIndex].childs[oldItemIndex!];
                  folders[oldListIndex].childs.remove(doc);
                  doc.parent = folders[listIndex].id;
                  doc.sorting = itemIndex!;
                  folders[listIndex].childs.insert(itemIndex, doc);
                  for(int j = itemIndex+1;j<folders[listIndex].childs.length;j++) {
                    folders[listIndex].childs[j].sorting++;
                  }
                  for(int j = oldItemIndex;j<folders[oldListIndex].childs.length;j++) {
                    folders[oldListIndex].childs[j].sorting--;
                  }
                  print(folders[listIndex].childs.length);
                  await DBProvider.db.updateSortingFolder(folders[oldListIndex]);
                  await DBProvider.db.updateSortingFolder(folders[listIndex]);
                } else {
                  if(itemIndex==oldItemIndex) return;
                  print('${itemIndex!} ${oldItemIndex!}');
                  Document doc = folders[oldListIndex].childs[oldItemIndex];
                  doc.sorting = itemIndex;
                  for(int j = oldItemIndex;j<itemIndex;j++) {
                    if(j==oldItemIndex) continue;
                    Document doc = folders[listIndex].childs[j];
                    doc.sorting-=1;
                    folders[listIndex].childs[j] = doc;
                    print('${folders[listIndex].childs[j].sorting} ${folders[listIndex].childs[j].name}');
                  }
                  print('${folders[listIndex].childs[itemIndex].sorting} ${folders[listIndex].childs[itemIndex].name}');
                  for(int j = itemIndex;j<oldItemIndex;j++) {
                    if(j==oldItemIndex) continue;
                    Document doc = folders[listIndex].childs[j];
                    doc.sorting+=1;
                    folders[listIndex].childs[j] = doc;
                    print('${folders[listIndex].childs[j].sorting} ${folders[listIndex].childs[j].name}');
                  }
                  for(int j = itemIndex;j>oldItemIndex;j--) {
                    if(j==oldItemIndex) continue;
                    Document doc = folders[listIndex].childs[j];
                    doc.sorting-=1;
                    folders[listIndex].childs[j] = doc;
                    print('${folders[listIndex].childs[j].sorting} ${folders[listIndex].childs[j].name}');
                  }
                  for(int j = 0;j<folders.length;j++) {
                    folders[j].childs.sort((d1,d2){
                      return d1.sorting-d2.sorting;
                    });
                  }
                  await DBProvider.db.updateSortingFolder(folders[oldListIndex]);
                }
              },
              onTapItem: (listIndex, itemIndex, state) async {
                await Navigator.push(context, MaterialPageRoute(builder: (context) => DocumentPage(document: folders[listIndex!].childs[itemIndex!])));
                print('return');
                getData();
              },
              item: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:Container(
                    width: 270,
                    height: 50,
                    padding: const EdgeInsets.only(left: 30),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          list[i].name,
                          style: const TextStyle(fontSize: 20),
                        ),
                        Expanded(
                            child: Text(list[i].description,
                              maxLines: 3,
                              style: TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            )
                        )
                      ],
                    ),
                  )
                ),
              )
          )
      );
    }
    return tmp;
  }


  void getData() async {
    final tmp =  await DBProvider.db.getAll() ?? [];
    map.clear();
    docs.clear();
    for(int i = 0;i<tmp.length;i++) {
      NoteObject note = tmp[i];
      print('|||| ${note.name} ${note.parent} ${note.amount} ${note.type} ${note.sorting}');
      if(note.type==1) {
        Folder folder = Folder(id: note.id, date: note.date,
            date_up: note.date_up, sorting: note.sorting, name: note.name, amount: note.amount, childs: []);
        map[folder.id] = folder;
      } else {
        Document document = Document(name: note.name, sorting: note.sorting,
            parent: note.parent, date_up: note.date_up, date: note.date, description: note.description, id: note.id,
          genre: note.genre, date_d: note.date_d, mesto: note.mesto, history: note.history, theme: note.theme,
        );
        docs[document.id] = document;
        map[document.parent]?.childs.add(document);
        print(map[document.parent]?.childs.length);
      }
    }
    setState(() {
      folders = [];
      folders.clear();
      folders.addAll(map.entries.map((e) => e.value).toList());
      folders.sort((f1,f2) {
        return f1.sorting-f2.sorting;
      });
      for(int i = 0;i<folders.length;i++) {
        folders[i].childs.sort((d1,d2){
          return d1.sorting-d2.sorting;
        });
      }
    });
    print((folders==null));
  }
}