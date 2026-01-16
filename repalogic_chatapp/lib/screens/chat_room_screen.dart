import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/chat_room_model.dart';
import '../models/message_model.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';

const Color primaryRed = Color(0xFFBF2424);
const Color lightRed = Color(0xFFFDEAEA);

class ChatRoomScreen extends StatefulWidget {
  final ChatRoomModel room;
  final UserModel currentUser;
  final List<UserModel> allUsers;

  const ChatRoomScreen({
    super.key,
    required this.room,
    required this.currentUser,
    required this.allUsers,
  });

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController messageController = TextEditingController();

  void _sendMessage() async {
    if (messageController.text.trim().isEmpty) return;

    await firestoreService.sendMessage(
      roomId: widget.room.id,
      message: MessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: widget.currentUser.uid,
        text: messageController.text.trim(),
        timestamp: DateTime.now(),
      ),
    );

    messageController.clear();
  }

  void _showInviteDialog() {
    final translation = AppLocalizations.of(context);
    final availableUsers = widget.allUsers
        .where((u) => !widget.room.participants.contains(u.uid))
        .toList();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(translation.translate("invite_users")),

        content: SizedBox(
          height: 300, // ✅ REQUIRED FIX
          width: double.maxFinite,
          child: availableUsers.isEmpty
              ? Center(
                  child: Text(
                    translation.translate("all_users_added"),
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.builder(
                  itemCount: availableUsers.length,
                  itemBuilder: (_, index) {
                    final user = availableUsers[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: lightRed,
                        child: Text(
                          user.name[0],
                          style: const TextStyle(color: primaryRed),
                        ),
                      ),
                      title: Text(user.name),
                      trailing: IconButton(
                        icon: const Icon(Icons.person_add, color: primaryRed),
                        onPressed: () async {
                          await firestoreService.addUserToChatRoom(
                            roomId: widget.room.id,
                            userId: user.uid,
                          );

                          await firestoreService.sendMessage(
                            roomId: widget.room.id,
                            message: MessageModel(
                              id: DateTime.now().millisecondsSinceEpoch
                                  .toString(),
                              senderId: 'system',
                              text: translation.translate(
                                "user_joined_room",
                                args: {"name": user.name},
                              ),
                              timestamp: DateTime.now(),
                            ),
                          );

                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                ),
        ),

        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              translation.translate("cancel"),
              style: const TextStyle(color: primaryRed),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final translation = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        backgroundColor: primaryRed,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.room.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${widget.room.participants.length} participants',
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: _showInviteDialog,
          ),
        ],
      ),

      body: Column(
        children: [
          /// 🔹 MESSAGE LIST
          Expanded(
            child: StreamBuilder<List<MessageModel>>(
              stream: firestoreService.getMessages(widget.room.id),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!;

                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: messages.length,
                  itemBuilder: (_, index) {
                    final message = messages[messages.length - 1 - index];
                    final isMe = message.senderId == widget.currentUser.uid;
                    final isSystem = message.senderId == 'system';

                    return _messageBubble(message.text, isMe, isSystem);
                  },
                );
              },
            ),
          ),

          /// 🔹 INPUT FIELD
          SafeArea(
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(blurRadius: 4, color: Colors.black12)],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                        hintText: translation.translate("type_message"),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color: primaryRed),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: primaryRed,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _messageBubble(String text, bool isMe, bool isSystem) {
    if (isSystem) {
      return Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(text, style: const TextStyle(fontSize: 12)),
        ),
      );
    }

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 260),
        decoration: BoxDecoration(
          color: isMe ? primaryRed : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(blurRadius: 2, color: Colors.black12)],
        ),
        child: Text(
          text,
          style: TextStyle(color: isMe ? Colors.white : Colors.black87),
        ),
      ),
    );
  }
}
