import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timemate/ViewModel/TaskViewModel.dart';
import 'package:timemate/ViewModel/task.dart';

class AddTaskView extends StatelessWidget {
  final String email;

  AddTaskView({required this.email});
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Task')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title')),
            TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description')),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final newTask = Task(
                    email: email,
                    title: titleController.text,
                    description: descriptionController.text);
                Provider.of<TaskViewModel>(context, listen: false)
                    .addTask(newTask);
                Navigator.pop(context);
              },
              child: Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}
