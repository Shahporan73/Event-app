class AllEventsModel {
  AllEventsModel({
    this.success,
    this.message,
    this.data,
  });

  final bool? success;
  final String? message;
  final Data? data;

  factory AllEventsModel.fromJson(Map<String, dynamic> json){
    return AllEventsModel(
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
  final List<EventsList> data;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
      data: json["data"] == null ? [] : List<EventsList>.from(json["data"]!.map((x) => EventsList.fromJson(x))),
    );
  }

}

class EventsList {
  EventsList({
    required this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.address,
    required this.date,
    required this.type,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.category,
    required this.location,
    required this.rating,
    required this.reviews,
  });

  final String? id;
  final String? name;
  final DateTime? startTime;
  final DateTime? endTime;
  final String? address;
  final DateTime? date;
  final String? type;
  final String? image;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Category? category;
  final Location? location;
  final dynamic rating;
  final dynamic reviews;

  factory EventsList.fromJson(Map<String, dynamic> json){
    return EventsList(
      id: json["id"],
      name: json["name"],
      startTime: DateTime.tryParse(json["startTime"] ?? ""),
      endTime: DateTime.tryParse(json["endTime"] ?? ""),
      address: json["address"],
      date: DateTime.tryParse(json["date"] ?? ""),
      type: json["type"],
      image: json["image"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      category: json["category"] == null ? null : Category.fromJson(json["category"]),
      location: json["location"] == null ? null : Location.fromJson(json["location"]),
      rating: json["rating"],
      reviews: json["reviews"],
    );
  }

}

class Category {
  Category({
    required this.id,
    required this.name,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  final String? id;
  final String? name;
  final String? image;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Category.fromJson(Map<String, dynamic> json){
    return Category(
      id: json["id"],
      name: json["name"],
      image: json["image"],
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
