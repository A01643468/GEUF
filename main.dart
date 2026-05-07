import 'package:flutter/material.dart';
import 'home_screen.dart';

void main() {
  runApp(const HeartMonitorApp());
}

class HeartMonitorApp extends StatelessWidget {
  const HeartMonitorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Heart Monitor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      ),
      home: const HomeScreen(),
    );
  }
}
