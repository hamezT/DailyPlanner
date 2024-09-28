// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../Services/api.dart';
import '../../Model/TaskModel.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final Api api = Api();
  Map<DateTime, List<Task>> tasksMap = {};
  DateTime selectedDay = DateTime.now();
  List<Task> tasks = [];
  CalendarFormat calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadTasks(); // Tải lại các task mỗi khi trang được mở
  }

  Future<void> _loadTasks() async {
    final response = await api.getTasks();
    if (response != null) {
      setState(() {
        tasks = response.map<Task>((taskJson) => Task.fromJson(taskJson)).toList();
        _groupTasksByDate();
      });
    }
  }

  void _groupTasksByDate() {
    tasksMap.clear();
    for (var task in tasks) {
      if (task.date != null) {
        try {
          DateTime date = DateTime.parse(task.date!);
          final normalizedDate = DateTime(date.year, date.month, date.day);
          if (tasksMap[normalizedDate] == null) {
            tasksMap[normalizedDate] = [];
          }
          tasksMap[normalizedDate]!.add(task);
        } catch (e) {
          print('Error parsing date: ${task.date}');
        }
      }
    }
    print('Grouped Tasks: $tasksMap');
  }

  List<Task>? _getTasksForDay(DateTime day) {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    return tasksMap[normalizedDay];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch Biểu Công Việc'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.now().subtract(const Duration(days: 365)),
            lastDay: DateTime.now().add(const Duration(days: 365)),
            focusedDay: selectedDay,
            calendarFormat: calendarFormat,
            availableCalendarFormats: const {
              CalendarFormat.month: 'Ấn để xem kiểu: Tháng',
              CalendarFormat.twoWeeks: 'Ấn để xem kiểu: 2 tuần',
            },
            onFormatChanged: (format) {
              setState(() {
                calendarFormat = format;
              });
            },
            selectedDayPredicate: (day) => isSameDay(selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                this.selectedDay = selectedDay;
              });
            },
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                final tasksForDay = _getTasksForDay(day);
                return Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: tasksForDay != null && tasksForDay.isNotEmpty
                        ? Colors.green[300]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      day.day.toString(),
                      style: TextStyle(
                        color: tasksForDay != null && tasksForDay.isNotEmpty
                            ? Colors.white
                            : null,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _getTasksForDay(selectedDay)?.length ?? 0,
              itemBuilder: (context, index) {
                final task = _getTasksForDay(selectedDay)![index];
                return ListTile(
                  title: Text(task.title ?? "No Title"),
                  subtitle: Text(task.notes ?? ""),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
