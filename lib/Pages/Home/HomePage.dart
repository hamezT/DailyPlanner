// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../Calendar/CalendarPage.dart'; // Import your Calendar page
import '../Task/ListTaskPage.dart'; // Import your Tasks page
import '../Setting/SettingPage.dart'; // Import your Settings page
import 'package:provider/provider.dart';
import '../Setting/ThemeProvider.dart'; // Import ThemeProvider

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    const CalendarPage(),
    const TaskListPage(),
    const SettingPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/daily_planner_logo.png',
              height: 30,
            ),
            const SizedBox(width: 8),
            const Text('Daily Planner'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(themeProvider.isDarkMode ? Icons.wb_sunny : Icons.nights_stay),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex], // Hiển thị trang con tương ứng
      bottomNavigationBar: Container(
        color: themeProvider.bottomNavBarColor, // Màu sắc Bottom Navigation Bar từ Provider
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Lịch',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment),
              label: 'Công việc',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Cài đặt',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white54,
          backgroundColor: themeProvider.bottomNavBarColor, // Màu nền
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}
