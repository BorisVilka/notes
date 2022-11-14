
import 'package:NoteProject/ui/board_page.dart';
import 'package:NoteProject/db_utils/db_helper.dart';
import 'package:NoteProject/ui/doc_page.dart';
import 'package:NoteProject/data_objects/document.dart';
import 'package:NoteProject/ui/folder_page.dart';
import 'package:NoteProject/generated/l10n.dart';
import 'package:NoteProject/l10n/all_locates.dart';
import 'package:NoteProject/ui/third_page.dart';
import 'package:NoteProject/ui_utils/locale_provider.dart';
import 'package:NoteProject/main.dart';
import 'package:NoteProject/ui_utils/theme_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';
import '../data_objects/fav_item.dart';
import '../data_objects/folder.dart';
import '../data_objects/note_object.dart';
import 'dart:ui' as ui;


class HomePage extends StatefulWidget {

  ThemeNotifier? notifier;
  LocaleProvider? prov1;

  HomePage({Key? key, required ThemeNotifier notifier1, required LocaleProvider prov}) : super(key: key) {
    notifier = notifier1;
    prov1 = prov;
  }

  @override
  _HomeState createState() => _HomeState(notifier2: notifier!, prov2: prov1!);

}
class _HomeState extends State<HomePage> {

  List<NoteObject> data = [];
  List<Folder> folders = [];
  List<Document> favorites = [];
  List<FavoritesItem> list = [];
  Map<int, Folder> map = {};
  Map<int, Document> docs = {};
  bool first = true;
  bool _switch = true;
  S s = S();
  LocaleProvider? provider;
  ThemeNotifier? notifier;

  _HomeState({required ThemeNotifier notifier2, required LocaleProvider prov2}) {
    notifier = notifier2;
    provider = prov2;
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    _switch = notifier!.isDark();
    if(first) {
      first = false;
      getData();
      getFavs();
    }
    return Scaffold(
      key: _scaffoldKey,
       bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              IconButton(icon: const Icon(Icons.menu), onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },),
              IconButton(icon: const Icon(Icons.search), onPressed: () {},),
            ],
          ),
        ),
      drawer: Drawer(
        child: Container(
          padding: const EdgeInsets.only(top: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: InkWell(
                        highlightColor: Colors.red,
                        splashColor: Colors.red,
                        hoverColor: Colors.red,
                        onTap: () {

                        },
                        child: Ink(
                          color: Colors.grey[400],
                          child: Container(
                            height: 50,
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  child: Icon(Icons.subscriptions_outlined, size: 20,)
                                ),
                                Text(s.sub),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: InkWell(
                        highlightColor: Colors.red,
                        splashColor: Colors.red,
                        hoverColor: Colors.red,
                        onTap: () {
                          showLanguageDialog();
                          _scaffoldKey.currentState?.closeDrawer();
                        },
                        child: Ink(
                          color: Colors.grey[400],
                          child: Container(
                            height: 50,
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  child: Icon(Icons.language, size: 20,)
                                ),
                                Text(s.language),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: InkWell(
                        highlightColor: Colors.red,
                        splashColor: Colors.red,
                        hoverColor: Colors.red,
                        onTap: () {

                        },
                        child: Ink(
                          color: Colors.grey[400],
                          child: Container(
                            height: 50,
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  child: Icon(Icons.question_answer_outlined, size: 20,)
                                ),
                                const Text("FAQ"),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.all(10),
                      color: Colors.grey[400],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                child: Icon(Icons.sunny, size: 20,)
                              ),
                              Text(s.theme),
                            ],
                          ),
                          CupertinoSwitch(
                              value: _switch,
                              onChanged: (value) {
                                setState(() {
                                  if(value) {
                                    notifier?.setDarkMode();
                                  } else {
                                    notifier?.setLightMode();
                                  }
                                });
                              }
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20),
                child: InkWell(
                  highlightColor: Colors.red,
                  splashColor: Colors.red,
                  hoverColor: Colors.red,
                  onTap: () {

                  },
                  child: Ink(
                    color: Colors.grey[400],
                    child: Container(
                     padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: Icon(Icons.subscriptions_outlined, size: 20,)
                          ),
                          Column(
                            textDirection: ui.TextDirection.ltr,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:  [
                              Text(s.exit, style: const TextStyle(fontSize: 16,),),
                              const Text("ivanivanov@mail.ru")
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),

      floatingActionButton: SpeedDial(
        closedForegroundColor: Colors.white,
        openForegroundColor: Colors.white,
        closedBackgroundColor: Colors.blue,
        openBackgroundColor: Colors.red,
        labelsBackgroundColor: Colors.grey,
        speedDialChildren: <SpeedDialChild>[
          SpeedDialChild(
            child: const Icon(Icons.create_new_folder_outlined),
            foregroundColor: Colors.white,
            backgroundColor: Colors.red,
            label: s.add_a_folder,
            onPressed: () {
              setState(() {
                  _displayFoldersDialog(context);
              });
            },
            closeSpeedDialOnPressed: false,
          ),
          SpeedDialChild(
            child: const Icon(Icons.note_add_outlined),
            foregroundColor: Colors.black,
            backgroundColor: Colors.yellow,
            label: s.add_a_document,
            onPressed: () {
              setState(() {
                _displayDocumentDialog(context);
              });
            },
          ),
          //  Your other SpeedDialChildren go here.
        ],
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: Colors.amber,
          title: Text(s.home,),
        automaticallyImplyLeading: false,
             actions: [
               IconButton(icon: const Icon(Icons.splitscreen),
                 onPressed: () async {
                   await Navigator.push(context, MaterialPageRoute(builder: (context) => BoardPage()));
                   getData();
                   getFavs();
                   setState(() {});
                },
               )
             ],
             // leading: Container(width: 0,height: 0,),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ReorderableListView(
              shrinkWrap:true,
              physics: const ClampingScrollPhysics(),
              children: list.map(
                      (e) =>
                      GestureDetector(
                        key: Key("${e.id}"),
                        onTap: () async {
                          await Navigator.push(context, MaterialPageRoute(builder: (context) => TabsPage(document: docs[e.draft_id]!)));
                          setState((){
                            _scaffoldKey.currentState?.initState();
                          });
                        },
                        child: Dismissible(
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.red,
                            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            alignment: Alignment.centerRight,
                            child: Container(
                              padding: const EdgeInsets.only(right: 30),
                              child: const Icon(
                                Icons.delete,
                                //color: Colors.white,
                              ),
                            ),
                          ),
                          onDismissed: (d) async {
                            var i = await DBProvider.db.removeFromFavs(e.draft_id);
                            print('$i');
                            list.remove(e);
                            getFavs();
                          },
                          key: UniqueKey(),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            constraints: const BoxConstraints(minHeight: 90,maxHeight: 100),
                            alignment: Alignment.center,
                            child: Card(
                              //color: Colors.white,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Padding(padding: EdgeInsets.only(left: 20),child: Icon(Icons.description),),
                                      Center(
                                        child: Container(
                                            width: 270,
                                            padding: const EdgeInsets.all(8),
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 30,top: 8),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(docs[e.draft_id]!.name,style: const TextStyle(fontSize: 20),),
                                                  Expanded(
                                                      child: Text(docs[e.draft_id]!.description,maxLines: 3,
                                                        overflow: TextOverflow.ellipsis,
                                                      )
                                                  )
                                                ],
                                              ),
                                            )
                                        ),
                                      )
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      DBProvider.db.removeFromFavs(e.draft_id);
                                      setState((){
                                        list.remove(e);
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.only(right: 20),
                                      child: const Icon(Icons.star,color: Colors.amberAccent,),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
              ).toList(),
              onReorder: (int start, int current) {
                // dragging from top to bottom
                if (start < current) {
                  int end = current - 1;
                  FavoritesItem startItem = list[start];
                  int i = 0;
                  int local = start;
                  do {
                    list[local+1].sorting--;
                    list[local].sorting++;
                    list[local] = list[++local];
                    i++;
                  } while (i < end - start);
                  list[end] = startItem;
                }
                // dragging from bottom to top
                else if (start > current) {
                  FavoritesItem startItem = list[start];
                  for (int i = start; i > current; i--) {
                    list[i].sorting--;
                    list[i-1].sorting++;
                    list[i] = list[i - 1];
                  }
                  list[current] = startItem;
                }
                DBProvider.db.updateSortingFavs(list);
                setState(() {});
              },
            ),
            ReorderableListView(
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              proxyDecorator: (w,i,a) {
                return w;
              },
              onReorder: (int start, int current) {
                // dragging from top to bottom
                if (start < current) {
                  int end = current - 1;
                  Folder startItem = folders[start];
                  int i = 0;
                  int local = start;
                  do {
                    print('${folders[local].name} ${folders[local].sorting}'
                        '|| ${folders[local+1].name} ${folders[local+1].sorting}');
                    folders[local+1].sorting--;
                    folders[local].sorting++;
                    print('${folders[local].name} ${folders[local].sorting}'
                        '|| ${folders[local+1].name} ${folders[local+1].sorting}');
                    folders[local] = folders[++local];
                    i++;
                  } while (i < end - start);
                  folders[end] = startItem;
                }
                // dragging from bottom to top
                else if (start > current) {
                  Folder startItem = folders[start];
                  for (int i = start; i > current; i--) {
                    print('${folders[i].name} ${folders[i].sorting}'
                        '|| ${folders[i-1].name} ${folders[i-1].sorting}');
                    folders[i].sorting--;
                    folders[i-1].sorting++;
                    print('${folders[i].name} ${folders[i].sorting}'
                        '|| ${folders[i-1].name} ${folders[i-1].sorting}');
                    folders[i] = folders[i - 1];
                  }
                  folders[current] = startItem;
                }
                DBProvider.db.updateSorting(folders);
                setState(() {});
              },
              children: folders.map((e) =>
                  GestureDetector(
                      key: Key("${e.id}"),
                      onTap: () async {
                        await Navigator.push(context, MaterialPageRoute(builder: (context)=>FolderPage(folder: e)));
                        getFavs();
                      },
                      child: Dismissible(
                        key: Key("${e.id}"),
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (d) async {
                          var f = await showAccessFolderDialog(e);
                          return f[0] as bool;
                        },
                        onDismissed: (dir) async {
                          print(e.name);
                          final db = await DBProvider.db.database;
                          for(int i = 0;i<e.childs.length;i++) {
                            Document doc = e.childs[i];
                            await db?.delete("MyDraft",where: "id = ?",whereArgs: [doc.id]);
                            await db?.delete("Favorites",where: "id_draft = ?",whereArgs: [doc.id]);
                          }
                          await db?.delete("MyDraft", where: "id = ?",whereArgs: [e.id]);
                          folders.remove(e);
                          getData();
                          getFavs();
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
                              color: Colors.white,
                            ),
                          ),
                        ),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 80,
                          //padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Card(
                            color: Colors.amber[600],
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                    children: [
                                      const Padding(padding: EdgeInsets.only(left: 20),
                                          child: Icon(Icons.folder)
                                      ),
                                      Padding(padding: const EdgeInsets.only(left: 30),
                                        child: Text(e.name,
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                      ),
                                    ]
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 30,right: 10),
                                      child: Text('${e.childs.length}',
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(right: 20),
                                      child: Icon(Icons.arrow_forward),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                  )
              ).toList(),
            ),
          ],
        ),
      )
    );
  }


  void getData() async {
    final tmp =  await DBProvider.db.getAll() ?? [];
    map.clear();
    docs.clear();
    for(int i = 0;i<tmp.length;i++) {
      NoteObject note = tmp[i];
      print('${note.name} ${note.parent} ${note.amount} ${note.type} ${note.sorting}');
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
    setState((){
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
  }

  final TextEditingController _folders_conrtl = TextEditingController();
  Future<void> _displayFoldersDialog(BuildContext context) async {
    var name = '';
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(s.add_a_folder),
            content: TextField(
              onChanged: (value) {
                setState((){
                  name = value;
                  print(_folders_conrtl.text+" "+name);
                });
              },
              controller: _folders_conrtl,
              decoration: InputDecoration(hintText: s.folder_name),
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
                    var table = await db!.rawQuery("SELECT MAX(id)+1 as id FROM MyDraft");
                    var date = DateTime.now();
                    var formatter = DateFormat('dd.MM.yyyy');
                    int id = table.first["id"]==null ? 0 : table.first["id"] as int;
                    var note = NoteObject(name: _folders_conrtl.text, description: "", date: formatter.format(date),
                        date_up: formatter.format(date),id: id, amount: 0,
                        parent: -1, sorting: folders.length+1, type: 1,
                      theme: "",mesto: "",date_d: "",genre: "",history: ""
                    );
                    await db.insert("MyDraft", note.toJson());
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
  late int _value;
  final TextEditingController _documents_conrtl = TextEditingController(),
  _docs_desc = TextEditingController();
  Future<void> _displayDocumentDialog(BuildContext context) async {
    var name_doc = '';
    _value = folders[0].id;
   return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(s.add_a_document),
            content: StatefulBuilder(builder: (context, state) {
              return Column(
                children: [
                  DropdownButton(
                    items: folders.map((e) => DropdownMenuItem(value: e.id,child: Text(e.name),)).cast<DropdownMenuItem<int>>().toList(),
                    onChanged: (value) {
                      state(() {
                        print(value);
                        _value = value as int;
                      });
                    },
                    value: _value,
                  ),
                  TextField(
                    onChanged: (value) {
                      state((){
                        name_doc = value;
                        print("${_documents_conrtl.text} $name_doc");
                      });
                    },
                    controller: _documents_conrtl,
                    decoration: InputDecoration(hintText: s.document_name),
                  ),
                  TextField(
                    onChanged: (value) {
                      state((){
                      });
                    },
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: _docs_desc,
                    decoration: InputDecoration(hintText: s.description),
                  )
                ],
              );
            }),
            actions: <Widget>[
              ElevatedButton(
                  onPressed: () {
                    _documents_conrtl.text = '';
                    _docs_desc.text ='';
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
                    var date = DateTime.now();
                    var formatter = DateFormat('dd.MM.yyyy');
                   final db = await DBProvider.db.database;
                    var table = await db!.rawQuery("SELECT MAX(id)+1 as id FROM MyDraft");
                    int id = table.first["id"]==null ? 0 : table.first["id"] as int;
                    var note = NoteObject(name: _documents_conrtl.text, description: _docs_desc.text, date: formatter.format(date),
                        date_up: formatter.format(date),id: id, amount: -1,
                        parent: _value, sorting: 0, type: 0,
                        theme: "",mesto: "",date_d: "",genre: "",history: ""
                    );
                    await db.insert("MyDraft", note.toJson());
                    _documents_conrtl.text = '';
                    _docs_desc.text ='';
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
  void getFavs() async {
    var tmp = await DBProvider.db.getFavs();
    setState((){
      list.clear();
      list.addAll(tmp);
      list.sort((f1,f2) {
        return f1.sorting-f2.sorting;
      });
    });
  }
  bool contains(int id) {
    for(int i = 0;i<list.length;i++) {
      if(list[i].draft_id==id) return true;
    }
    return false;
  }

  Future showAccessFolderDialog(Folder folder) {
    return showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text(s.delete),
        titleTextStyle:
        const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20
        ),
        actionsOverflowButtonSpacing: 20,
        actions: [
          ElevatedButton(onPressed: (){
            Navigator.pop(context,[false]);
          }, child: Text(s.cancel)),
          ElevatedButton(onPressed: (){
            Navigator.pop(context,[true]);
          }, child: Text(s.delete)),
        ],
        content: Text('${s.access_folder}"${folder.name}"?'),
      );
    });
  }
  Future showLanguageDialog() {
    return showDialog(context: context,
        builder: (context) {
      return AlertDialog(
        scrollable: true,
        content: Container(
            width: 300,
            height: 400,
            child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, ind) {
                return ListTile(
                  title: Text(AllLocale.all[ind].countryCode!),
                  onTap: () {
                    setState(() {
                      //LocaleProvider().setLocale(AllLocale.all[ind]);
                        //MyApp.setLocale(context, AllLocale.all[ind]);
                        provider!.setLocale(AllLocale.all[ind]);
                        Navigator.of(context).pop();
                      }
                    );
                  },
                );
              },
              itemCount: AllLocale.all.length,
            )
         ),
        );
      }
    );
  }
}