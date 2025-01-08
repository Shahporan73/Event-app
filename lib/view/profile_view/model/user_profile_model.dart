class UserProfileModel {
  UserProfileModel({
    this.success,
    this.message,
    this.data,
  });

  final bool? success;
  final String? message;
  final Data? data;

  factory UserProfileModel.fromJson(Map<String, dynamic> json){
    return UserProfileModel(
      success: json["success"],
      message: json["message"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.id,
    required this.email,
    required this.name,
    required this.location,
    required this.profilePicture,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
    required this.phoneNumber,
    required this.followerCount,
    required this.followingCount,
    required this.postCount,
    required this.post,
  });

  final String? id;
  final String? email;
  final String? name;
  final String? location;
  final String? profilePicture;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? isActive;
  final String? phoneNumber;
  final int? followerCount;
  final int? followingCount;
  final int? postCount;
  final List<Post> post;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      id: json["id"],
      email: json["email"],
      name: json["name"],
      location: json["location"],
      profilePicture: json["profilePicture"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      isActive: json["isActive"],
      phoneNumber: json["phoneNumber"],
      followerCount: json["followerCount"],
      followingCount: json["followingCount"],
      postCount: json["postCount"],
      post: json["post"] == null ? [] : List<Post>.from(json["post"]!.map((x) => Post.fromJson(x))),
    );
  }

}

class Post {
  Post({
    required this.id,
    required this.userId,
    required this.eventId,
    required this.body,
    required this.likeCount,
    required this.commentCount,
    required this.createdAt,
    required this.updatedAt,
    required this.like,
    required this.comment,
    required this.files,
    required this.videos,
  });

  final String? id;
  final String? userId;
  final String? eventId;
  final String? body;
  final int? likeCount;
  final int? commentCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<Comment> like;
  final List<Comment> comment;
  final List<FileElement> files;
  final List<FileElement> videos;

  factory Post.fromJson(Map<String, dynamic> json){
    return Post(
      id: json["id"],
      userId: json["userId"],
      eventId: json["eventId"],
      body: json["body"],
      likeCount: json["likeCount"],
      commentCount: json["commentCount"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      like: json["like"] == null ? [] : List<Comment>.from(json["like"]!.map((x) => Comment.fromJson(x))),
      comment: json["comment"] == null ? [] : List<Comment>.from(json["comment"]!.map((x) => Comment.fromJson(x))),
      files: json["files"] == null ? [] : List<FileElement>.from(json["files"]!.map((x) => FileElement.fromJson(x))),
      videos: json["videos"] == null ? [] : List<FileElement>.from(json["videos"]!.map((x) => FileElement.fromJson(x))),
    );
  }

}

class Comment {
  Comment({
    required this.id,
    required this.userId,
    required this.postId,
    required this.body,
    required this.createdAt,
    required this.updatedAt,
  });

  final String? id;
  final String? userId;
  final String? postId;
  final String? body;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Comment.fromJson(Map<String, dynamic> json){
    return Comment(
      id: json["id"],
      userId: json["userId"],
      postId: json["postId"],
      body: json["body"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
    );
  }

}

class FileElement {
  FileElement({
    required this.id,
    required this.userId,
    required this.postId,
    required this.url,
    required this.key,
    required this.createdAt,
    required this.updatedAt,
  });

  final String? id;
  final String? userId;
  final String? postId;
  final String? url;
  final String? key;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory FileElement.fromJson(Map<String, dynamic> json){
    return FileElement(
      id: json["id"],
      userId: json["userId"],
      postId: json["postId"],
      url: json["url"],
      key: json["key"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
    );
  }

}
