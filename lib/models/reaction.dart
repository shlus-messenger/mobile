class Reaction {
  final int id;
  final String messageId;
  final String userId;
  final String userName;
  final String emoji;
  final DateTime date;

  Reaction({
    required this.id,
    required this.messageId,
    required this.userId,
    required this.userName,
    required this.emoji,
    required this.date
  });

  factory Reaction.fromJson(Map<String, dynamic> json) {

    return Reaction(
      id: json["id"],
      messageId: json["message_id"],
      userId: json["user_id"],
      userName: json["user_name"],
      emoji: json["emoji"],
      date: DateTime.parse(json["date"]),
    );

  }

}