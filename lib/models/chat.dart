import 'package:shlus/utils/convertUrl.dart';

class Chat {
  final String id;
  final String name;
  String? lastMessage;
  final String logo;
  DateTime? lastMessageAt;
  String? lastMessageUserName;
  final String type;
  final List<dynamic> members;

  Chat({
    required this.id,
    required this.name,
    this.lastMessage,
    required this.logo,
    this.lastMessageAt,
    this.lastMessageUserName,
    required this.type,
    required this.members
  });

  factory Chat.fromJson(Map<String, dynamic> json) {


    return Chat(
      id: json["id"],
      name: json["name"],
      lastMessage: json["last_message"],
      logo: convertUrl(json["logo"]),
      lastMessageAt: json["last_message_at"] != null
        ? DateTime.parse(json["last_message_at"])
        : null,
      lastMessageUserName: json["last_message_user_name"],
      type: json["type"],
      members: json["members"] ?? []
    );

  }
}