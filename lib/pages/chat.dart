import 'package:flutter/material.dart';
import 'chat_room.dart'; // Import the chat room

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final List<String> users = [
    "Alice",
    "Bob",
    "Charlie",
    "David",
    "Eve"
  ]; // Sample user list
  final List<String> recentChats = []; // List to hold recent chats
  String searchQuery = '';

  List<String> get filteredUsers {
    return users
        .where((user) => user.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  void openChatRoom(String user) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatRoom(user: user)),
    ).then((_) {
      setState(() {
        if (!recentChats.contains(user)) {
          recentChats.add(user); // Add to recent chats if not already present
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value; // Update search query
                });
              },
            ),
          ),
          const SizedBox(height: 8.0),
          SizedBox(
            height: 80.0, // Height for recent chats section
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: recentChats.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    openChatRoom(recentChats[index]); // Open chat room on tap
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Center(child: Text(recentChats[index])),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredUsers[index]),
                  onTap: () {
                    openChatRoom(filteredUsers[index]); // Open chat room
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
