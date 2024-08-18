import 'package:flutter/material.dart';
import 'package:lms_app/Providers/user_provider.dart';
import 'package:provider/provider.dart';

class CourseManagementPage extends StatefulWidget {
  final int? courseId;
  final bool isEditing;

  CourseManagementPage({this.courseId, required this.isEditing});

  @override
  _CourseManagementPageState createState() => _CourseManagementPageState();
}

class _CourseManagementPageState extends State<CourseManagementPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _category = '';
  String _description = '';

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Course' : 'Create Course'),
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
                initialValue: _category,
                decoration: InputDecoration(labelText: 'Category'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category';
                  }
                  return null;
                },
                onSaved: (value) {
                  _category = value!;
                },
              ),
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value!;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    if (widget.isEditing) {
                      userProvider.updateCourse(
                          widget.courseId!, _title, _category, _description);
                    } else {
                      userProvider.createCourse(
                          _title, _category, _description);
                    }
                    Navigator.of(context).pop();
                  }
                },
                child:
                    Text(widget.isEditing ? 'Update Course' : 'Create Course'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
