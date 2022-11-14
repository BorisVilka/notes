

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TagsPage extends StatefulWidget {

  Map<String,List<int>> map;

  TagsPage({required this.map});

  @override
  _TagsPage createState() => _TagsPage();

}
class _TagsPage extends State<TagsPage> {

  late Map<String,List<int>> map;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    map = widget.map;
    return Scaffold(
      appBar: AppBar(title: Text('Фильтр'),),
      body: Stack(
        children: [
          Container(
            child: ListView.builder(itemBuilder: (c,ind){
                return GestureDetector(
                  onTap: (){
                    Navigator.of(context).pop(map.entries.toList()[ind].key);
                  },
                  child: Card(
                    color: Colors.grey,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Row(
                        children: [
                          const Padding(padding: EdgeInsets.all(10),
                            child: Icon(Icons.tag),),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(map.entries.toList()[ind].key),
                              Text('${map.entries.toList()[ind].value.length} заметок')
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
              padding: const EdgeInsets.only(bottom: 50),
              itemCount: map.length,
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            width: double.infinity,
            child: ButtonTheme(
                minWidth: double.infinity,
              child:  ElevatedButton(
                onPressed: (){
                    Navigator.of(context).pop("");
                }, child: Text('Сбросить'),
              ),
            )
          )
        ],
      ),
    );
  }

}