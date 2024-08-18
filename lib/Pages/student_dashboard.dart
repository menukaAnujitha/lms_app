import 'package:flutter/material.dart';
import 'package:lms_app/Pages/course_detail_page.dart';
import 'package:lms_app/Providers/user_provider.dart';
import 'package:provider/provider.dart';

class StudentDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Student Dashboard'), actions: [
        IconButton(
          icon: Icon(Icons.logout),
          onPressed: () async {
            await userProvider.logout();
            Navigator.of(context).pushReplacementNamed('/login');
          },
        ),
      ]),
      body: FutureBuilder<List<dynamic>>(
        future: userProvider.fetchMyCourses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching courses !'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No courses enrolled !'));
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
