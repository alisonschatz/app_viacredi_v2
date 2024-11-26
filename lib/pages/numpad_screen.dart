// lib/screens/numpad_screen.dart
import 'package:app_viacredi_v1/pages/comment_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/background_container.dart';

class NumpadScreen extends StatefulWidget {
  const NumpadScreen({super.key});

  @override
  State<NumpadScreen> createState() => _NumpadScreenState();
}

class _NumpadScreenState extends State<NumpadScreen> {
  String cpf = '';

  void addNumber(String number) {
    if (cpf.length < 11) {
      setState(() {
        cpf += number;
      });
    }
  }

  void removeNumber() {
    if (cpf.isNotEmpty) {
      setState(() {
        cpf = cpf.substring(0, cpf.length - 1);
      });
    }
  }

  String formatCPF(String cpf) {
    if (cpf.isEmpty) return '';
    
    String formatted = cpf;
    if (cpf.length > 3) {
      formatted = '${formatted.substring(0, 3)}.${formatted.substring(3)}';
    }
    if (cpf.length > 6) {
      formatted = '${formatted.substring(0, 7)}.${formatted.substring(7)}';
    }
    if (cpf.length > 9) {
      formatted = '${formatted.substring(0, 11)}-${formatted.substring(11)}';
    }
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundContainer(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 400,
                child: Column(
                  children: [
                    // CPF Display
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 2),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        color: Colors.white,
                      ),
                      child: Text(
                        formatCPF(cpf),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,  // Made text blue
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    
                    // Numpad Container
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 2),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (var i = 0; i < 3; i++)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  for (var j = 1; j <= 3; j++)
                                    _buildNumpadButton('${(i * 3) + j}'),
                                ],
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const SizedBox(width: 80, height: 60),
                                _buildNumpadButton('0'),
                                _buildNumpadButton('⌫', isBackspace: true),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Submit Button
              ElevatedButton(
                onPressed: cpf.length == 11
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CommentScreen(),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  disabledBackgroundColor: Colors.grey,
                ),
                child: const Text(
                  'Enviar',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumpadButton(String text, {bool isBackspace = false}) {
    return SizedBox(
      width: 80,
      height: 60,
      child: ElevatedButton(
        onPressed: () {
          if (isBackspace) {
            removeNumber();
          } else {
            addNumber(text);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}