class MediaModel {
  MediaModel({
    this.success,
    this.message,
    this.data,
  });

  final bool? success;
  final String? message;
  final MediaList? data;

  factory MediaModel.fromJson(Map<String, dynamic> json){
    return MediaModel(
      success: json["success"],
      message: json["message"],
      data: json["data"] == null ? null : MediaList.fromJson(json["data"]),
    );
  }

}

class MediaList {
  MediaList({
    required this.id,
    required this.eventId,
    required this.createdAt,
    required this.isCommunity,
    required this.communityName,
    required this.communityProfile,
    required this.updatedAt,
    required this.message,
  });

  final String? id;
  final String? eventId;
  final DateTime? createdAt;
  final bool? isCommunity;
  final String? communityName;
  final String? communityProfile;
  final DateTime? updatedAt;
  final List<Message> message;

  factory MediaList.fromJson(Map<String, dynamic> json){
    return MediaList(
      id: json["id"],
      eventId: json["eventId"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      isCommunity: json["isCommunity"],
      communityName: json["communityName"],
      communityProfile: json["communityProfile"],
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      message: json["message"] == null ? [] : List<Message>.from(json["message"]!.map((x) => Message.fromJson(x))),
    );
  }

}

class Message {
  Message({
    required this.files,
    required this.videos,
  });

  final List<String> files;
  final List<dynamic> videos;

  factory Message.fromJson(Map<String, dynamic> json){
    return Message(
      files: json["files"] == null ? [] : List<String>.from(json["files"]!.map((x) => x)),
      videos: json["videos"] == null ? [] : List<dynamic>.from(json["videos"]!.map((x) => x)),
    );
  }

}
