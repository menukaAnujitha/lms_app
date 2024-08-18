import 'package:flutter/material.dart';
import 'package:lms_app/Providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'lesson_management_form_page.dart';

class LessonManagementPage extends StatelessWidget {
  final int courseId;

  LessonManagementPage({required this.courseId});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Lessons'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: userProvider.fetchLessons(courseId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching lessons'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No lessons available'));
          } else {
            final lessons = snapshot.data!;
            return ListView.builder(
              itemCount: lessons.length,
              itemBuilder: (context, index) {
                final lesson = lessons[index];
                return ListTile(
                  title: Text(lesson['title']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => LessonManagementFormPage(
                                courseId: courseId,
                                lessonId: lesson['id'],
                                isEditing: true,
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          userProvider.deleteLesson(lesson['id']);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => LessonManagementFormPage(
                  courseId: courseId, isEditing: false),
            ),
          );
        },
      ),
    );
  }
}
