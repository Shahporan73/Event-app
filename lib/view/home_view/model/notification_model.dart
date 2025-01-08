class NotificationsModel {
  NotificationsModel({
    this.success,
    this.message,
    this.data,
  });

  final bool? success;
  final String? message;
  final Data? data;

  factory NotificationsModel.fromJson(Map<String, dynamic> json){
    return NotificationsModel(
      success: json["success"],
      message: json["message"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.meta,
    required this.data,
  });

  final Meta? meta;
  final List<NotificationList> data;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
      data: json["data"] == null ? [] : List<NotificationList>.from(json["data"]!.map((x) => NotificationList.fromJson(x))),
    );
  }

}

class NotificationList {
  NotificationList({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.data,
    required this.link,
    required this.fcmToken,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  final String? id;
  final String? userId;
  final String? title;
  final String? body;
  final dynamic data;
  final dynamic link;
  final String? fcmToken;
  final bool? isRead;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final User? user;

  factory NotificationList.fromJson(Map<String, dynamic> json){
    return NotificationList(
      id: json["id"],
      userId: json["userId"],
      title: json["title"],
      body: json["body"],
      data: json["data"],
      link: json["link"],
      fcmToken: json["fcmToken"],
      isRead: json["isRead"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      user: json["user"] == null ? null : User.fromJson(json["user"]),
    );
  }

}

class User {
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.profilePicture,
    required this.location,
    required this.phoneNumber,
    required this.fcmToken,
    required this.password,
    required this.role,
    required this.followerCount,
    required this.followingCount,
    required this.postCount,
    required this.isDelete,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  final String? id;
  final String? name;
  final String? email;
  final String? profilePicture;
  final String? location;
  final dynamic phoneNumber;
  final String? fcmToken;
  final String? password;
  final String? role;
  final int? followerCount;
  final int? followingCount;
  final int? postCount;
  final bool? isDelete;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      profilePicture: json["profilePicture"],
      location: json["location"],
      phoneNumber: json["phoneNumber"],
      fcmToken: json["fcmToken"],
      password: json["password"],
      role: json["role"],
      followerCount: json["followerCount"],
      followingCount: json["followingCount"],
      postCount: json["postCount"],
      isDelete: json["isDelete"],
      isActive: json["isActive"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
    );
  }

}

class Meta {
  Meta({
    required this.total,
    required this.page,
    required this.limit,
  });

  final int? total;
  final int? page;
  final int? limit;

  factory Meta.fromJson(Map<String, dynamic> json){
    return Meta(
      total: json["total"],
      page: json["page"],
      limit: json["limit"],
    );
  }

}
