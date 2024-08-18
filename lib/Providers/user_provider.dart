import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserProvider with ChangeNotifier {
  String _token = '';
  String _role = '';
  Map<String, dynamic> _user = {};
  List<dynamic> _courses = [];
  List<dynamic> _lessons = [];

  // getters
  String get token => _token;
  String get role => _role;
  Map<String, dynamic> get user => _user;
  List<dynamic> get courses => _courses;
  List<dynamic> get lessons => _lessons;

  // register user
  Future<void> register(
      String name, String email, String password, String role) async {
    final url = Uri.parse(
        'https://festive-clarke.93-51-37-244.plesk.page/api/v1/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': name,
        'email': email,
        'password': password,
        'role': role,
      }),
    );

    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      _token = responseData['token'];
      _role = role;
      await fetchUser();
      notifyListeners();
    } else {
      throw Exception('Failed');
    }
  }

  // login user
  Future<void> login(String email, String password) async {
    final url = Uri.parse(
        'https://festive-clarke.93-51-37-244.plesk.page/api/v1/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      _token = responseData['token'];
      await fetchUser();
      notifyListeners();
    } else {
      throw Exception('Failed');
    }
  }

  // fetch authenticated user
  Future<void> fetchUser() async {
    final url =
        Uri.parse('https://festive-clarke.93-51-37-244.plesk.page/api/v1/user');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $_token',
    });

    if (response.statusCode == 200) {
      _user = json.decode(response.body);
      _role = _user['role'];
      notifyListeners();
    } else {
      throw Exception('Failed');
    }
  }

  // logout user
  Future<void> logout() async {
    final url = Uri.parse(
        'https://festive-clarke.93-51-37-244.plesk.page/api/v1/logout');
    final response = await http.post(url, headers: {
      'Authorization': 'Bearer $_token',
    });

    if (response.statusCode == 200) {
      _token = '';
      _role = '';
      _user = {};
      notifyListeners();
    } else {
      throw Exception('Failed');
    }
  }

  // fetch all courses
  Future<List<dynamic>> fetchCourses() async {
    final url = Uri.parse(
        'https://festive-clarke.93-51-37-244.plesk.page/api/v1/courses');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $_token',
    });

    if (response.statusCode == 200) {
      return List<dynamic>.from(json.decode(response.body));
    } else {
      throw Exception('Failed');
    }
  }

  // fetch details of a specific course
  Future<Map<String, dynamic>> fetchCourseDetails(int courseId) async {
    final url = Uri.parse(
        'https://festive-clarke.93-51-37-244.plesk.page/api/v1/courses/$courseId');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $_token',
    });

    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(json.decode(response.body));
    } else {
      throw Exception('Failed');
    }
  }

  // fetch all lessons for a specific course
  Future<List<dynamic>> fetchLessons(int courseId) async {
    final url = Uri.parse(
        'https://festive-clarke.93-51-37-244.plesk.page/api/v1/courses/$courseId/lessons');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $_token',
    });

    if (response.statusCode == 200) {
      return List<dynamic>.from(json.decode(response.body));
    } else {
      throw Exception('Failed');
    }
  }

  // fetch details of a specific lesson
  Future<Map<String, dynamic>> fetchLessonDetails(
      int courseId, int lessonId) async {
    final url = Uri.parse(
        'https://festive-clarke.93-51-37-244.plesk.page/api/v1/courses/$courseId/lessons/$lessonId');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $_token',
    });

    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(json.decode(response.body));
    } else {
      throw Exception('Failed');
    }
  }

  // fetch courses the student is enrolled in
  Future<List<dynamic>> fetchMyCourses() async {
    final response = await http.get(Uri.parse(
        'https://festive-clarke.93-51-37-244.plesk.page/api/v1/my-courses'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed');
    }
  }

  // enroll in a course
  Future<void> enrollInCourse(int courseId) async {
    final response = await http.post(Uri.parse(
        'https://festive-clarke.93-51-37-244.plesk.page/api/v1/courses/$courseId/enroll'));
    if (response.statusCode != 200) {
      throw Exception('Failed');
    }
    notifyListeners();
  }

  // unenroll from a course
  Future<void> unenrollFromCourse(int courseId) async {
    final response = await http.delete(Uri.parse(
        'https://festive-clarke.93-51-37-244.plesk.page/api/v1/courses/$courseId/unenroll'));
    if (response.statusCode != 204) {
      throw Exception('Failed');
    }
    notifyListeners();
  }

  // mark a lesson as completed
  Future<void> markLessonAsCompleted(int lessonId) async {
    final response = await http.post(Uri.parse(
        'https://festive-clarke.93-51-37-244.plesk.page/api/v1/lessons/$lessonId/complete'));
    if (response.statusCode != 200) {
      throw Exception('Failed');
    }
    notifyListeners();
  }

  // fetch progress in a course
  Future<dynamic> fetchProgress(int courseId) async {
    final response = await http.get(Uri.parse(
        'https://festive-clarke.93-51-37-244.plesk.page/api/v1/courses/$courseId/progress'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed');
    }
  }

  // create a new course (instructor only)
  Future<void> createCourse(
      String title, String category, String description) async {
    final url = Uri.parse(
        'https://festive-clarke.93-51-37-244.plesk.page/api/v1/courses');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'title': title,
        'category': category,
        'description': description,
      }),
    );

    if (response.statusCode == 201) {
      fetchCourses();
    } else {
      throw Exception('Failed');
    }
  }

  // update a course (instructor only)
  Future<void> updateCourse(
      int courseId, String title, String category, String description) async {
    final url = Uri.parse(
        'https://festive-clarke.93-51-37-244.plesk.page/api/v1/courses/$courseId/update');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'title': title,
        'category': category,
        'description': description,
      }),
    );

    if (response.statusCode == 200) {
      fetchCourses();
    } else {
      throw Exception('Failed');
    }
  }

  // delete a course (instructor only)
  Future<void> deleteCourse(int courseId) async {
    final url = Uri.parse(
        'https://festive-clarke.93-51-37-244.plesk.page/api/v1/courses/$courseId');
    final response = await http.delete(url, headers: {
      'Authorization': 'Bearer $_token',
    });

    if (response.statusCode == 200) {
      fetchCourses();
    } else {
      throw Exception('Failed');
    }
  }

  // create a new lesson (instructor only)
  Future<void> createLesson(int courseId, String title, String content) async {
    final url = Uri.parse(
        'https://festive-clarke.93-51-37-244.plesk.page/api/v1/courses/$courseId/lessons');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'title': title,
        'content': content,
      }),
    );

    if (response.statusCode == 201) {
      fetchLessons(courseId);
    } else {
      throw Exception('Failed');
    }
  }

  // update a lesson (instructor only)
  Future<void> updateLesson(int lessonId, String title, String content) async {
    final url = Uri.parse(
        'https://festive-clarke.93-51-37-244.plesk.page/api/v1/lessons/$lessonId/update');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'title': title,
        'content': content,
      }),
    );

    if (response.statusCode == 200) {
      fetchLessons(_lessons.first['course_id']);
    } else {
      throw Exception('Failed');
    }
  }

  // delete a lesson (instructor only)
  Future<void> deleteLesson(int lessonId) async {
    final url = Uri.parse(
        'https://festive-clarke.93-51-37-244.plesk.page/api/v1/lessons/$lessonId');
    final response = await http.delete(url, headers: {
      'Authorization': 'Bearer $_token',
    });

    if (response.statusCode == 200) {
      fetchLessons(_lessons.first['course_id']);
    } else {
      throw Exception('Failed');
    }
  }
}
