import 'package:flutter/material.dart';
import 'package:lms_app/Providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'course_management_page.dart';
import 'lesson_management_page.dart';

class InstructorDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Instructor Dashboard'), actions: [
        IconButton(
          icon: Icon(Icons.logout),
          onPressed: () async {
            await userProvider.logout();
            Navigator.of(context).pushReplacementNamed('/login');
          },
        ),
      ]),
      body: FutureBuilder<List<dynamic>>(
        future: userProvider.fetchCourses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching courses !'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No courses available !'));
          } else {
            final courses = snapshot.data!;
            return ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                return ListTile(
                  title: Text(course['title']),
                  subtitle: Text(course['category']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CourseManagementPage(
                                courseId: course['id'],
                                isEditing: true,
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          userProvider.deleteCourse(course['id']);
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            LessonManagementPage(courseId: course['id']),
                      ),
                    );
                  },
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
              builder: (context) => CourseManagementPage(isEditing: false),
            ),
          );
        },
      ),
    );
  }
}
