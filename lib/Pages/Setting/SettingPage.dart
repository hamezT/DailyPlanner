import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'ThemeProvider.dart'; // Import ThemeProvider

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài đặt'),
      ),
      body: SingleChildScrollView( // Wrap the body in a SingleChildScrollView
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: const Text('Thay đổi thông tin cá nhân'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to change personal information page
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Thay đổi mật khẩu'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to change password page
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Chế độ tối/sáng'),
              trailing: Switch(
                value: themeProvider.isDarkMode,
                onChanged: (value) {
                  themeProvider.toggleTheme(); // Change theme when user toggles
                },
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text('Chọn màu sắc'),
              trailing: Container(
                width: 20,
                height: 20,
                color: themeProvider.bottomNavBarColor, // Show current color
              ),
              onTap: () {
                _showColorPicker(context, themeProvider);
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Chọn font chữ'),
              trailing: DropdownButton<String>(
                value: themeProvider.selectedFont,
                onChanged: (String? newFont) {
                  if (newFont != null) {
                    themeProvider.updateSelectedFont(newFont); // Update selected font
                  }
                },
                items: const [
                  DropdownMenuItem<String>(
                    value: 'Roboto',
                    child: Text('Roboto'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Arial',
                    child: Text('Arial'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Courier New',
                    child: Text('Courier New'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Times New Roman',
                    child: Text('Times New Roman'),
                  ),
                ],
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text('Thông báo'),
              trailing: Switch(
                value: true, // You can manage this state as needed
                onChanged: (value) {
                  // Handle notification toggle
                },
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text('Đăng xuất'),
              trailing: const Icon(Icons.logout),
              onTap: () {
                // Implement user logout action
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showColorPicker(BuildContext context, ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Chọn màu sắc'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: themeProvider.bottomNavBarColor,
              onColorChanged: (Color newColor) {
                themeProvider.updateBottomNavBarColor(newColor); // Update color
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Đóng'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}
