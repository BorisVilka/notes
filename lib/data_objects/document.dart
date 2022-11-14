
class Document {
  int id, sorting, parent;
  String name, description, date, date_up,
  theme, history, date_d, genre, mesto;

  Document({required this.name,required this.sorting,required this.parent,
    required this.date_up,required this.date,required this.description,required this.id,
    required this.theme, required this.date_d, required this.genre, required this.history,
    required this.mesto
  });
}