import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/background_container.dart';
import '../services/inactivity_timer_service.dart';
import '../providers/feedback_provider.dart';
import 'success_screen.dart';
import 'numpad_screen.dart';

class CpfScreen extends StatefulWidget {
  const CpfScreen({super.key});

  @override
  State<CpfScreen> createState() => _CpfScreenState();
}

class _CpfScreenState extends State<CpfScreen> {
  void _resetTimer() {
    InactivityTimerService().resetTimer();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _resetTimer();
    });
  }

  void _navigateToNumpad() {
    _resetTimer();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NumpadScreen(),
      ),
    );
  }

  Future<void> _skipAndNavigateToSuccess() async {
    _resetTimer();
    final provider = Provider.of<FeedbackProvider>(context, listen: false);
    
    try {
      await provider.submitFeedback();
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const SuccessScreen(),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar feedback: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _resetTimer(),
      behavior: HitTestBehavior.translucent,
      child: Scaffold(
        body: BackgroundContainer(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Gostaria de informar seu CPF?',
                  style: TextStyle(
                    fontSize: 62, 
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildOptionButton(
                      context,
                      'Sim',
                      Colors.green,
                      _navigateToNumpad,
                    ),
                    const SizedBox(width: 100),
                    _buildOptionButton(
                      context,
                      'Não',
                      Colors.orange,
                      _skipAndNavigateToSuccess,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionButton(
    BuildContext context,
    String text,
    Color color,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: 180,
      height: 80,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 0,
            vertical: 0,
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 32, 
            fontWeight: FontWeight.bold, 
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}