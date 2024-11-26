import 'package:flutter/material.dart';
import 'package:app_viacredi_v2/screens/rating_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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





