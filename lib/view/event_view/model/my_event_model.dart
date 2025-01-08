class MyEventsModel {
  MyEventsModel({
    this.success,
    this.message,
    this.data,
  });

  final bool? success;
  final String? message;
  final List<MyEventList>? data;

  factory MyEventsModel.fromJson(Map<String, dynamic> json){
    return MyEventsModel(
      success: json["success"],
      message: json["message"],
      data: json["data"] == null ? [] : List<MyEventList>.from(json["data"]!.map((x) => MyEventList.fromJson(x))),
    );
  }

}

class MyEventList {
  MyEventList({
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

  factory MyEventList.fromJson(Map<String, dynamic> json){
    return MyEventList(
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
  var rating;
  final bool? isDelete;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Event.fromJson(Map<String, dynamic> json){
    return Event(
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
