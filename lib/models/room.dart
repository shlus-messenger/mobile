class Room {
  final String id;
  final String name;
  final String lastMessage;
  final String logoUrl;
  final DateTime lastMessageAt;
  final String? lastMessageUserName;
  final String type;

  Room({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.logoUrl,
    required this.lastMessageAt,
    this.lastMessageUserName,
    required this.type
  });

  factory Room.fromJson(Map<String, dynamic> json) {

    return Room(
      id: json["id"],
      name: json["name"],
      lastMessage: json["last_message"],
      logoUrl: "http://10.0.2.2:9000/chats/d5596c36-f013-4107-878f-5c65ba719808/logo/logo.png",
      lastMessageAt: DateTime.parse(json["last_message_at"]),
      lastMessageUserName: json["last_message_user_name"],
      type: json["type"]
    );

  }
}