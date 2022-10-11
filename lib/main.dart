import 'package:flutter/material.dart';
import 'package:ToDoalert/Screens/tasks_home.dart';
import 'package:ToDoalert/Screens/add_task_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDoAlert',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const TasksHome(),
        '/add_task': (context) => const AddTaskScreen()
      },
    );
  }
}
