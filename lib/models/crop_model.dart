class CropModel {
  String name;
  String imgUrl;

  CropModel({
    this.name,
    this.imgUrl,
  });

  factory CropModel.fromMap(Map data) {
    return CropModel(
      name: data['name'],
      imgUrl: data['imgUrl'],
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "imgUrl": imgUrl,
      };
}
