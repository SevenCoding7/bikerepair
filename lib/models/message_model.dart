import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String userId;
  final String text;
  final DateTime timestamp;
  final bool isFromUser;

  Message({
    required this.id,
    required this.userId,
    required this.text,
    required this.timestamp,
    required this.isFromUser,
  });

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'],
      userId: map['userId'],
      text: map['text'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      isFromUser: map['isFromUser'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'text': text,
      'timestamp': Timestamp.fromDate(timestamp),
      'isFromUser': isFromUser,
    };
  }
}
