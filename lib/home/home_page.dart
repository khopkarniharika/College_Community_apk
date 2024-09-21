import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '/pages/announcement.dart'; // Import Announcement page
import '/pages/chat_room.dart'; // Import Chat Room page
import '/pages/threads.dart'; // Import Threads page
import '/pages/academics.dart'; // Import Academics page
import '/pages/profile.dart'; // Import Profile page
import 'post_widget.dart'; // Import Post Widget

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final ImagePicker _picker = ImagePicker();
  List<File> _posts = []; // List to hold uploaded media

  // Dummy user name for demonstration
  String userName = "karan";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 199, 206, 150),
        title: Text(
          'Welcome, $userName',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              // Allow user to pick an image from gallery
              final pickedFile =
                  await _picker.pickImage(source: ImageSource.gallery);
              if (pickedFile != null) {
                setState(() {
                  _posts.add(
                      File(pickedFile.path)); // Add the picked image to posts
                });
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.campaign), // Announcements Icon
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const AnnouncementPage(isSuperUser: true),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.message), // Chat Icon
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ChatRoom(user: '')),
              );
            },
          ),
        ],
      ),
      body: _selectedIndex == 0
          ? PostWidget(posts: _posts) // Pass the list of posts to PostWidget
          : buildOtherScreens(), // Show other screens otherwise
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum),
            label: 'Threads',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Academics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget buildOtherScreens() {
    switch (_selectedIndex) {
      case 1:
        return ThreadsPage();
      case 2:
        return const AcademicsPage();
      case 3:
        return const ProfilePage();
      default:
        return Container(); // You can also return a placeholder widget here
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
