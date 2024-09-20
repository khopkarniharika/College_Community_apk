import 'package:flutter/material.dart';
import 'Login.dart';  // Import the Login screen
import 'Signup.dart'; // Import the Signup screen
import 'home.dart'; // Import the Home page
import 'chat.dart'; // Import the ChatList page
import 'announcement.dart'; // Import the Announcement page

void main() {
  runApp(CollegeCommunityApp());
}

class CollegeCommunityApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'College Community APK',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',  // Start with the login screen
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/home': (context) => HomePage(), // Add the home route here
        '/chat': (context) => ChatList(), // Route for chat
        '/announcement': (context) => AnnouncementPage(isSuperUser: false), // Example route for announcements
      },
      // Optional: Handle unknown routes
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (context) => LoginScreen()); // Redirect to login on unknown routes
      },
    );
  }
}
