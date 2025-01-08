class RecommendableUsersModel {
  RecommendableUsersModel({
    this.success,
    this.message,
    this.data,
  });

  final bool? success;
  final String? message;
  final List<RecommendableUsersList>? data;

  factory RecommendableUsersModel.fromJson(Map<String, dynamic> json){
    return RecommendableUsersModel(
      success: json["success"],
      message: json["message"],
      data: json["data"] == null ? [] : List<RecommendableUsersList>.from(json["data"]!.map((x) => RecommendableUsersList.fromJson(x))),
    );
  }

}

class RecommendableUsersList {
  RecommendableUsersList({
    required this.id,
    required this.name,
    required this.profilePicture,
  });

  final String? id;
  final String? name;
  final String? profilePicture;

  factory RecommendableUsersList.fromJson(Map<String, dynamic> json){
    return RecommendableUsersList(
      id: json["id"],
      name: json["name"],
      profilePicture: json["profilePicture"],
    );
  }

}
