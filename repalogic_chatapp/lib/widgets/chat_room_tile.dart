import 'package:flutter/material.dart';
import '../models/chat_room_model.dart';

class ChatRoomTile extends StatelessWidget {
  final ChatRoomModel room;
  final VoidCallback onTap;
  const ChatRoomTile({super.key, required this.room, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(room.name),
      subtitle: Text('Participants: ${room.participants.length}'),
      onTap: onTap,
    );
  }
}

