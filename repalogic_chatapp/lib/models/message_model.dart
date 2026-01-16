import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String id;
  String senderId;
  String text;
  DateTime timestamp;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'senderId': senderId,
    'text': text,
    'timestamp': Timestamp.fromDate(timestamp), // Firestore Timestamp
  };

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    final ts = json['timestamp'];

    return MessageModel(
      id: json['id'] ?? '',
      senderId: json['senderId'] ?? '',
      text: json['text'] ?? '',
      timestamp: ts is Timestamp
          ? ts.toDate()
          : DateTime.now(), // fallback for first snapshot
    );
  }

}


