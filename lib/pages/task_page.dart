import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  List<String> tasks = [];
  String currentTask = '';

  Future<void> loadTasks() async {
    final String jsonString = await rootBundle.loadString('assets/topics.json');
    final data = json.decode(jsonString);
    setState(() {
      tasks = List<String>.from(data['topics']);
    });
  }

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  void generateTask() {
    if (tasks.isNotEmpty) {
      currentTask = (tasks..shuffle()).first;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Page')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                currentTask.isEmpty
                    ? 'Press the button to get a task!'
                    : currentTask,
                style: const TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: generateTask,
                child: const Text('Generate Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
