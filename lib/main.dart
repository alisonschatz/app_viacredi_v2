import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'providers/feedback_provider.dart';
import 'screens/rating_screen.dart';
import 'services/inactivity_timer_service.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => FeedbackProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Viacredi Feedback',
        theme: ThemeData(
          primaryColor: const Color(0xFF00A0DC),
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00A0DC)),
          useMaterial3: false,
        ),
        routes: {
          '/': (context) => Builder(
            builder: (context) {
              InactivityTimerService().initialize(context);
              return const RatingScreen();
            },
          ),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}