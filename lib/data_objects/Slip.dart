
class Slip {
  int id, id_draft, favs, sort;
  String text, date, name;
  Slip({required this.id,required this.date,required this.text, required this.id_draft, required this.name,
    required this.favs, required this.sort});

  factory Slip.fromJson(Map<String, dynamic> data)
  => Slip(id: data['id'], id_draft: data['id_draft'],
      date: data['date_up'], text: data['text'],
    name: data['name'], favs: data['favorite'], sort: data['sorting']
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'id_draft':id_draft,
    'date_up':date,
    'text':text,
    'name': name,
    'favorite': favs,
    'sorting': sort
  };
}