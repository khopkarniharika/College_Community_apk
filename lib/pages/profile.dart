import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String profileImage = 'assets/default_profile.png'; // Default profile image
  String bio = '';
  String username = '';
  String linkedin = ''; // LinkedIn URL
  String github = ''; // GitHub URL

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _linkedinController = TextEditingController();
  final TextEditingController _githubController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _bioController.dispose();
    _linkedinController.dispose();
    _githubController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('name') ?? 'No name set';
      bio = prefs.getString('bio') ?? 'No bio available';
      linkedin = prefs.getString('linkedin') ?? '';
      github = prefs.getString('github') ?? '';
      profileImage =
          prefs.getString('profileImage') ?? 'assets/default_profile.png';
    });
  }

  // This method ensures the URL is valid and launches it
  Future<void> _launchURL(String url) async {
    if (url.isNotEmpty && !url.startsWith('http')) {
      url = 'https://$url'; // Prepend https:// if not present
    }

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch the URL')),
      );
    }
  }

  Future<void> _saveUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = _usernameController.text;
      bio = _bioController.text;
      linkedin = _linkedinController.text;
      github = _githubController.text;
    });
    await prefs.setString('name', _usernameController.text);
    await prefs.setString('bio', _bioController.text);
    await prefs.setString('linkedin', _linkedinController.text);
    await prefs.setString('github', _githubController.text);
    await prefs.setString('profileImage', profileImage);
    Navigator.pop(context); // Return to profile page after saving
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        profileImage = pickedFile.path;
      });
    }
  }

  void _openEditPage() {
    _usernameController.text = username;
    _bioController.text = bio;
    _linkedinController.text = linkedin;
    _githubController.text = github;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Edit Profile'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: profileImage.startsWith('assets')
                          ? AssetImage(profileImage) as ImageProvider
                          : FileImage(File(profileImage)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Tap to change profile picture',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(labelText: 'Username'),
                    maxLength: 25, // Limit username to 25 characters
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _bioController,
                    decoration: const InputDecoration(labelText: 'Bio'),
                    maxLength: 40, // Limit bio to 40 characters
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _linkedinController,
                    decoration:
                        const InputDecoration(labelText: 'LinkedIn URL'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _githubController,
                    decoration: const InputDecoration(labelText: 'GitHub URL'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveUserProfile,
                    child: const Text('Save Changes'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: profileImage.startsWith('assets')
                      ? AssetImage(profileImage) as ImageProvider
                      : FileImage(File(profileImage)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username,
                        style: const TextStyle(
                            fontSize:
                                20), // Changed the font size to be lighter
                      ),
                      const SizedBox(height: 4),
                      Text(
                        bio,
                        style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey), // Smaller font for bio
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          IconButton(
                            icon: const FaIcon(FontAwesomeIcons.linkedin),
                            onPressed: linkedin.isNotEmpty
                                ? () => _launchURL(linkedin)
                                : null,
                          ),
                          IconButton(
                            icon: const FaIcon(FontAwesomeIcons.github),
                            onPressed: github.isNotEmpty
                                ? () => _launchURL(github)
                                : null,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(),
            const Text(
              'Posts',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Add your post widgets here
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openEditPage, // Open the edit page when pressed
        child: const Icon(Icons.edit),
        mini: true, // Small edit button
      ),
    );
  }
}
