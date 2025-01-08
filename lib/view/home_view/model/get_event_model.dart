class GetEventModel {
  GetEventModel({
    this.success,
    this.message,
    this.data,
  });

  final bool? success;
  final String? message;
  final Data? data;

  factory GetEventModel.fromJson(Map<String, dynamic> json){
    return GetEventModel(
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
    required this.category,
    required this.organizer,
    required this.recommendedUser,
    required this.recommendableUsers,
    required this.isMeInvited,
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
  final Category? category;
  final Organizer? organizer;
  final List<RecommendedUser> recommendedUser;
  final List<Organizer> recommendableUsers;
  final bool? isMeInvited;

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
      category: json["category"] == null ? null : Category.fromJson(json["category"]),
      organizer: json["organizer"] == null ? null : Organizer.fromJson(json["organizer"]),
      recommendedUser: json["recommendedUser"] == null ? [] : List<RecommendedUser>.from(json["recommendedUser"]!.map((x) => RecommendedUser.fromJson(x))),
      recommendableUsers: json["recommendableUsers"] == null ? [] : List<Organizer>.from(json["recommendableUsers"]!.map((x) => Organizer.fromJson(x))),
      isMeInvited: json["isMeInvited"],
    );
  }

}

class Category {
  Category({
    required this.image,
    required this.name,
    required this.id,
  });

  final String? image;
  final String? name;
  final String? id;

  factory Category.fromJson(Map<String, dynamic> json){
    return Category(
      image: json["image"],
      name: json["name"],
      id: json["id"],
    );
  }

}

class Location {
  Location({
    required this.type,
    required this.coordinates,
  });

  final String? type;
  final List<double> coordinates;

  factory Location.fromJson(Map<String, dynamic> json){
    return Location(
      type: json["type"],
      coordinates: json["coordinates"] == null ? [] : List<double>.from(json["coordinates"]!.map((x) => x)),
    );
  }

}

class Organizer {
  Organizer({
    required this.id,
    required this.name,
    required this.profilePicture,
  });

  final String? id;
  final String? name;
  final String? profilePicture;

  factory Organizer.fromJson(Map<String, dynamic> json){
    return Organizer(
      id: json["id"],
      name: json["name"],
      profilePicture: json["profilePicture"],
    );
  }

}

class RecommendedUser {
  RecommendedUser({
    required this.status,
    required this.user,
  });

  final String? status;
  final Organizer? user;

  factory RecommendedUser.fromJson(Map<String, dynamic> json){
    return RecommendedUser(
      status: json["status"],
      user: json["user"] == null ? null : Organizer.fromJson(json["user"]),
    );
  }

}
