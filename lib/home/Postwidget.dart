import 'package:flutter/material.dart';

class PostWidget extends StatefulWidget {
  final List<Map<String, dynamic>> posts; // List of posts with metadata

  const PostWidget({super.key, required this.posts});

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  // Function to handle delete post
  void _deletePost(int index) {
    setState(() {
      // Remove the post from the local list
      widget.posts.removeAt(index);
    });
    // Optionally, you may want to add Firestore deletion logic here
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.posts.length,
      itemBuilder: (context, index) {
        final post = widget.posts[index];
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: Image.network(
                  post['imageUrl'], // Displaying image from the URL
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Anonymous Post', // No username displayed
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.thumb_up, color: Colors.green),
                        onPressed: () {
                          setState(() {
                            post['upvotes'] = (post['upvotes'] ?? 0) + 1;
                          });
                        },
                      ),
                      Text(post['upvotes'].toString()), // Display upvote count
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.thumb_down, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            post['downvotes'] = (post['downvotes'] ?? 0) + 1;
                          });
                        },
                      ),
                      Text(post['downvotes'].toString()), // Display downvote count
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.black),
                    onPressed: () => _deletePost(index), // Delete post
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
