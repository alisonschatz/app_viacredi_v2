// lib/main.dart
import 'package:flutter/material.dart';
import 'package:app_viacredi_v1/screens/rating_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Viacredi Feedback',
      theme: ThemeData(
        primaryColor: const Color(0xFF00A0DC),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00A0DC)),
      ),
      home: const RatingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}





