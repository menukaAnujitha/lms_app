import 'package:flutter/material.dart';
import 'package:lms_app/Pages/course_detail_page.dart';
import 'package:lms_app/Pages/instructor_dashboard.dart';
import 'package:lms_app/Pages/student_dashboard.dart';
import 'package:lms_app/Providers/user_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final role = userProvider.role;

    return Scaffold(
      appBar: AppBar(
        title: Text('All Courses'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (role == 'student') {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => StudentDashboard(),
              ),
            );
          } else {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => InstructorDashboard(),
              ),
            );
          }
        },
        child: Icon(Icons.dashboard),
        tooltip: 'Go to Dashboard',
      ),
      body: FutureBuilder<List<dynamic>>(
        future: userProvider.fetchCourses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching courses'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No courses available'));
          } else {
            final courses = snapshot.data!;
            return ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                return ListTile(
                  title: Text(course['title']),
                  subtitle: Text(course['category']),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            CourseDetailsPage(courseId: course['id']),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
