import 'package:flutter/material.dart';
import '../widgets/background_container.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

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
                'Obrigado!',
                style: TextStyle(
                  fontSize: 140,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 44,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(text: 'Seus dados foram enviados com '),
                    TextSpan(
                      text: 'sucesso!',
                      style: TextStyle(
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

