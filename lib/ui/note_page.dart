

import 'dart:io';

import 'package:NoteProject/data_objects/document.dart';
import 'package:NoteProject/ui/tags_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:intl/intl.dart';
import 'package:clipboard/clipboard.dart';

import '../data_objects/note.dart';
import '../db_utils/db_helper.dart';
import '../generated/l10n.dart';
import 'doc_page.dart';

class NotePage extends StatefulWidget {

  Document document;
  NotePage({required this.document});

  @override
  _NoteState createState() => _NoteState();


}
class _NoteState extends State<NotePage> {

  late Document document;
  late List<Note> data = [];
  int? id;
  String tag = "";
  List<int> selected = [];
  bool first  = true;
  Note? edit;
  Widget? leading ;
  FloatingActionButton? button;
  List<String?>? filename;
  Map<String,List<int>> tags = {};
  List<Widget>? actions;
  final TextEditingController _controller = TextEditingController();
  final ScrollController _controller1 = ScrollController();
  final TextEditingController _title = TextEditingController();
  S s = S();


  void _scrollDown() {
    setState(() {
      button = null;
    });
    _controller1.jumpTo(

        _controller1.position.maxScrollExtent,
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    document = widget.document;
    _title.text = document.name;
     if(first) {
      getData();
      setState(() {
        button = FloatingActionButton.small(
          onPressed: _scrollDown,
          backgroundColor: Colors.amber,
          child: Icon(Icons.arrow_downward),
        );
      });
      //_scrollDown();
    }
    return Scaffold(
     body: Stack(
        children: [
          Container(
            alignment: Alignment.topRight,
            padding: const EdgeInsets.only(bottom: 10),
            child: NotificationListener<ScrollUpdateNotification>(
              child: ListView.builder(itemBuilder: (c,ind) {
                return data[ind].text.isNotEmpty ? buildText(c, ind) : buildImage(c, ind);
              },
                controller: _controller1,
                itemCount: data.length,
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 10,bottom: 100),
              ),
              onNotification: (not) {
                if(_controller1.position.pixels!=_controller1.position.maxScrollExtent) {
                  setState(() {
                    //_controller1.dispose();
                    button = FloatingActionButton.small(
                      onPressed: _scrollDown,
                      backgroundColor: Colors.amber,
                      child: Icon(Icons.arrow_downward,color: Theme.of(context).primaryColorDark,),
                    );
                  });
                } else {
                  setState(() {
                    button = null;
                  });
                }
                return true;
              },
            ),
          ),
          if(button!=null) Container(
            alignment: Alignment.bottomLeft,
            padding: EdgeInsets.only(bottom: 100,left: 10),
            child: button,
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                alignment: Alignment.bottomCenter,
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if(edit!=null) Container(
                      alignment: Alignment.bottomCenter,
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Container(
                        height: 40,
                        color: Colors.grey,
                        padding: const EdgeInsets.only(left: 5),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.edit, color: Colors.amber,),
                                const Padding(padding: EdgeInsets.symmetric(vertical: 4),child: VerticalDivider(color: Colors.amber,thickness: 2,),),
                                SizedBox(
                                  width: 250,
                                  child: Text(edit!.text, maxLines: 1,overflow: TextOverflow.ellipsis),
                                )
                              ],
                            ),
                            IconButton(onPressed: () {
                              setState(() {
                                _controller.text = "";
                                edit = null;
                              });
                            }, icon: const Icon(Icons.close,color: Colors.amber,))
                          ],
                        ),
                      ),
                    ),
                    Container(
                        alignment: Alignment.bottomLeft,
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: Card(
                          color: Colors.grey[300],
                          child: Row(
                            children: <Widget>[
                              const SizedBox(width: 15,),
                              GestureDetector(
                                  onTap: () async {
                                    if(edit==null) {
                                      final result = await FilePicker.platform.pickFiles(allowMultiple: false);

                                      // if no file is picked
                                      if (result == null) return;
                                      setState(() {
                                        filename = result.paths;
                                      });
                                      //we will log the name, size and path of the
                                      // first picked file (if multiple are selected)
                                     // print(result.files.first.name);
                                      //print(result.files.first.size);
                                      //print(result.files.first.path);
                                    }
                                  },
                                  child: SizedBox(
                                    width: 35,
                                    height: 45,
                                    child: Stack(
                                      fit: StackFit.passthrough,
                                      children: [
                                        const Icon(Icons.attach_file, color: Colors.grey, ),
                                        if(filename!=null) Container(
                                            width: 8,
                                            height: 8,
                                            padding: const EdgeInsets.only(left: 15, bottom: 25),
                                            child:  ClipRRect(
                                              borderRadius: const BorderRadius.only(
                                                  bottomLeft: Radius.circular(40),
                                                  bottomRight: Radius.circular(40),
                                                  topLeft: Radius.circular(40),
                                                  topRight: Radius.circular(40)),
                                              child: Container(
                                                color: Colors.amber,
                                                alignment: Alignment.center,
                                                child: Text('${filename?.length}'),
                                              ),
                                            ) // This trailing comma makes auto-formatting nicer for build methods.
                                        )
                                      ],
                                    ),
                                  )
                              ),
                              const SizedBox(width: 10,),
                              Expanded(child: TextField(
                                decoration: InputDecoration(
                                    hintText: s.note,
                                    hintStyle: const TextStyle(color: Colors.black54),
                                    border: InputBorder.none
                                ),
                                maxLines: 3,
                                minLines: 1,
                                controller: _controller,
                                )
                              ),
                              const SizedBox(width: 15,),
                              IconButton(onPressed:() async {
                                final db = await DBProvider.db.database;
                                var table = await db!.rawQuery("SELECT MAX(id)+1 as id FROM Notes");
                                int id = table.first["id"]==null ? 0 : (table.first["id"] as int)+1;
                                var date = DateTime.now();
                                var formatter = DateFormat('dd.MM.yyyy HH:mm');
                                if(edit==null) {
                                  Note note = Note(id: id, date: formatter.format(date), text: _controller.text, id_draft: document.id,
                                      file: (_controller.text.isNotEmpty ? "" : filename!.first!)
                                  );
                                  if(_controller.text.isNotEmpty) {
                                    DBProvider.db.addNote(note);
                                    _controller.text = "";
                                  }
                                  if(filename!=null && _controller.text=="") {
                                    for(int i = 0;i<filename!.length;i++) {
                                      note = Note(id: id+1+i, date: formatter.format(date), text: _controller.text, id_draft: document.id,
                                          file: filename![i]!);
                                      DBProvider.db.addNote(note);
                                    }
                                    filename = null;
                                    _controller.text = "";
                                    //DBProvider.db.addNote(note);
                                  }
                                } else {
                                  Note note = Note(id: edit!.id, date: edit!.date, text: _controller.text, id_draft: edit!.id_draft,
                                      file: (_controller.text.isNotEmpty ? "" : filename!.first!)
                                  );
                                  if(_controller.text.isNotEmpty) {
                                    DBProvider.db.editNote(note);
                                    _controller.text = "";
                                  }
                                  edit = null;
                                }
                                _controller.text = "";
                                getData();
                                _scrollDown();
                              },
                                  icon:  Icon(Icons.send,color: Colors.amber)
                              ),
                              const SizedBox(width: 15,),
                            ],

                          ),
                        )
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      appBar: AppBar(
        backgroundColor: Colors.amber,
        leading: leading,
        actions: actions,
        title: edit==null ? EditableText(
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
        ) : null
      ),
    );
  }
  void getData() async {
    var tmp = await DBProvider.db.getNotes(document.id);
    tags = {};
    setState((){
      data.clear();
      data.addAll(tmp);
      var formatter = DateFormat('dd.MM.yyyy HH:mm');
      data.sort((s1,s2){
        var date1 = formatter.parse(s1.date);
        var date2 = formatter.parse(s2.date);
        return date1.compareTo(date2);
        });
      for(Note i in data) {
          if(i.text.contains("#")) {
            //print('gegeg');
            var ind = 0;
            while(ind!=-1) {
              ind = i.text.indexOf("#",ind);
              if(ind==-1) break;
              var s = "";
              while(ind>=0 && ind<i.text.length && (i.text[ind]!=' ' && i.text[ind]!='.' && i.text[ind]!='!' && i.text[ind]!='?' && i.text[ind]!='\n')) {
                //print(i.text[ind]);
                s+=i.text[ind];
                ind++;
              }
              if(tags.containsKey(s)) {
                var list = tags[s];
                list?.add(i.id);
                tags[s] = list!;
              } else {
                tags[s] = [i.id];
              }
             // print(s);
            }
          }
      }
      data = data.where((element) {
        if(tag.isEmpty) return true;
        //print(tags[tag]!.contains(element.id).toString()+" "+tag!);
        return tags[tag]!.contains(element.id);
        }
      ).toList();
    });
    if(first) {
      first = false;
      //_scrollDown();
    }
    buildFocus();
  }
  void buildFocus() {
    setState(() {
      if(selected.isNotEmpty) {
        leading = Row(
          children: [
             GestureDetector(onTap: () {
                selected.clear();
                buildFocus();
                }, child: Padding(padding: EdgeInsets.all(8),child: Icon(Icons.close,color: Theme.of(context).primaryColorDark,),),
              ),
              Text('${selected.length}'),
          ],
        );
        actions = [
          if(selected.length==1 && data[selected[0]].file.isEmpty) IconButton(onPressed: () {
            setState(() {
              edit = data[selected[0]];
              selected.clear();
              _controller.text = edit!.text;
              buildFocus();
            });
          }, icon: Icon(Icons.edit,color: Theme.of(context).primaryColorDark,)),
          if(selected.length==1 && data[selected[0]].file.isEmpty) IconButton(onPressed: () {
              for(int i = 0;i<data.length;i++) {
                 if(data[i].id==selected[0]) {
                   FlutterClipboard.copy(data[i].text);
                   selected.clear();
                   buildFocus();
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                     content: Text("Текст скопирован"),
                   ));
                   break;
                 }
                }
            }, icon: Icon(Icons.copy,color: Theme.of(context).primaryColorDark,),
          ),
          IconButton(onPressed: () async {
              for(int i in selected) {
                DBProvider.db.removeFromNotes(data[i].id);
              }
              selected.clear();
              buildFocus();
              getData();
           }, icon: Icon(Icons.delete_outline,color: Theme.of(context).primaryColorDark,)
          ),
          GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DocumentPage(document: document)));
              setState(() {});
            },
            child: Container(
              padding: EdgeInsets.only(right: 20),
              child: Icon(Icons.settings,color: Theme.of(context).primaryColorDark,),
            ),
          )
        ];
      } else {
        leading = null;
        actions = [
          if(tags.isNotEmpty) GestureDetector(
              onTap: () async {
                var tmp = await Navigator.of(context).push(MaterialPageRoute(builder: (c)=>TagsPage(map: tags)));
                if(tmp!=null) tag = tmp;
                //print(tag);
                getData();
                buildFocus();
              },
              child: Container(
                width: 35,
                height: 35,
                padding: const EdgeInsets.only(right: 10),
                child: Stack(
                  fit: StackFit.passthrough,
                  children: [
                    Icon(Icons.tag, color: Theme.of(context).primaryColorDark,),
                    if(tag.isNotEmpty) Container(
                        width: 5,
                        height: 5,
                        padding: const EdgeInsets.only(left: 10, bottom: 25,top: 15),
                        child:  ClipRRect(
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(40),
                              bottomRight: Radius.circular(40),
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40)),
                          child: Container(
                            color: Colors.amber[800],
                            alignment: Alignment.center,
                          ),
                        ) // This trailing comma makes auto-formatting nicer for build methods.
                    )
                  ],
                ),
              )
          ),
          GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DocumentPage(document: document)));
              setState(() {});
            },
            child: Container(
              padding: EdgeInsets.only(right: 20),
              child: Icon(Icons.settings,color: Theme.of(context).primaryColorDark,),
            ),
          )
        ];
      }
    });
  }

  Widget buildText(BuildContext c, int ind) {
    var formatter = DateFormat('dd.MM.yyyy');
    var formatter1 = DateFormat('HH:mm');
    var formatter2 = DateFormat('dd.MM.yyyy HH:mm');
    var date1 = formatter.parse(data[ind].date.split(" ")[0]);
    var date2 = ind>0 ? formatter.parse(data[ind-1].date.split(" ")[0]) : null;
    var cont = selected.contains(ind);
    var m = <int,int>{};
    var i = 0;
    while(i!=-1) {
      i = data[ind].text.indexOf("#",i);
      var t = i;
      while(i>=0 && i<data[ind].text.length && (data[ind].text[i]!=' '
          && data[ind].text[i]!='.' && data[ind].text[i]!='!' && data[ind].text[i]!='?' && data[ind].text[i]!='\n')) {
        //print(i.text[ind]);
        i++;
      }
      if(i==-1) break;
      m[t] = i;
    }
    var list = m.entries.toList();
   // print(list.length);
    List<TextSpan> tmp = [];
    var old = 0;
    for(MapEntry<int,int> j in list) {
      tmp.add(TextSpan(
          text: data[ind].text.substring(old,j.key)));
      //print(old.toString()+" "+j.key.toString());
      old = j.value;
      tmp.add(TextSpan(
          text: data[ind].text.substring(j.key,j.value),
          style: const TextStyle(
              decoration: TextDecoration.underline,
              color: Colors.amber,
              
          ),
      ),

      );
      //print(j.key.toString()+" "+j.value.toString());
    }
    tmp.add(TextSpan(
      text: data[ind].text.substring(old),));
    var text = Text.rich(
      TextSpan(
        children: tmp,
      ),
       maxLines: null,
    );
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          if(ind==0 || (date2!=null && date1.compareTo(date2)!=0)) Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(15),
            child: Card(
              color: Colors.grey[700],
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 40),
                child: Text(formatter.format(date1)),
              ),
            ),
          ),
          Container(
            color: cont ? Colors.grey : null,
            child:Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: cont ? MainAxisAlignment.spaceBetween : MainAxisAlignment.end,
                  children: [
                    if(cont) Container(
                      padding: const EdgeInsets.only(left: 20),
                      alignment: Alignment.centerLeft,
                      child: const Icon(Icons.task_alt_rounded,color: Colors.amber,),
                    ),
                    GestureDetector(
                      child: Container(
                        alignment: Alignment.centerRight,
                          constraints: const BoxConstraints(maxWidth: 200),
                        padding: const EdgeInsets.only(bottom: 5,right: 5),
                        child: Card(
                          color: Colors.grey[400],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                  padding: const EdgeInsets.only(top: 5,left: 10,right: 15),
                                  alignment: Alignment.centerRight,
                                  child: text,
                              ),
                              Container(
                                padding: const EdgeInsets.only(bottom: 5,left: 5,right: 10),
                                alignment: Alignment.centerRight,
                                child: Text(formatter1.format(formatter2.parse(data[ind].date))),
                              ),
                            ],
                          ),
                        )
                      ),
                      onLongPress: (){
                       // print('long');
                        selected.add(ind);
                        buildFocus();
                      },
                      onTap: () {
                        if(cont) {
                          selected.remove(ind);
                        } else if(selected.isNotEmpty) {
                          selected.add(ind);
                        }
                        buildFocus();
                      },
                    )
                  ],
                )
          )
        ],
      ),
    );
  }

  Widget buildImage(BuildContext context, int ind) {
    var formatter = DateFormat('dd.MM.yyyy');
    var formatter1 = DateFormat('HH:mm');
    var formatter2 = DateFormat('dd.MM.yyyy HH:mm');
    var date1 = formatter.parse(data[ind].date.split(" ")[0]);
    var date2 = ind>0 ? formatter.parse(data[ind-1].date.split(" ")[0]) : null;
    var cont = selected.contains(ind);
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          if(ind==0 || (date2!=null && date1.compareTo(date2)!=0)) Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(15),
            child: Card(
              color: Colors.grey[700],
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 40),
                child: Text(formatter.format(date1)),
              ),
            ),
          ),
          Container(
            color: cont ? Colors.grey : null,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: cont ? MainAxisAlignment.spaceBetween : MainAxisAlignment.end,
              children: [
                if(cont) Container(
                  padding: const EdgeInsets.only(left: 20),
                  alignment: Alignment.centerLeft,
                  child: const Icon(Icons.task_alt_rounded,color: Colors.amber,),
                ),
                GestureDetector(
                  child: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(bottom: 5,right: 5),
                    child: Card(
                      color: Colors.transparent,
                        elevation: 0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Stack(
                          children: [
                            Container(
                              constraints:  BoxConstraints(minWidth: 200, maxWidth: 200),
                              child: Image.file(File(data[ind].file),),
                            ),
                            Positioned.fill(child: Container(
                              alignment: Alignment.bottomRight,
                              padding: const EdgeInsets.only(right: 5, bottom: 5),
                              child: Card(
                                color: Colors.grey[500],
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(formatter1.format(formatter2.parse(data[ind].date)),
                                    style: TextStyle(color: Colors.amber[600]),),
                                ),
                              ),
                            )
                            )
                          ],
                        ),
                        
                      )
                    ),
                  ),
                  onLongPress: (){
                   // print('long');
                    selected.add(ind);
                    buildFocus();
                  },
                  onTap: () {
                    if(cont) {
                      selected.remove(ind);
                      buildFocus();
                    } else if(selected.isNotEmpty) {
                      selected.add(ind);
                      buildFocus();
                    } else {
                        _showImageDialog(context, data[ind].file);
                    }
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
  _showImageDialog(BuildContext context, String image) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      barrierDismissible: true,
      builder: (_) => Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: GestureDetector(
          onHorizontalDragEnd: (e){
            Navigator.of(context).pop();
          },
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  width: double.infinity,
                  child: Image.file(
                    File(image),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}