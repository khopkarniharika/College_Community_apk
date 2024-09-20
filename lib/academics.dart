import 'package:flutter/material.dart';

class AcademicsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Academics'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTile(context, 'Library', Icons.library_books, LibraryPage()),
            _buildTile(context, 'Classroom', Icons.class_, ClassroomPage()),
            _buildTile(context, 'Events', Icons.event, EventsPage()),
            _buildTile(context, 'Feedback', Icons.feedback, FeedbackPage()),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(BuildContext context, String title, IconData icon, Widget page) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, size: 40),
        title: Text(title, style: TextStyle(fontSize: 20)),
        trailing: Icon(Icons.arrow_forward),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
      ),
    );
  }
}

// Placeholder for Library Page
class LibraryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Library'),
      ),
      body: Center(
        child: Text('Library Section'),
      ),
    );
  }
}

// Placeholder for Classroom Page
class ClassroomPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Classroom'),
      ),
      body: Center(
        child: Text('Classroom Section'),
      ),
    );
  }
}

// Placeholder for Events Page
class EventsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events'),
      ),
      body: Center(
        child: Text('Events Section'),
      ),
    );
  }
}

// Placeholder for Feedback Page
class FeedbackPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback'),
      ),
      body: Center(
        child: Text('Feedback Section'),
      ),
    );
  }
}
