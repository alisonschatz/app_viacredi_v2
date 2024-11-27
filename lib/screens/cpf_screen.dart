import 'package:app_viacredi_v2/screens/comment_screen.dart';
import 'package:app_viacredi_v2/screens/numpad_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/background_container.dart';

class CpfScreen extends StatelessWidget {
  const CpfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NumpadScreen(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 100), //spacing between buttons
                  _buildOptionButton(
                    context,
                    'Não',
                    Colors.orange,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CommentScreen(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
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
      width: 180, //button width
      height: 80,  //button height
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