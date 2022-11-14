
class Note {
  int id, id_draft;
  String text, date, file;
  Note({required this.id,required this.date,required this.text, required this.id_draft, required this.file});

  factory Note.fromJson(Map<String, dynamic> data)
  => Note(id: data['id'], id_draft: data['id_draft'],
      date: data['date'], text: data['text'],
    file: data['file']
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'id_draft':id_draft,
    'date':date,
    'text':text,
    'file':file
  };
}