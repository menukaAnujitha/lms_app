import 'package:flutter/material.dart';
import 'package:lms_app/Providers/user_provider.dart';
import 'package:provider/provider.dart';

class CourseDetailsPage extends StatelessWidget {
  final int courseId;

  CourseDetailsPage({required this.courseId});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Course Details'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: userProvider.fetchLessons(courseId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching lessons !'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No lessons available !'));
          } else {
            final lessons = snapshot.data!;
            return ListView.builder(
              itemCount: lessons.length,
              itemBuilder: (context, index) {
                final lesson = lessons[index];
                return ListTile(
                  title: Text(lesson['title']),
                  trailing: Checkbox(
                    value: lesson['completed'],
                    onChanged: (bool? value) {
                      userProvider.markLessonAsCompleted(lesson['id']);
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
