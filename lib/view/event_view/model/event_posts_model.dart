class EventPostsModel {
  EventPostsModel({
    this.success,
    this.message,
    this.data,
  });

  final bool? success;
  final String? message;
  final Data? data;

  factory EventPostsModel.fromJson(Map<String, dynamic> json){
    return EventPostsModel(
      success: json["success"],
      message: json["message"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.id,
    required this.organizerId,
    required this.categoryId,
    required this.name,
    required this.address,
    required this.type,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.aboutEvent,
    required this.image,
    required this.location,
    required this.reviews,
    required this.rating,
    required this.isDelete,
    required this.createdAt,
    required this.updatedAt,
    required this.post,
  });

  final String? id;
  final String? organizerId;
  final String? categoryId;
  final String? name;
  final String? address;
  final String? type;
  final DateTime? date;
  final DateTime? startTime;
  final DateTime? endTime;
  final String? aboutEvent;
  final String? image;
  final Location? location;
  final dynamic reviews;
  final dynamic rating;
  final bool? isDelete;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<PostList> post;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      id: json["id"],
      organizerId: json["organizerId"],
      categoryId: json["categoryId"],
      name: json["name"],
      address: json["address"],
      type: json["type"],
      date: DateTime.tryParse(json["date"] ?? ""),
      startTime: DateTime.tryParse(json["startTime"] ?? ""),
      endTime: DateTime.tryParse(json["endTime"] ?? ""),
      aboutEvent: json["aboutEvent"],
      image: json["image"],
      location: json["location"] == null ? null : Location.fromJson(json["location"]),
      reviews: json["reviews"],
      rating: json["rating"],
      isDelete: json["isDelete"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      post: json["post"] == null ? [] : List<PostList>.from(json["post"]!.map((x) => PostList.fromJson(x))),
    );
  }

}

class Location {
  Location({
    required this.type,
    required this.coordinates,
  });

  final String? type;
  final List<dynamic> coordinates;

  factory Location.fromJson(Map<String, dynamic> json){
    return Location(
      type: json["type"],
      coordinates: json["coordinates"] == null ? [] : List<dynamic>.from(json["coordinates"]!.map((x) => x)),
    );
  }

}

class PostList {
  PostList({
    required this.id,
    required this.userId,
    required this.eventId,
    required this.body,
    required this.likeCount,
    required this.commentCount,
    required this.createdAt,
    required this.updatedAt,
    required this.files,
    required this.videos,
    required this.comment,
    required this.user,
    required this.isMeLiked,
  });

  final String? id;
  final String? userId;
  final String? eventId;
  final String? body;
  final dynamic likeCount;
  final dynamic commentCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<FileElement> files;
  final List<FileElement> videos;
  final List<Comment> comment;
  final User? user;
  final bool? isMeLiked;

  factory PostList.fromJson(Map<String, dynamic> json){
    return PostList(
      id: json["id"],
      userId: json["userId"],
      eventId: json["eventId"],
      body: json["body"],
      likeCount: json["likeCount"],
      commentCount: json["commentCount"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      files: json["files"] == null ? [] : List<FileElement>.from(json["files"]!.map((x) => FileElement.fromJson(x))),
      videos: json["videos"] == null ? [] : List<FileElement>.from(json["videos"]!.map((x) => FileElement.fromJson(x))),
      comment: json["comment"] == null ? [] : List<Comment>.from(json["comment"]!.map((x) => Comment.fromJson(x))),
      user: json["user"] == null ? null : User.fromJson(json["user"]),
      isMeLiked: json["isMeLiked"],
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

class User {
  User({
    required this.id,
    required this.name,
    required this.profilePicture,
  });

  final String? id;
  final String? name;
  final String? profilePicture;

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: json["id"],
      name: json["name"],
      profilePicture: json["profilePicture"],
    );
  }

}
