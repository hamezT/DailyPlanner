// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Model/TaskModel.dart';
import '../../Services/api.dart';

class EditTaskPage extends StatefulWidget {
  final Task task;

  const EditTaskPage({super.key, required this.task});

  @override
  _EditTaskPageState createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  final _formKey = GlobalKey<FormState>();

  String? _title;
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String? _location;
  List<String> _participants = [];
  String? _notes;
  String _status = 'new'; // Trạng thái khởi tạo là "new"
  String? _reviewedBy;
  final List<DateTime> _reminders = [];

  // Duy trì trạng thái
  int _currentStatusIndex = 0;
  final List<String> _statusList = ['new', 'in-progress', 'completed', 'closed'];

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    _title = widget.task.title;
    _selectedDate = DateTime.parse(widget.task.date!);
    // Kiểm tra giá trị của _selectedDate
    print("Initialized date: $_selectedDate"); // Debugging line

    // Chuyển đổi chuỗi thời gian thành TimeOfDay
    try {
      // Chuyển đổi giờ bắt đầu
      final startTimeParts = widget.task.time!.start!.split(' ');
      final startTime = startTimeParts[0].split(':');
      _startTime = TimeOfDay(
        hour: int.parse(startTime[0]) % 12 + (startTimeParts[1] == 'PM' ? 12 : 0),
        minute: int.parse(startTime[1]),
      );

      // Chuyển đổi giờ kết thúc
      final endTimeParts = widget.task.time!.end!.split(' ');
      final endTime = endTimeParts[0].split(':');
      _endTime = TimeOfDay(
        hour: int.parse(endTime[0]) % 12 + (endTimeParts[1] == 'PM' ? 12 : 0),
        minute: int.parse(endTime[1]),
      );
    } catch (e) {
      print('Error parsing time: $e');
      _startTime = TimeOfDay.now(); // Mặc định giờ bắt đầu nếu lỗi
      _endTime = TimeOfDay.now(); // Mặc định giờ kết thúc nếu lỗi
    }

    _location = widget.task.location;
    _participants = List.from(widget.task.participants ?? []);
    _notes = widget.task.notes;
    _status = widget.task.status ?? 'new';
    _currentStatusIndex = _statusList.indexOf(_status);
    _reviewedBy = widget.task.reviewedBy; // Lấy giá trị ReviewedBy từ task
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
      _selectedDate = DateTime(picked.year, picked.month, picked.day);
        print("Selected date: $_selectedDate"); // Debugging line
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  Future<void> _updateTask() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final time = TimeTask(
        start: _startTime?.format(context),
        end: _endTime?.format(context),
      );

      try {
        await Api().updateTask(
          id: widget.task.sId!,
          title: _title!,
          date: _selectedDate!,
          time: time,
          location: _location!,
          participants: _participants,
          notes: _notes!,
          status: _status,
          reviewedBy: _reviewedBy,
          reminders: _reminders,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task updated successfully!')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update task: $e')),
        );
      }
    }
  }

  void _updateStatus() {
    setState(() {
      if (_currentStatusIndex < _statusList.length - 1) {
        _currentStatusIndex++;
        _status = _statusList[_currentStatusIndex];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Task'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(
                  label: 'Title',
                  icon: Icons.title,
                  onSaved: (value) => _title = value,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a title' : null,
                  initialValue: _title,
                ),
                const SizedBox(height: 10),
                _buildDatePicker(),
                const SizedBox(height: 10),
                _buildTimePicker('Start Time', true),
                const SizedBox(height: 10),
                _buildTimePicker('End Time', false),
                const SizedBox(height: 10),
                _buildTextField(
                  label: 'Location',
                  icon: Icons.location_on,
                  onSaved: (value) => _location = value,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a location' : null,
                  initialValue: _location,
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  label: 'Participants (comma separated)',
                  icon: Icons.people,
                  onSaved: (value) => _participants =
                      value!.split(',').map((e) => e.trim()).toList(),
                  initialValue: _participants.join(', '),
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  label: 'Notes',
                  icon: Icons.note,
                  onSaved: (value) => _notes = value,
                  initialValue: _notes,
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  label: 'Reviewed By',
                  icon: Icons.person,
                  onSaved: (value) => _reviewedBy = value,
                  initialValue: _reviewedBy,
                ),
                const SizedBox(height: 20),
                // Status section
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: List.generate(_statusList.length, (index) {
                    return Row(
                      children: [
                        Icon(
                          _currentStatusIndex >= index
                              ? Icons.check_circle
                              : Icons.check_circle_outline,
                          color: _currentStatusIndex >= index
                              ? Colors.green
                              : Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _statusList[index].toUpperCase(),
                          style: TextStyle(
                            color: _currentStatusIndex >= index
                                ? Colors.green
                                : Colors.black,
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                    );
                  })..add(
                    ElevatedButton(
                      onPressed: _updateStatus,
                      child: const Text('CONFIRM'),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    onPressed: _updateTask,
                    child: const Text('Update Task'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required FormFieldSetter<String> onSaved,
    FormFieldValidator<String>? validator,
    String? initialValue,
  }) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      onSaved: onSaved,
      validator: validator,
    );
  }

  Widget _buildDatePicker() {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Date: ${_selectedDate != null ? DateFormat.yMd().format(_selectedDate!) : 'Select a date'}',
            style: const TextStyle(fontSize: 16),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () => _selectDate(context),
        ),
      ],
    );
  }

  Widget _buildTimePicker(String label, bool isStartTime) {
    final time = isStartTime ? _startTime : _endTime;
    return Row(
      children: [
        Expanded(
          child: Text(
            '$label: ${time != null ? time.format(context) : 'Select a time'}',
            style: const TextStyle(fontSize: 16),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.access_time),
          onPressed: () => _selectTime(context, isStartTime),
        ),
      ],
    );
  }
}
