import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String profileImage = 'assets/default_profile.png'; // Default profile image
  String bio = '';
  String username = '';
  String linkedin = '';
  String github = '';
  bool isEditMode = false; // Changed to false for initial display mode

  List<String> posts = [
    'First post content',
    'Second post content'
  ]; // Mock posts

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout), // Log out icon
            onPressed: () {
              _logout();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isEditMode ? _buildEditProfile() : _buildDisplayProfile(),
      ),
    );
  }

  void _logout() {
    // Clear saved state here if you're using shared preferences or any state management
    Navigator.of(context)
        .pushReplacementNamed('/login'); // Navigate to login page
  }

  Widget _buildEditProfile() {
    return SingleChildScrollView(
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              // Add functionality to change the profile image
            },
            child: CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage(profileImage),
            ),
          ),
          const SizedBox(height: 20),
          _buildTextField('Username', username, (value) => username = value),
          const SizedBox(height: 10),
          _buildTextField('Bio', bio, (value) => bio = value),
          const SizedBox(height: 10),
          _buildTextField(
              'LinkedIn URL', linkedin, (value) => linkedin = value),
          const SizedBox(height: 10),
          _buildTextField('GitHub URL', github, (value) => github = value),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                isEditMode = false;
              });
            },
            child: const Text('Save Profile'),
          ),
        ],
      ),
    );
  }

  Widget _buildDisplayProfile() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage(profileImage),
              ),
              IconButton(
                icon: const Icon(Icons.edit, size: 20),
                onPressed: () {
                  setState(() {
                    isEditMode = true;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildInfoContainer('Username', username),
          const SizedBox(height: 10),
          _buildInfoContainer('Bio', bio),
          const SizedBox(height: 10),
          _buildInfoContainer('LinkedIn', linkedin),
          const SizedBox(height: 10),
          _buildInfoContainer('GitHub', github),
          const SizedBox(height: 20),
          const Divider(), // Divider between profile info and posts
          _buildPostSection(), // Post section below profile
        ],
      ),
    );
  }

  Widget _buildTextField(
      String labelText, String initialValue, ValueChanged<String> onChanged) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        decoration: InputDecoration(
          labelText: labelText,
          border: InputBorder.none,
        ),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildInfoContainer(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blueGrey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blueGrey),
      ),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value.isEmpty ? 'Not provided' : value),
        ],
      ),
    );
  }

  Widget _buildPostSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Posts',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true, // Prevent infinite scroll in the post section
          itemCount: posts.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: ListTile(
                title: Text('Post #${index + 1}'),
                subtitle: Text(posts[index]),
              ),
            );
          },
        ),
      ],
    );
  }
}
