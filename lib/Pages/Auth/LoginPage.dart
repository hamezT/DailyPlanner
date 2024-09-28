// ignore_for_file: use_build_context_synchronously, file_names

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Services/api.dart';
import '../Loading/LoadingPage.dart'; // Import LoadingPage

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  // Gọi API login
  Future<void> login() async {
    setState(() {
      isLoading = true;
    });

    String email = emailController.text;
    String password = passwordController.text;

    if (email.isNotEmpty && password.isNotEmpty) {
      Api api = Api();
      final response = await api.login(email, password);

      if (response != null && response['token'] != null) {
        // Lưu token vào SharedPreferences và chuyển hướng nếu đăng nhập thành công
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response['token']);

        // Chuyển đến ListTaskPage
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => const TaskListPage()),
        // );
        // Trong LoginPage.dart, sau khi đăng nhập thành công
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Hiển thị lỗi nếu đăng nhập không thành công
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response?['message'] ?? 'Login failed')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Nếu đang tải thì hiển thị trang LoadingPage
    if (isLoading) {
      return const LoadingPage();
    }

    return Scaffold(
      backgroundColor: Colors.white, // Nền trắng đơn giản và chuyên nghiệp
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 80), // Khoảng cách từ trên cùng đến logo
              // Logo của ứng dụng
              Image.asset(
                'assets/daily_planner_logo.png', // Thay đường dẫn đến logo của bạn
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 40), // Khoảng cách giữa logo và form
              // Tiêu đề "Login"
              const Text(
                'Welcome to Daily Planner',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 20), // Khoảng cách giữa tiêu đề và form
              // Form nhập email
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 20), // Khoảng cách giữa email và password
              // Form nhập password
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 40), // Khoảng cách giữa form và nút login
              // Nút login
              ElevatedButton(
                onPressed: login,
                style: ElevatedButton.styleFrom(
                  minimumSize:
                      const Size(double.infinity, 50), // Nút full-width
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 20), // Khoảng cách dưới nút login
              // Link quên mật khẩu hoặc đăng ký
              TextButton(
                onPressed: () {
                  // Điều hướng tới trang quên mật khẩu hoặc đăng ký
                  Navigator.pushNamed(context, '/register');
                },
                child: const Text(
                  'Don\'t have an account? Sign up',
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
