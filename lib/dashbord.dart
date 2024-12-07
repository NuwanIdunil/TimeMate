import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timemate/AddTaskVeiw.dart';
import 'package:timemate/ViewModel/TaskViewModel.dart';
import 'package:timemate/ViewModel/database_helper.dart';
import 'dart:io';

import 'package:timemate/ViewModel/task.dart';
import 'package:timemate/login_screen.dart';
import 'package:timemate/updateUser.dart';

class DashboardScreen extends StatefulWidget {
  final String email;

  DashboardScreen({required this.email});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String name = '';
  String email = '';
  String? imagePath;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadTasks();
  }

  Future<void> _loadUserData() async {
    var userData = await DatabaseHelper.instance.getUserByEmail(widget.email);
    setState(() {
      name = userData['name'] ?? 'User';
      email = userData['email'] ?? '';
      imagePath = userData['imagePath'];
    });
  }

  Future<void> _loadTasks() async {
    await Provider.of<TaskViewModel>(context, listen: false)
        .loadTasks(widget.email);
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 0, 209),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(150),
        child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: const Color.fromARGB(255, 241, 0, 209),
            flexibleSpace: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage:
                              (imagePath != null && imagePath!.isNotEmpty)
                                  ? FileImage(File(imagePath!))
                                  : null,
                          child: imagePath == null
                              ? const Icon(Icons.account_circle, size: 20)
                              : null,
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'Hi, $name',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Text(
                                email,
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.settings,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => UpdateUserScreen(
                                email: widget.email,
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.logout,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            )),
      ),
      body: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(50),
          ),
          color: Color.fromARGB(255, 255, 255, 255),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Consumer<TaskViewModel>(
            builder: (context, viewModel, child) {
              return ListView.builder(
                itemCount: viewModel.tasks.length,
                itemBuilder: (context, index) {
                  final task = viewModel.tasks[index];
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Card(
                      color: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        isThreeLine: true,
                        title: Text(task.title),
                        subtitle: Text(task.description),
                        trailing: Column(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                final updatedTask = Task(
                                  id: task.id,
                                  email: widget.email,
                                  title: task.title,
                                  description: task.description,
                                  isCompleted: !task.isCompleted,
                                );
                                viewModel.updateTask(updatedTask);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: task.isCompleted
                                    ? Colors.red
                                    : Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Text(
                                task.isCompleted ? 'Completed' : 'Incomplete',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 10),
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              final titleController =
                                  TextEditingController(text: task.title);
                              final descriptionController =
                                  TextEditingController(text: task.description);

                              return AlertDialog(
                                title: const Text(
                                  'Manage Task',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 241, 0, 209)),
                                ),
                                content: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextFormField(
                                        controller: titleController,
                                        decoration: const InputDecoration(
                                          labelText: 'Title',
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      TextFormField(
                                        controller: descriptionController,
                                        maxLines: 3,
                                        decoration: const InputDecoration(
                                          labelText: 'Description',
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      ElevatedButton(
                                        onPressed: () {
                                          final updatedTask = Task(
                                            email: widget.email,
                                            id: task.id,
                                            title: titleController.text,
                                            description:
                                                descriptionController.text,
                                            isCompleted: task.isCompleted,
                                          );
                                          Provider.of<TaskViewModel>(context,
                                                  listen: false)
                                              .updateTask(updatedTask);
                                          Provider.of<TaskViewModel>(context,
                                                  listen: false)
                                              .loadTasks(widget.email);
                                          Navigator.pop(context);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              255, 241, 0, 209),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                        child: const Text(
                                          'Update',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 241, 0, 209)),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Provider.of<TaskViewModel>(context,
                                              listen: false)
                                          .deleteTask(task.id!);
                                      Provider.of<TaskViewModel>(context,
                                              listen: false)
                                          .loadTasks(widget.email);

                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      'Delete',
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 241, 0, 209)),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
      // ),
      floatingActionButton: SizedBox(
        width: screenWidth * 0.5,
        child: FloatingActionButton.extended(
          backgroundColor: const Color.fromARGB(255, 241, 0, 209),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => AddTaskView(
                        email: widget.email,
                      )),
            );
          },
          icon: const Icon(Icons.add),
          label: const Text(
            "Add Task",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
