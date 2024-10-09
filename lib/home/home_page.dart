import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '/pages/announcement.dart';
import '/pages/threads.dart';
import '/pages/academics.dart';
import '/pages/profile.dart';
import '/home/PostWidget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage; // Variable to hold the selected image
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
            onPressed: _pickImage, // Use this to pick an image
          ),
          IconButton(
            icon: const Icon(Icons.campaign),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AnnouncementPage(isSuperUser: true),
                ),
              );
            },
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBody() {
    return _selectedIndex == 0
        ? StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('posts').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("No posts yet."));
              }

              // Map Firestore documents to a list of post data
              List<Map<String, dynamic>> postsFromFirestore = snapshot.data!.docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return {
                  'imageUrl': data['imageUrl'] as String? ?? '',
                  'upvotes': data['upvotes'] ?? 0,
                  'downvotes': data['downvotes'] ?? 0,
                };
              }).toList();

              return PostWidget(posts: postsFromFirestore); // Update PostWidget to accept List<Map<String, dynamic>>
            },
          )
        : buildOtherScreens();
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.forum),
          label: 'Message',
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
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path); // Store selected image
      });

      // Automatically upload after picking an image
      _uploadImageAndSavePost(_selectedImage!);
    }
  }

  Future<void> _uploadImageAndSavePost(File imageFile) async {
    try {
      // Upload image to Firebase Storage
      String fileName = 'posts/${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference storageReference = _storage.ref().child(fileName);
      UploadTask uploadTask = storageReference.putFile(imageFile);
      await uploadTask;

      // Get the download URL of the uploaded image
      String downloadUrl = await storageReference.getDownloadURL();

      // Save the post information to Firestore
      await _firestore.collection('posts').add({
        'username': userName,
        'imageUrl': downloadUrl,
        'upvotes': 0, // Initialize upvotes
        'downvotes': 0, // Initialize downvotes
        'timestamp': FieldValue.serverTimestamp(),
      });

      print('Post uploaded successfully!');
      // Clear the selected image
      setState(() {
        _selectedImage = null;
      });
    } catch (e) {
      print('Error uploading post: $e');
    }
  }

  Widget buildOtherScreens() {
    switch (_selectedIndex) {
      case 1:
        return const ThreadsPage();
      case 2:
        return const AcademicsPage();
      case 3:
        return const ProfilePage();
      default:
        return Container(); // Placeholder widget
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
