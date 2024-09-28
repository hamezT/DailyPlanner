import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Pages/Loading/LoadingPage.dart';
import 'Pages/Auth/LoginPage.dart';
import 'Pages/Home/HomePage.dart'; // Import your HomePage with the bottom navigation bar
import 'Pages/Setting/ThemeProvider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Daily Planner',
      theme: ThemeData(
        brightness: themeProvider.isDarkMode ? Brightness.dark : Brightness.light,
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontFamily: themeProvider.selectedFont), // Apply selected font
        ),
      ),
      initialRoute: '/login', // Set the initial route to LoginPage
      routes: {
        '/login': (context) => const LoginPage(),
        '/loading': (context) => const LoadingPage(), // Route to LoadingPage
        '/home': (context) => const HomePage(), // Route to HomePage with bottom navigation
      },
    );
  }
}
