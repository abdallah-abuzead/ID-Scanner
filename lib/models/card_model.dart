class CardModel {
  int? id;
  String? title, frontImagePath, backImagePath;

  CardModel();

  CardModel.fromMap(Map<String, dynamic> card) {
    id = card['id'];
    title = card['title'];
    frontImagePath = card['front_image_path'];
    backImagePath = card['back_image_path'];
  }

  Map<String, dynamic> toMap() => {
        'title': title,
        'front_image_path': frontImagePath,
        'back_image_path': backImagePath,
      };
}
