class Message {
  final String userId;
  final String userName;
  final String body;
  final DateTime date;

  Message({
    required this.userId,
    required this.userName,
    required this.body,
    required this.date
  });

  factory Message.fromJson(Map<String, dynamic> json) {

    print("JSON в Message: $json");

    return Message(
      userId: json["user_id"],
      userName: json["user_name"],
      body: json["body"],
      date: DateTime.parse(json["inserted_at"])
    );

  }

}