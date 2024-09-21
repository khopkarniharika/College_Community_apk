import 'package:flutter/material.dart';
import 'dart:io';

class PostWidget extends StatelessWidget {
  final List<File> posts; // List of posts to display

  const PostWidget({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Posts',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),

        // Display uploaded posts
        Expanded(
          child: ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                child: Container(
                  height: 300,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(posts[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
