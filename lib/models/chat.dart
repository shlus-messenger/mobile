class Chat {
  final String id;
  final String name;
  String? lastMessage;
  final String logoUrl;
  DateTime? lastMessageAt;
  String? lastMessageUserName;
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

    String _getLogoUrl(String logoUrl) {

      String result = logoUrl.replaceAll("http://s3:8333", "http://10.0.2.2:8333").replaceAll("http://localhost:8333", "http://10.0.2.2:8333");

      print("Edited url: $result");

      return result;

    }

    return Chat(
      id: json["id"],
      name: json["name"],
      lastMessage: json["last_message"] ?? null,
      logoUrl: _getLogoUrl(json["logo_url"]),
      lastMessageAt: json["last_message_at"] != null
        ? DateTime.parse(json["last_message_at"])
        : null,
      lastMessageUserName: json["last_message_user_name"] ?? null,
      type: json["type"]
    );

  }
}