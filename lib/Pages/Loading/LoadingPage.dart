import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Nền trắng hoặc có thể thay đổi theo phong cách của bạn
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo của ứng dụng
            Image.asset(
              'assets/daily_planner_logo.png', // Đường dẫn đến logo
              width: 150, // Kích thước logo
              height: 150,
            ),
            const SizedBox(height: 30), // Khoảng cách giữa logo và dòng chào mừng
            // Thông điệp chào mừng
            const Text(
              'Chào mừng đến với Daily Planner',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent, // Màu sắc dòng chữ
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20), // Khoảng cách giữa dòng chào mừng và loading
            // Hiệu ứng loading
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent), // Màu hiệu ứng loading
            ),
            const SizedBox(height: 10),
            const Text(
              'Đang tải dữ liệu...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey, // Màu của thông báo dưới loading
              ),
            ),
          ],
        ),
      ),
    );
  }
}
