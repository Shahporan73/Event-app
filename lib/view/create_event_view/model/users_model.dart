class UsersModel {
  UsersModel({
    this.success,
    this.message,
    this.data,
  });

  final bool? success;
  final String? message;
  final Data? data;

  factory UsersModel.fromJson(Map<String, dynamic> json){
    return UsersModel(
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
  final List<UserList> data;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
      data: json["data"] == null ? [] : List<UserList>.from(json["data"]!.map((x) => UserList.fromJson(x))),
    );
  }

}

class UserList {
  UserList({
    required this.id,
    required this.email,
    required this.name,
    required this.phoneNumber,
    required this.role,
    required this.location,
    required this.profilePicture,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
  });

  final dynamic id;
  final String? email;
  final String? name;
  final String? phoneNumber;
  final String? role;
  final String? location;
  final String? profilePicture;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? isActive;

  factory UserList.fromJson(Map<String, dynamic> json){
    return UserList(
      id: json["id"],
      email: json["email"],
      name: json["name"],
      phoneNumber: json["phoneNumber"],
      role: json["role"],
      location: json["location"],
      profilePicture: json["profilePicture"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      isActive: json["isActive"],
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
