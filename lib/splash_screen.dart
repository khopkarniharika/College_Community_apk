import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Start the timer for the splash screen duration (3 seconds)
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacementNamed(
          context, '/login'); // Navigate to Login page
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set your desired background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.jpeg', // Place your logo image in the assets folder
              width: 300, // Increased logo size
              height: 300,
            ),
            const SizedBox(height: 20),
            // No text or loading indicator
          ],
        ),
      ),
    );
  }
}
