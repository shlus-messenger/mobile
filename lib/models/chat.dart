class Chat {
  final String id;
  final String name;
  final String? lastMessage;
  final String logoUrl;
  final DateTime? lastMessageAt;
  final String? lastMessageUserName;
  final String type;

  Chat({
    required this.id,
    required this.name,
    this.lastMessage,
    required this.logoUrl,
    this.lastMessageAt,
    this.lastMessageUserName,
    required this.type
  });

  factory Chat.fromJson(Map<String, dynamic> json) {

    return Chat(
      id: json["id"],
      name: json["name"],
      lastMessage: json["last_message"] ?? null,
      logoUrl: "http://10.0.2.2:9000/chats/d5596c36-f013-4107-878f-5c65ba719808/logo/logo.png",
      lastMessageAt: json["last_message_at"] != null
        ? DateTime.parse(json["last_message_at"])
        : null,
      lastMessageUserName: json["last_message_user_name"] ?? null,
      type: json["type"]
    );

  }
}