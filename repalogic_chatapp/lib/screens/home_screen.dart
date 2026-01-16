import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/user_model.dart';
import '../models/chat_room_model.dart';
import '../services/firestore_service.dart';
import '../widgets/chat_room_tile.dart';
import 'chat_room_screen.dart';

class HomeScreen extends StatefulWidget {
  final List<UserModel> users;
  const HomeScreen({super.key, required this.users});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late UserModel currentUser;
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController roomNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    currentUser = widget.users.first;
  }


  @override
  Widget build(BuildContext context) {
    final translation = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryRed,
        iconTheme: const IconThemeData(color: Colors.white),
        title:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              translation.translate("chat_rooms"),
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2),
            Text(
              translation.translate("connect_and_chat"),

              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _buildUserSwitcher(),
          ),
        ],
      ),

      body: StreamBuilder<List<ChatRoomModel>>(
        stream: firestoreService.getChatRooms(currentUser.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final rooms = snapshot.data ?? [];

          if (rooms.isEmpty) {
            return _buildEmptyState(translation);
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: rooms.length,
            itemBuilder: (_, index) {
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ChatRoomTile(
                  room: rooms[index],
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatRoomScreen(
                        room: rooms[index],
                        currentUser: currentUser,
                        allUsers: widget.users,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primaryRed,
        icon: const Icon(Icons.add, color: Colors.white),
        label:  Text(

          translation.translate("new_room"),
          style: TextStyle(color: Colors.white),
        ),
        onPressed: _showCreateRoomSheet,
      ),
    );
  }


  /// 🔽 USER SWITCHER
  Widget _buildUserSwitcher() {
    return PopupMenuButton<UserModel>(
      tooltip: 'Switch User',
      onSelected: (user) => setState(() => currentUser = user),
      itemBuilder: (context) {
        return widget.users.map((u) {
          return PopupMenuItem(
            value: u,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: primaryRed,
                  child: Text(
                    u.name[0],
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 8),
                Text(u.name),
              ],
            ),
          );
        }).toList();
      },
      child: Chip(
        backgroundColor: Colors.white,
        avatar: CircleAvatar(
          backgroundColor: primaryRed,
          child: Text(
            currentUser.name[0],
            style: const TextStyle(color: Colors.white),
          ),
        ),
        label: Text(
          currentUser.name,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }


  /// 📭 EMPTY STATE
  Widget _buildEmptyState( AppLocalizations translation) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: primaryRed.withAlpha(102),

          ),
          const SizedBox(height: 16),
        Text(

              translation.translate("no_rooms"),

            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
           Text(
             translation.translate("createroom_start_chatting"),

            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }


  /// 🆕 CREATE ROOM BOTTOM SHEET
  void _showCreateRoomSheet() {
    roomNameController.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(

              'Create Chat Room',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: roomNameController,
              decoration: const InputDecoration(
                labelText: 'Room Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child:

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryRed,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  if (roomNameController.text.trim().isEmpty) return;

                  final room = ChatRoomModel(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: roomNameController.text.trim(),
                    participants: [currentUser.uid],
                  );

                  await firestoreService.createChatRoom(room);
                  Navigator.pop(context);
                },
                child: const Text(
                  'Create Room',
                  style: TextStyle(color: Colors.white),
                ),
              ),

            ),
          ],
        ),
      ),
    );
  }
}
