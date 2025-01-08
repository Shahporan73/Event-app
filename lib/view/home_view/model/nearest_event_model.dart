class NearestEventModel {
  NearestEventModel({
    this.success,
    this.message,
    this.data,
  });

  final bool? success;
  final String? message;
  final List<NearbyEventList>? data;

  factory NearestEventModel.fromJson(Map<String, dynamic> json){
    return NearestEventModel(
      success: json["success"],
      message: json["message"],
      data: json["data"] == null ? [] : List<NearbyEventList>.from(json["data"]!.map((x) => NearbyEventList.fromJson(x))),
    );
  }

}

class NearbyEventList {
  NearbyEventList({
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
    required this.distance,
    required this.rating,
    required this.reviews,
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
  final List<double> location;
  final String? distance;
  final dynamic rating;
  final dynamic reviews;

  factory NearbyEventList.fromJson(Map<String, dynamic> json){
    return NearbyEventList(
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
      location: json["location"] == null ? [] : List<double>.from(json["location"]!.map((x) => x)),
      distance: json["distance"],
      rating: json["rating"],
      reviews: json["reviews"],
    );
  }

}
