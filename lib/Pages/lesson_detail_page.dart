import 'package:flutter/material.dart';
import 'package:lms_app/Providers/user_provider.dart';
import 'package:provider/provider.dart';

class LessonDetailsPage extends StatelessWidget {
  final int courseId;
  final int lessonId;

  LessonDetailsPage({required this.courseId, required this.lessonId});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Lesson Details'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: userProvider.fetchLessonDetails(courseId, lessonId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching lesson details !'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Lesson not found !'));
          } else {
            final lesson = snapshot.data!;
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(lesson['title'],
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text(lesson['content']),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
