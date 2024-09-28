// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../Model/TaskStatModel.dart';
import '../../Services/api.dart';

class TaskStatsPage extends StatefulWidget {
  const TaskStatsPage({super.key});

  @override
  _TaskStatsPageState createState() => _TaskStatsPageState();
}

class _TaskStatsPageState extends State<TaskStatsPage> {
  TaskStatModel? taskStats;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTaskStats();
  }

  Future<void> _fetchTaskStats() async {
    final statsData = await Api().getTaskStats();
    setState(() {
      if (statsData != null) {
        taskStats = TaskStatModel.fromJson(statsData);
      }
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Statistics'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : taskStats == null
              ? const Center(child: Text('Failed to load task statistics'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Phân bổ loại task',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: PieChart(
                          PieChartData(
                            sections: [
                              PieChartSectionData(
                                value: taskStats!.tasksCreated!.toDouble(),
                                color: Colors.blue,
                                title: 'New: ${taskStats!.tasksCreated}',
                                radius: 30,
                              ),
                              PieChartSectionData(
                                value: taskStats!.tasksInProgress!.toDouble(),
                                color: Colors.orange,
                                title: 'In Progress: ${taskStats!.tasksInProgress}',
                                radius: 30,
                              ),
                              PieChartSectionData(
                                value: taskStats!.tasksCompleted!.toDouble(),
                                color: Colors.green,
                                title: 'Completed: ${taskStats!.tasksCompleted}',
                                radius: 30,
                              ),
                              PieChartSectionData(
                                value: taskStats!.tasksClosed!.toDouble(),
                                color: Colors.red,
                                title: 'Closed: ${taskStats!.tasksClosed}',
                                radius: 30,
                              ),
                            ],
                            sectionsSpace: 4,
                            centerSpaceRadius: 40,
                            borderData: FlBorderData(show: false),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'Thống kê task',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            maxY: ([
                                      taskStats!.tasksCreated ?? 0,
                                      taskStats!.tasksInProgress ?? 0,
                                      taskStats!.tasksCompleted ?? 0,
                                      taskStats!.tasksClosed ?? 0,
                                    ].reduce((a, b) => a > b ? a : b)
                                    .toDouble()) +
                                5,
                            barGroups: [
                              BarChartGroupData(
                                x: 0,
                                barRods: [
                                  BarChartRodData(
                                    toY: taskStats!.tasksCreated!.toDouble(),
                                    color: Colors.blue,
                                    width: 16,
                                  ),
                                ],
                                showingTooltipIndicators: [0],
                              ),
                              BarChartGroupData(
                                x: 1,
                                barRods: [
                                  BarChartRodData(
                                    toY: taskStats!.tasksInProgress!.toDouble(),
                                    color: Colors.orange,
                                    width: 16,
                                  ),
                                ],
                                showingTooltipIndicators: [0],
                              ),
                              BarChartGroupData(
                                x: 2,
                                barRods: [
                                  BarChartRodData(
                                    toY: taskStats!.tasksCompleted!.toDouble(),
                                    color: Colors.green,
                                    width: 16,
                                  ),
                                ],
                                showingTooltipIndicators: [0],
                              ),
                              BarChartGroupData(
                                x: 3,
                                barRods: [
                                  BarChartRodData(
                                    toY: taskStats!.tasksClosed!.toDouble(),
                                    color: Colors.red,
                                    width: 16,
                                  ),
                                ],
                                showingTooltipIndicators: [0],
                              ),
                            ],
                            borderData: FlBorderData(show: false),
                            titlesData: FlTitlesData(
                              leftTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: true),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    switch (value.toInt()) {
                                      case 0:
                                        return const Text('New');
                                      case 1:
                                        return const Text('In-Progress');
                                      case 2:
                                        return const Text('Completed');
                                      case 3:
                                        return const Text('Closed');
                                      default:
                                        return const Text('');
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
