// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Model/TaskModel.dart';
import 'package:daily_planner/Services/api.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();

  String? _title;
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String? _location;
  List<String> _participants = [];
  String? _notes;
  final String _status = 'new';  // Status set to "new" by default
  String? _reviewedBy;
  final List<DateTime> _reminders = [];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
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

  Future<void> _submitTask() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final time = TimeTask(
        start: _startTime?.format(context),
        end: _endTime?.format(context),
      );

      try {
        await Api().addTask(
          title: _title!,
          date: _selectedDate!,
          time: time,
          location: _location!,
          participants: _participants,
          notes: _notes!,
          status: _status,  // Status is always "new" by default
          reviewedBy: _reviewedBy,
          reminders: _reminders,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task added successfully!')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add task: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
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
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  label: 'Participants (comma separated)',
                  icon: Icons.people,
                  onSaved: (value) =>
                      _participants = value!.split(',').map((e) => e.trim()).toList(),
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  label: 'Notes',
                  icon: Icons.note,
                  onSaved: (value) => _notes = value,
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  label: 'Reviewed By',
                  icon: Icons.person,
                  onSaved: (value) => _reviewedBy = value,
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    onPressed: _submitTask,
                    child: const Text('Add Task'),
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
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
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
            _selectedDate == null
                ? 'No date chosen!'
                : 'Date: ${DateFormat.yMd().format(_selectedDate!)}',
            style: const TextStyle(fontSize: 16),
          ),
        ),
        TextButton(
          onPressed: () => _selectDate(context),
          child: const Text('Select Date'),
        ),
      ],
    );
  }

  Widget _buildTimePicker(String label, bool isStartTime) {
    return Row(
      children: [
        Expanded(
          child: Text(
            (isStartTime ? _startTime : _endTime) == null
                ? '$label not chosen!'
                : '$label: ${isStartTime ? _startTime!.format(context) : _endTime!.format(context)}',
            style: const TextStyle(fontSize: 16),
          ),
        ),
        TextButton(
          onPressed: () => _selectTime(context, isStartTime),
          child: Text(label),
        ),
      ],
    );
  }
}
