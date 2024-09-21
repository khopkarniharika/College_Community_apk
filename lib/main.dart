import 'package:college_community_apk/home/home_page.dart';
import 'package:flutter/material.dart';
import 'auth/login.dart'; // Import the Login screen
import 'auth/signup.dart'; // Import the Signup screen
import 'pages/chat.dart'; // Import the ChatList page
import 'pages/announcement.dart'; // Import the Announcement page
import 'splash_screen.dart'; // Import the Splash Screen

void main() {
  runApp(const CollegeCommunityApp());
}

class CollegeCommunityApp extends StatelessWidget {
  const CollegeCommunityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'College Community APK',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/', // Start with the splash screen
      routes: {
        '/': (context) => const SplashScreen(), // Splash screen route
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(), // Ensure this is const
        '/home/home_page': (context) => const HomePage(), // Home route
        '/chat': (context) => const ChatList(), // Route for chat
        '/announcement': (context) => const AnnouncementPage(
            isSuperUser: false), // Route for announcements
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ); // Redirect to login on unknown routes
      },
    );
  }
}
