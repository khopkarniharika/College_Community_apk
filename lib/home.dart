import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'announcement.dart'; // Import Announcement page
import 'chat_room.dart'; // Import Chat Room page
import 'threads.dart'; // Import Threads page
import 'academics.dart'; // Import Academics pages
import 'profile.dart'; // Import Profile page

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // Dummy user name for demonstration, replace with actual user info
  String userName = "John Doe";

  List<Post> posts = [
    Post(title: 'First Post', content: 'This is the first post'),
    Post(title: 'Second Post', content: 'This is the second post'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 199, 206, 150),
        title: Text(
          'Welcome, $userName', // Dynamic title (use user name or something useful)
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add), // Add Post Icon
            onPressed: () {
              _showAddPostDialog();
            },
          ),
          IconButton(
            icon: const Icon(Icons.campaign), // Announcements Icon
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AnnouncementPage(isSuperUser: true),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.message), // Chat Icon
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatRoom(user: '')),
              );
            },
          ),
        ],
      ),
      body: _selectedIndex == 0 ? buildPostList() : buildOtherScreens(),
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

  void _showAddPostDialog() {
    TextEditingController titleController = TextEditingController();
    TextEditingController contentController = TextEditingController();
    TextEditingController mediaController = TextEditingController(); // For image/video URL
    bool isVideo = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add a new post'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(hintText: 'Post Title'),
              ),
              TextField(
                controller: contentController,
                decoration: InputDecoration(hintText: 'Post Content'),
              ),
              TextField(
                controller: mediaController,
                decoration: InputDecoration(hintText: 'Media URL (Optional)'),
              ),
              Row(
                children: [
                  Checkbox(
                    value: isVideo,
                    onChanged: (bool? value) {
                      setState(() {
                        isVideo = value!;
                      });
                    },
                  ),
                  Text('Is this a video?'),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                String title = titleController.text;
                String content = contentController.text;
                String? mediaUrl = mediaController.text.isNotEmpty ? mediaController.text : null;
                if (title.isNotEmpty && content.isNotEmpty) {
                  setState(() {
                    posts.add(Post(
                      title: title,
                      content: content,
                      mediaUrl: mediaUrl,
                      isVideo: isVideo,
                    ));
                  });
                  titleController.clear();
                  contentController.clear();
                  Navigator.of(context).pop();
                }
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Widget buildPostList() {
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return PostWidget(
          post: posts[index],
          onLike: () {
            setState(() {
              posts[index].likes++;
            });
          },
          onComment: (comment) {
            setState(() {
              posts[index].comments.add(comment);
            });
          },
        );
      },
    );
  }

  Widget buildOtherScreens() {
    switch (_selectedIndex) {
      case 1:
        return ThreadsPage(); // Navigate to the ThreadsPage
      case 2:
        return AcademicsPage(); // Navigate to the AcademicsPage
      case 3:
        return ProfilePage(); // Navigate to the ProfilePage
      default:
        return Container();
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

class Post {
  String title;
  String content;
  String? mediaUrl; // URL for image or video
  bool isVideo; // To determine if the media is a video
  int likes;
  List<String> comments;

  Post({
    required this.title,
    required this.content,
    this.mediaUrl,
    this.isVideo = false,
  })  : likes = 0,
        comments = [];
}

class PostWidget extends StatelessWidget {
  final Post post;
  final VoidCallback onLike;
  final Function(String) onComment;

  const PostWidget({
    Key? key,
    required this.post,
    required this.onLike,
    required this.onComment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController commentController = TextEditingController();

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(post.content),
            SizedBox(height: 8.0),
            // Display media (image or video) if available
            if (post.mediaUrl != null)
              post.isVideo
                  ? Container(
                      height: 200,
                      child: VideoPlayerWidget(videoUrl: post.mediaUrl!),
                    )
                  : Image.network(post.mediaUrl!, height: 200, fit: BoxFit.cover),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.thumb_up),
                      onPressed: onLike,
                    ),
                    Text('${post.likes}'),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.comment),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Add a comment'),
                          content: TextField(
                            controller: commentController,
                            decoration: InputDecoration(hintText: 'Type your comment here'),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                String comment = commentController.text;
                                if (comment.isNotEmpty) {
                                  onComment(comment);
                                  commentController.clear();
                                  Navigator.of(context).pop();
                                }
                              },
                              child: Text('Submit'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: post.comments.map((comment) => Text('- $comment')).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({required this.videoUrl});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        : CircularProgressIndicator();
  }
}
