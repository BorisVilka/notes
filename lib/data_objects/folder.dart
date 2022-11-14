


import 'package:NoteProject/data_objects/document.dart';

class Folder {
  int id, sorting, amount;
  String name, date, date_up;
  List<Document> childs;

  Folder({required this.id,required this.date,required this.date_up,required this.sorting,required this.name,required this.amount,required this.childs});

}