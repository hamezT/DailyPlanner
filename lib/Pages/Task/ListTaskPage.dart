import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Model/TaskModel.dart';
import '../../Services/api.dart';
import 'AddTaskPage.dart';
import 'DetailTaskPage.dart';
import 'EditTaskPage.dart';
import 'TaskStats.dart'; // Import TaskStats.dart

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  final Api api = Api();
  List<Task> tasks = []; // Use Task instead of TaskModel

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final response = await api.getTasks();
    if (response != null) {
      setState(() {
        tasks = response
            .map<Task>((taskJson) => Task.fromJson(taskJson))
            .toList(); // Modify to use Task.fromJson
      });
    }
  }

  Future<void> _deleteTask(String taskId) async {
    final response = await api.deleteTask(taskId);
    if (response != null) {
      _loadTasks(); // Reload task list
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response['message']))); 
    }
  }

  void _onReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1; // Adjust index when dragging
    }
    final Task task = tasks.removeAt(oldIndex);
    tasks.insert(newIndex, task);
    setState(() {}); // Update UI after changing order
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách công việc'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AddTaskPage()));
            },
          ),
        ],
      ),
      body: tasks.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ReorderableListView.builder(
              itemCount: tasks.length,
              onReorder: _onReorder,
              itemBuilder: (context, index) {
                final task = tasks[index];
                final dateFormat =
                    DateFormat('dd/MM/yyyy HH:mm'); // Date format

                return Card(
                  key: ValueKey(task.sId), // Key for each item
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(task.title ?? "No Title"),
                    subtitle: Text(
                      '${dateFormat.format(DateTime.parse(task.date!))} - ${task.time?.start} to ${task.time?.end}', // Convert date string to DateTime
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditTaskPage(task: task),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Xác nhận'),
                                  content: const Text(
                                      'Bạn có chắc chắn muốn xóa công việc này không?'),
                                  actions: [
                                    TextButton(
                                      child: const Text('Hủy'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('Xóa'),
                                      onPressed: () {
                                        _deleteTask(task.sId ?? "");
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetailTaskPage(taskId: task.sId ?? ""),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TaskStatsPage()), // Navigate to TaskStats
          );
        },
        child: const Icon(Icons.bar_chart), // Bar chart icon
      ),
    );
  }
}
