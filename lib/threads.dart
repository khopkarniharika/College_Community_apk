import 'package:flutter/material.dart';

class ThreadsPage extends StatefulWidget {
  @override
  _ThreadsPageState createState() => _ThreadsPageState();
}

class _ThreadsPageState extends State<ThreadsPage> {
  final List<Thread> threads = [];
  final TextEditingController threadController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discussion Threads'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Start a New Thread'),
                    content: TextField(
                      controller: threadController,
                      decoration: const InputDecoration(hintText: 'Enter your thread title'),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          if (threadController.text.isNotEmpty) {
                            setState(() {
                              threads.add(Thread(title: threadController.text));
                              threadController.clear();
                            });
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text('Post'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: threads.length,
        itemBuilder: (context, index) {
          return ThreadWidget(
            thread: threads[index],
            onComment: (comment) {
              setState(() {
                threads[index].comments.add(comment);
              });
            },
          );
        },
      ),
    );
  }
}

class Thread {
  String title;
  List<String> comments;

  Thread({required this.title}) : comments = [];
}

class ThreadWidget extends StatelessWidget {
  final Thread thread;
  final Function(String) onComment;

  const ThreadWidget({Key? key, required this.thread, required this.onComment}) : super(key: key);

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
            Text(thread.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: thread.comments.map((comment) => Text('- $comment')).toList(),
            ),
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Add a Comment'),
                      content: TextField(
                        controller: commentController,
                        decoration: const InputDecoration(hintText: 'Type your comment here'),
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
                          child: const Text('Submit'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Comment'),
            ),
          ],
        ),
      ),
    );
  }
}
