class MessagesModel {
  MessagesModel({
    this.success,
    this.message,
    this.data,
  });

  final bool? success;
  final String? message;
  final List<Messages>? data;

  factory MessagesModel.fromJson(Map<String, dynamic> json){
    return MessagesModel(
      success: json["success"],
      message: json["message"],
      data: json["data"] == null ? [] : List<Messages>.from(json["data"]!.map((x) => Messages.fromJson(x))),
    );
  }

}

class Messages {
  Messages({
    required this.id,
    required this.senderId,
    required this.chatId,
    required this.content,
    required this.notification,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    required this.sender,
  });

  final String? id;
  final String? senderId;
  final String? chatId;
  final String? content;
  final dynamic notification;
  final dynamic type;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Sender? sender;

  factory Messages.fromJson(Map<String, dynamic> json){
    return Messages(
      id: json["id"],
      senderId: json["senderId"],
      chatId: json["chatId"],
      content: json["content"],
      notification: json["notification"],
      type: json["type"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      sender: json["sender"] == null ? null : Sender.fromJson(json["sender"]),
    );
  }

}

class Sender {
  Sender({
    required this.id,
    required this.name,
    required this.profilePicture,
  });

  final String? id;
  final String? name;
  final String? profilePicture;

  factory Sender.fromJson(Map<String, dynamic> json){
    return Sender(
      id: json["id"],
      name: json["name"],
      profilePicture: json["profilePicture"],
    );
  }

}
