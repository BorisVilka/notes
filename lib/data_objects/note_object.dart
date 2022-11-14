import 'dart:convert';


class NoteObject {

  String name, description, date, date_up,
      theme, history, date_d, genre, mesto;
  int id, amount, parent, sorting, type;


  NoteObject({required this.name, required this.description,
  required this.date, required this.date_up,
  required this.id, required this.amount, required this.parent, required this.sorting,
  required this.type,
    required this.theme, required this.date_d, required this.genre, required this.history,
    required this.mesto
  });

  factory NoteObject.fromJson(Map<String, dynamic> data) =>
      NoteObject(id: data['id'], name: data['name'], description: data['description'], date: data['date'],
          date_up: data['date_up'], amount: data['amount'],
          parent: data['parent'], sorting: data['sorting'], type: data['type'],
        theme: data['theme'], date_d: data['date_d'], genre: data['genre'],
        history: data['history'], mesto: data['mesto']
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'date': date,
    'date_up': date_up,
    'amount': amount,
    'parent': parent,
    'sorting': sorting,
    'type': type,
    'theme': theme,
    'date_d': date_d,
    'genre': genre,
    'history': history,
    'mesto': mesto
  };
}
NoteObject clientFromJson(String str) {
  final jsonData = json.decode(str);
  return NoteObject.fromJson(jsonData);
}

String clientToJson(NoteObject data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}
