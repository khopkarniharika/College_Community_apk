import 'package:flutter/material.dart';

class AnnouncementPage extends StatefulWidget {
  final bool isSuperUser;

  const AnnouncementPage({super.key, required this.isSuperUser});

  @override
  _AnnouncementPageState createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {
  final List<Map<String, String>> announcements =
      []; // List to hold announcements
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  // Method to add announcements
  void addAnnouncement() {
    if (titleController.text.isNotEmpty && contentController.text.isNotEmpty) {
      setState(() {
        announcements.add({
          'title': titleController.text,
          'content': contentController.text,
        });
        titleController.clear();
        contentController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Announcements')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            if (widget.isSuperUser) ...[
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 8.0), // Spacing between fields
              TextField(
                controller: contentController,
                decoration: const InputDecoration(labelText: 'Content'),
                maxLines: 3, // Allow multiline input
              ),
              const SizedBox(height: 8.0), // Spacing before button
              ElevatedButton(
                onPressed: addAnnouncement,
                child: const Text('Post Announcement'),
              ),
            ] else ...[
              const Center(
                  child: Text('You are not authorized to post announcements')),
            ],
            const SizedBox(height: 8.0), // Spacing before the list
            Expanded(
              child: ListView.builder(
                itemCount: announcements.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(announcements[index]['title']!),
                    subtitle: Text(announcements[index]['content']!),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
