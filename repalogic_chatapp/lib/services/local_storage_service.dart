import 'package:hive_flutter/hive_flutter.dart';
import '../models/message_model.dart';

class LocalStorageService {
  static const messagesBox = 'messages_box';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(messagesBox);
  }

  static Future<void> saveMessage(String roomId, MessageModel message) async {
    final box = Hive.box(messagesBox);
    final messages = box.get(roomId, defaultValue: <Map>[]);
    messages.add(message.toJson());
    await box.put(roomId, messages);
  }

  static List<MessageModel> getMessages(String roomId) {
    final box = Hive.box(messagesBox);
    final messages = box.get(roomId, defaultValue: <Map>[]);
    return (messages as List)
        .map((e) => MessageModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}
