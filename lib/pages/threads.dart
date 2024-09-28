import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Thread {
  final String title;
  final String content;
  final DateTime timestamp;
  List<Reply> replies;

  Thread({
    required this.title,
    required this.content,
    required this.timestamp,
    this.replies = const [],
  });
}

class Reply {
  final String content;
  final DateTime timestamp;

  Reply({
    required this.content,
    required this.timestamp,
  });
}

// Sample threads data
List<Thread> sampleThreads = [];

class ThreadsPage extends StatefulWidget {
  const ThreadsPage({super.key});

  @override
  _ThreadsPageState createState() => _ThreadsPageState();
}

class _ThreadsPageState extends State<ThreadsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discussion Threads'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showAddThreadDialog(context);
            },
          ),
        ],
      ),
      body: sampleThreads.isEmpty
          ? const Center(child: Text('No threads available.'))
          : ListView.builder(
              itemCount: sampleThreads.length,
              itemBuilder: (context, index) {
                return ThreadWidget(
                  thread: sampleThreads[index],
                  onReplyAdded: (reply) {
                    setState(() {
                      sampleThreads[index].replies.add(reply);
                    });
                  },
                );
              },
            ),
    );
  }

  void _showAddThreadDialog(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create New Thread'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(hintText: 'Thread Title'),
              ),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(hintText: 'Thread Content'),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    contentController.text.isNotEmpty) {
                  setState(() {
                    sampleThreads.add(Thread(
                      title: titleController.text,
                      content: contentController.text,
                      timestamp: DateTime.now(),
                      replies: [],
                    ));
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Submit'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}

class ThreadWidget extends StatelessWidget {
  final Thread thread;
  final Function(Reply) onReplyAdded;

  const ThreadWidget(
      {super.key, required this.thread, required this.onReplyAdded});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(thread.title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                Text(DateFormat('yyyy-MM-dd – kk:mm').format(thread.timestamp),
                    style: const TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(thread.content),
            const SizedBox(height: 8.0),
            ...thread.replies.map((reply) => Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Reply: ${reply.content}',
                          style: const TextStyle(color: Colors.grey)),
                      Text(
                          DateFormat('yyyy-MM-dd – kk:mm')
                              .format(reply.timestamp),
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                )),
            TextButton(
              onPressed: () {
                _showReplyDialog(context);
              },
              child: const Text('Reply', style: TextStyle(color: Colors.blue)),
            ),
          ],
        ),
      ),
    );
  }

  void _showReplyDialog(BuildContext context) {
    final TextEditingController replyController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add a Reply'),
          content: TextField(
            controller: replyController,
            decoration:
                const InputDecoration(hintText: 'Type your reply here...'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (replyController.text.isNotEmpty) {
                  onReplyAdded(Reply(
                      content: replyController.text,
                      timestamp: DateTime.now()));
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Submit'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
