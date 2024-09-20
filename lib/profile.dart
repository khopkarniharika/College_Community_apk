import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String profileImage = 'assets/default_profile.png'; // Default profile image
  String bio = '';
  String username = '';
  String linkedin = '';
  String github = '';
  bool isEditMode = true; // Initial mode is edit mode

  List<String> posts = ['First post content', 'Second post content']; // Mock posts

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout), // Log out icon
            onPressed: () {
              // Handle logout functionality
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
          SizedBox(height: 20),
          _buildTextField('Username', username, (value) => username = value),
          SizedBox(height: 10),
          _buildTextField('Bio', bio, (value) => bio = value),
          SizedBox(height: 10),
          _buildTextField('LinkedIn URL', linkedin, (value) => linkedin = value),
          SizedBox(height: 10),
          _buildTextField('GitHub URL', github, (value) => github = value),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                isEditMode = false;
              });
            },
            child: Text('Save Profile'),
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
                icon: Icon(Icons.edit, size: 20),
                onPressed: () {
                  setState(() {
                    isEditMode = true;
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildInfoContainer('Username', username),
          SizedBox(height: 10),
          _buildInfoContainer('Bio', bio),
          SizedBox(height: 10),
          _buildInfoContainer('LinkedIn', linkedin),
          SizedBox(height: 10),
          _buildInfoContainer('GitHub', github),
          SizedBox(height: 20),
          Divider(), // Divider between profile info and posts
          _buildPostSection(), // Post section below profile
        ],
      ),
    );
  }

  Widget _buildTextField(
      String labelText, String initialValue, ValueChanged<String> onChanged) {
    return Container(
      padding: EdgeInsets.all(8.0),
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
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blueGrey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blueGrey),
      ),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontWeight: FontWeight.bold),
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
        Text(
          'Posts',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true, // Prevent infinite scroll in the post section
          itemCount: posts.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.symmetric(vertical: 5),
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
