import 'package:flutter/material.dart';
import '../../Model/TaskModel.dart';
import '../../Services/api.dart'; // Đảm bảo import đúng model của bạn

class DetailTaskPage extends StatelessWidget {
  final String taskId;

  const DetailTaskPage({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>?>( 
        future: Api().getTaskDetails(taskId), // Sử dụng hàm lấy chi tiết task
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No task found.'));
          } else {
            final taskData = snapshot.data!; // Không cần dùng ['task'] nữa
            final Task task = Task.fromJson(taskData); // Sử dụng taskData trực tiếp

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  _buildDetailRow(Icons.title, 'Title', task.title ?? 'N/A'),
                  _buildDetailRow(Icons.calendar_today, 'Date', task.date ?? 'N/A'),
                  _buildDetailRow(Icons.access_time, 'Time', task.time?.start ?? 'N/A'),
                  _buildDetailRow(Icons.location_on, 'Location', task.location ?? 'N/A'),
                  _buildDetailRow(Icons.group, 'Participants', task.participants?.join(', ') ?? 'N/A'),
                  _buildDetailRow(Icons.note, 'Notes', task.notes ?? 'N/A'),
                  _buildDetailRow(Icons.check_circle, 'Status', task.status ?? 'N/A'),
                  _buildDetailRow(Icons.person, 'Reviewed By', task.reviewedBy ?? 'N/A'),
                  _buildReminderList(task.isReminderEnabled == true ? [] : null), // Pass only the list of reminders
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 30, color: Colors.blue),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(value, style: TextStyle(color: Colors.grey[700])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReminderList(List<String>? reminders) {
    if (reminders == null || reminders.isEmpty) {
      return _buildDetailRow(Icons.notifications_off, 'Reminders', 'No reminders set');
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Reminders', style: TextStyle(fontWeight: FontWeight.bold)),
          ...reminders.map((reminder) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(reminder, style: TextStyle(color: Colors.grey[700])),
            );
          }), // Add toList() to convert iterable to a list
        ],
      ),
    );
  }
}
