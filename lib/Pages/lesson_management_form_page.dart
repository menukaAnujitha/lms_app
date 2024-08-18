import 'package:flutter/material.dart';
import 'package:lms_app/Providers/user_provider.dart';
import 'package:provider/provider.dart';

class LessonManagementFormPage extends StatefulWidget {
  final int courseId;
  final int? lessonId;
  final bool isEditing;

  LessonManagementFormPage(
      {required this.courseId, this.lessonId, required this.isEditing});

  @override
  _LessonManagementFormPageState createState() =>
      _LessonManagementFormPageState();
}

class _LessonManagementFormPageState extends State<LessonManagementFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _content = '';

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Lesson' : 'Create Lesson'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              TextFormField(
                initialValue: _content,
                decoration: InputDecoration(labelText: 'Content'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter content';
                  }
                  return null;
                },
                onSaved: (value) {
                  _content = value!;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    if (widget.isEditing) {
                      userProvider.updateLesson(
                          widget.lessonId!, _title, _content);
                    } else {
                      userProvider.createLesson(
                          widget.courseId, _title, _content);
                    }
                    Navigator.of(context).pop();
                  }
                },
                child:
                    Text(widget.isEditing ? 'Update Lesson' : 'Create Lesson'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
