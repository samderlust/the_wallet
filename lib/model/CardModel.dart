class CardModel {
  String uuid;
  String code;
  String description;
  String title;
  int codeFormat;

  CardModel({
    this.uuid,
    this.code,
    this.title,
    this.description,
    this.codeFormat,
  });
  void setTitle(String newTitle) {
    title = newTitle;
  }

  void setDescription(String newDescription) {
    description = newDescription;
  }

  CardModel.fromDb(Map<String, dynamic> card)
      : uuid = card['uuid'],
        code = card['code'],
        description = card['description'],
        codeFormat = card['codeFormat'] ?? 6,
        title = card['title'];

  Map<String, dynamic> toMap() {
    return {
      "uuid": uuid,
      "code": code,
      "description": description,
      "title": title,
      "codeFormat": codeFormat
    };
  }
}
