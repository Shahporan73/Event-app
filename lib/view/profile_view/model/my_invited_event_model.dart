class MyInvitedEventModel {
  MyInvitedEventModel({
    this.success,
    this.message,
    this.data,
  });

  final bool? success;
  final String? message;
  final List<MyInvitedEventList>? data;

  factory MyInvitedEventModel.fromJson(Map<String, dynamic> json){
    return MyInvitedEventModel(
      success: json["success"],
      message: json["message"],
      data: json["data"] == null ? [] : List<MyInvitedEventList>.from(json["data"]!.map((x) => MyInvitedEventList.fromJson(x))),
    );
  }

}

class MyInvitedEventList {
  MyInvitedEventList({
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

  factory MyInvitedEventList.fromJson(Map<String, dynamic> json){
    return MyInvitedEventList(
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
