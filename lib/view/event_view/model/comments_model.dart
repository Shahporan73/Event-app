class CommentsModel {
  CommentsModel({
    this.success,
    this.message,
    this.data,
  });

  final bool? success;
  final String? message;
  final List<CommentList>? data;

  factory CommentsModel.fromJson(Map<String, dynamic> json){
    return CommentsModel(
      success: json["success"],
      message: json["message"],
      data: json["data"] == null ? [] : List<CommentList>.from(json["data"]!.map((x) => CommentList.fromJson(x))),
    );
  }

}

class CommentList {
  CommentList({
    required this.id,
    required this.userId,
    required this.postId,
    required this.body,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  final String? id;
  final String? userId;
  final String? postId;
  final String? body;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final User? user;

  factory CommentList.fromJson(Map<String, dynamic> json){
    return CommentList(
      id: json["id"],
      userId: json["userId"],
      postId: json["postId"],
      body: json["body"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      user: json["user"] == null ? null : User.fromJson(json["user"]),
    );
  }

}

class User {
  User({
    required this.name,
    required this.profilePicture,
  });

  final String? name;
  final String? profilePicture;

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      name: json["name"],
      profilePicture: json["profilePicture"],
    );
  }

}
