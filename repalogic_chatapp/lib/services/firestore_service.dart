import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../models/chat_room_model.dart';
import '../models/message_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat_room_model.dart';
import '../models/message_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createChatRoom(ChatRoomModel room) async {
    await _db.collection('chat_rooms').doc(room.id).set(room.toJson());
  }

  Future<void> sendMessage({
    required String roomId,
    required MessageModel message,
  }) async {
    final messagesRef = _db.collection('chat_rooms').doc(roomId).collection('messages');
    await messagesRef.doc(message.id).set(message.toJson());
  }

  Stream<List<MessageModel>> getMessages(String roomId) {
    debugPrint("🔥 getMessages called for roomId: $roomId");

    return _db
        .collection('chat_rooms')
        .doc(roomId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .handleError((error) {
      debugPrint("❌ Firestore Stream Error: $error");
    })
        .map((snapshot) {
      debugPrint("📩 Snapshot received. Docs count: ${snapshot.docs.length}");
print("TAG ddd33333333");
      final messages = snapshot.docs.map((doc) {
        final data = doc.data();
        debugPrint("📄 Raw doc: $data");
        return MessageModel.fromJson(data);
      }).toList();
      print("TAG ddd2bgbgbg2222222");
      print(messages.length);
print("TAG ddd22222222");
      for (var m in messages) {
        print("TAG kkk888888888888");
        debugPrint(
            "✅ Message => sender: ${m.senderId}, text: ${m.text}, time: ${m.timestamp}");
      }

      return messages;
    });
  }



  Stream<List<ChatRoomModel>> getChatRooms(String userId) {
    return _db
        .collection('chat_rooms')
        .where('participants', arrayContains: userId)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => ChatRoomModel.fromJson(doc.data())).toList());
  }
  Future<void> addUserToChatRoom({
    required String roomId,
    required String userId,
  }) async {
    final roomRef = _db.collection('chat_rooms').doc(roomId);

    try {
      await roomRef.update({
        'participants': FieldValue.arrayUnion([userId]),
      });
    } catch (e) {
      print("Error adding user to chat room: $e");
      rethrow;
    }
  }
}


