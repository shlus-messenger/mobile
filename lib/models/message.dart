import 'package:shlus/models/reaction.dart';
import 'package:shlus/models/reply.dart';
import 'package:shlus/utils/convertUrl.dart';

class Message {
  final String id;
  final String userId;
  final String userName;
  final String body;
  final String avatar;
  final DateTime date;
  final Reply? replyTo;
  final List<Reaction>? reactions;

  Message({
    required this.id,
    required this.userId,
    required this.userName,
    required this.body,
    required this.date,
    required this.avatar,
    this.replyTo,
    this.reactions
  });

  factory Message.fromJson(Map<String, dynamic> json) {

    return Message(
      id: json["id"],
      userId: json["user_id"],
      userName: json["user_name"],
      avatar: convertUrl(json["avatar"]),
      body: json["body"],
      date: DateTime.parse(json["inserted_at"]),
      replyTo: json["reply_to"] != null ? Reply.fromJson(json["reply_to"] as Map<String, dynamic>) : null,
      reactions: json["reactions"] != null
        ? (json["reactions"] as List)
            .map((reaction) => Reaction.fromJson(reaction as Map<String, dynamic>))
            .toList()
        : []
    );

  }

}