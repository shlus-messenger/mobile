class Reply {
  final String id;
  final String userName;
  final String body;

  Reply({
    required this.id,
    required this.userName,
    required this.body,
  });

  factory Reply.fromJson(Map<String, dynamic> json) {

    return Reply(
      id: json["id"],
      userName: json["user_name"],
      body: json["body"]
    );

  }

}