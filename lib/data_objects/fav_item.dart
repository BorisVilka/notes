
class FavoritesItem {
  int id, draft_id, sorting, idList;

  FavoritesItem({required this.id,required this.draft_id,required this.sorting,required this.idList});


  factory FavoritesItem.fromJson(Map<String, dynamic> data)
  => FavoritesItem(id: data['id'], draft_id: data['id_draft'],
      sorting: data['sorting'], idList: data['idList']);

  Map<String, dynamic> toJson() => {
    'id': id,
    'id_draft':draft_id,
    'sorting':sorting,
    'idList':idList
  };


}