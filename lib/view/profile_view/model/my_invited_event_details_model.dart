class MyInvitedEventDetailsModel {
  MyInvitedEventDetailsModel({
    this.success,
    this.message,
    this.data,
  });

  final bool? success;
  final String? message;
  final Data? data;

  factory MyInvitedEventDetailsModel.fromJson(Map<String, dynamic> json){
    return MyInvitedEventDetailsModel(
      success: json["success"],
      message: json["message"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.id,
    required this.userId,
    required this.eventId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.event,
  });

  final String? id;
  final String? userId;
  final String? eventId;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Event? event;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      id: json["id"],
      userId: json["userId"],
      eventId: json["eventId"],
      status: json["status"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      event: json["event"] == null ? null : Event.fromJson(json["event"]),
    );
  }

}

class Event {
  Event({
    required this.id,
    required this.name,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.address,
    required this.location,
    required this.image,
    required this.rating,
    required this.reviews,
    required this.createdAt,
    required this.updatedAt,
    required this.organizer,
    required this.aboutEvent,
  });

  final String? id;
  final String? name;
  final DateTime? date;
  final DateTime? startTime;
  final DateTime? endTime;
  final String? address;
  final Location? location;
  final String? image;
  final dynamic rating;
  final dynamic reviews;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Organizer? organizer;
  final String? aboutEvent;

  factory Event.fromJson(Map<String, dynamic> json){
    return Event(
      id: json["id"],
      name: json["name"],
      date: DateTime.tryParse(json["date"] ?? ""),
      startTime: DateTime.tryParse(json["startTime"] ?? ""),
      endTime: DateTime.tryParse(json["endTime"] ?? ""),
      address: json["address"],
      location: json["location"] == null ? null : Location.fromJson(json["location"]),
      image: json["image"],
      rating: json["rating"],
      reviews: json["reviews"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      organizer: json["organizer"] == null ? null : Organizer.fromJson(json["organizer"]),
      aboutEvent: json["aboutEvent"],
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
  final dynamic location;
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

  factory Organizer.fromJson(Map<String, dynamic> json){
    return Organizer(
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
