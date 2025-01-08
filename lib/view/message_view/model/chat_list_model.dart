class ChatListModel {
  ChatListModel({
    this.success,
    this.message,
    this.data,
  });

  final bool? success;
  final String? message;
  final List<ChatList>? data;

  factory ChatListModel.fromJson(Map<String, dynamic> json){
    return ChatListModel(
      success: json["success"],
      message: json["message"],
      data: json["data"] == null ? [] : List<ChatList>.from(json["data"]!.map((x) => ChatList.fromJson(x))),
    );
  }

}

class ChatList {
  ChatList({
    required this.id,
    required this.participant,
    required this.isCommunity,
    required this.lastMessage,
    required this.communityProfile,
    required this.communityName,
    required this.unseenMessageCount,
    required this.event,
  });

  final String? id;
  final List<Participant> participant;
  final bool? isCommunity;
  final LastMessage? lastMessage;
  final String? communityProfile;
  final String? communityName;
  final int? unseenMessageCount;
  final Event? event;

  factory ChatList.fromJson(Map<String, dynamic> json){
    return ChatList(
      id: json["id"],
      participant: json["participant"] == null ? [] : List<Participant>.from(json["participant"]!.map((x) => Participant.fromJson(x))),
      isCommunity: json["isCommunity"],
      lastMessage: json["lastMessage"] == null ? null : LastMessage.fromJson(json["lastMessage"]),
      communityProfile: json["communityProfile"],
      communityName: json["communityName"],
      unseenMessageCount: json["unseenMessageCount"],
      event: json["event"] == null ? null : Event.fromJson(json["event"]),
    );
  }

}

class Event {
  Event({
    required this.organizerId,
  });

  final String? organizerId;

  factory Event.fromJson(Map<String, dynamic> json){
    return Event(
      organizerId: json["organizerId"],
    );
  }

}

class LastMessage {
  LastMessage({
    required this.id,
    required this.senderId,
    required this.chatId,
    required this.content,
    required this.files,
    required this.videos,
    required this.notification,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  final String? id;
  final String? senderId;
  final String? chatId;
  final String? content;
  final List<String> files;
  final List<String> videos;
  final dynamic notification;
  final String? type;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory LastMessage.fromJson(Map<String, dynamic> json){
    return LastMessage(
      id: json["id"],
      senderId: json["senderId"],
      chatId: json["chatId"],
      content: json["content"],
      files: json["files"] == null ? [] : List<String>.from(json["files"]!.map((x) => x)),
      videos: json["videos"] == null ? [] : List<String>.from(json["videos"]!.map((x) => x)),
      notification: json["notification"],
      type: json["type"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
    );
  }

}

class Participant {
  Participant({
    required this.user,
  });

  final User? user;

  factory Participant.fromJson(Map<String, dynamic> json){
    return Participant(
      user: json["user"] == null ? null : User.fromJson(json["user"]),
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
