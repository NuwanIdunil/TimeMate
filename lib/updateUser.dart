import 'package:flutter/material.dart';
import 'package:timemate/ViewModel/database_helper.dart';

import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:timemate/dashbord.dart';

class UpdateUserScreen extends StatefulWidget {
  final String email;

  UpdateUserScreen({required this.email});

  @override
  _UpdateUserScreenState createState() => _UpdateUserScreenState();
}

class _UpdateUserScreenState extends State<UpdateUserScreen> {
  final TextEditingController _nameController = TextEditingController();
  String? _imagePath;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    var userData = await DatabaseHelper.instance.getUserByEmail(widget.email);
    setState(() {
      _nameController.text = userData['name'] ?? '';
      _imagePath = userData['imagePath'];
    });
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imagePath = image.path;
      });
    }
  }

  Future<void> _updateUserInfo(String email) async {
    String name = _nameController.text.trim();
    if (_imagePath != null && name.isNotEmpty) {
      await DatabaseHelper.instance.updateUser(widget.email, name, _imagePath!);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('User information updated!')));
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardScreen(email: email),
        ),
        (Route<dynamic> route) => false,
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please fill in all fields!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update User Information'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 100,
                backgroundColor: Colors.transparent,
                child: _imagePath != null
                    ? ClipOval(
                        child: Image.file(
                          File(_imagePath!),
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Icon(Icons.account_circle, size: 50),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await _updateUserInfo(widget.email);
              },
              child: Text('Update'),
            )
          ],
        ),
      ),
    );
  }
}
