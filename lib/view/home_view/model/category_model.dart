class CategoryModel {
  CategoryModel({
    this.success,
    this.message,
    this.data,
  });

  final bool? success;
  final String? message;
  final List<CategoryList>? data;

  factory CategoryModel.fromJson(Map<String, dynamic> json){
    return CategoryModel(
      success: json["success"],
      message: json["message"],
      data: json["data"] == null ? [] : List<CategoryList>.from(json["data"]!.map((x) => CategoryList.fromJson(x))),
    );
  }

}

class CategoryList {
  CategoryList({
    required this.id,
    required this.name,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  final String? id;
  final String? name;
  final String? image;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory CategoryList.fromJson(Map<String, dynamic> json){
    return CategoryList(
      id: json["id"],
      name: json["name"],
      image: json["image"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
    );
  }

}
