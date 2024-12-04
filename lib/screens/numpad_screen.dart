import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/feedback_provider.dart';
import '../services/inactivity_timer_service.dart';
import '../widgets/background_container.dart';
import 'comment_screen.dart';

bool isCPFValid(String cpf) {
  // Remove caracteres não numéricos
  cpf = cpf.replaceAll(RegExp(r'[^0-9]'), '');

  // Verifica se tem 11 dígitos
  if (cpf.length != 11) return false;

  // Verifica se todos os dígitos são iguais
  if (RegExp(r'^(\d)\1*$').hasMatch(cpf)) return false;

  // Calcula primeiro dígito verificador
  int sum = 0;
  for (int i = 0; i < 9; i++) {
    sum += int.parse(cpf[i]) * (10 - i);
  }
  int digit1 = 11 - (sum % 11);
  if (digit1 > 9) digit1 = 0;

  // Verifica primeiro dígito
  if (digit1 != int.parse(cpf[9])) return false;

  // Calcula segundo dígito verificador
  sum = 0;
  for (int i = 0; i < 10; i++) {
    sum += int.parse(cpf[i]) * (11 - i);
  }
  int digit2 = 11 - (sum % 11);
  if (digit2 > 9) digit2 = 0;

  // Verifica segundo dígito
  return digit2 == int.parse(cpf[10]);
}

class NumpadScreen extends StatefulWidget {
  const NumpadScreen({super.key});

  @override
  State<NumpadScreen> createState() => _NumpadScreenState();
}

class _NumpadScreenState extends State<NumpadScreen> {
  String cpf = '';

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

  void addNumber(String number) {
    _resetTimer();
    if (cpf.length < 11) {
      setState(() {
        cpf += number;
      });
    }
  }

  void removeNumber() {
    _resetTimer();
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

  void _validateAndProceed(FeedbackProvider provider) {
    if (!isCPFValid(cpf)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('CPF inválido. Por favor, digite novamente.'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      setState(() {
        cpf = '';
      });
      return;
    }

    provider.setCpf(cpf);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CommentScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FeedbackProvider>(
      builder: (context, provider, child) {
        return GestureDetector(
          onTapDown: (_) => _resetTimer(),
          behavior: HitTestBehavior.translucent,
          child: Scaffold(
            body: BackgroundContainer(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final maxWidth = constraints.maxWidth;
                  final maxHeight = constraints.maxHeight;
                  
                  final numpadWidth = maxWidth > 600 ? 400.0 : maxWidth * 0.9;
                  final buttonWidth = numpadWidth / 5;
                  final buttonHeight = buttonWidth * 0.6;

                  return Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 120),
                          SizedBox(
                            width: numpadWidth,
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                    vertical: buttonHeight * 0.3,
                                    horizontal: buttonWidth * 0.25,
                                  ),
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
                                    style: TextStyle(
                                      fontSize: buttonHeight * 0.6,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(buttonHeight * 0.2),
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
                                          padding: EdgeInsets.symmetric(vertical: buttonHeight * 0.1),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              for (var j = 1; j <= 3; j++)
                                                _buildNumpadButton(
                                                  '${(i * 3) + j}',
                                                  width: buttonWidth,
                                                  height: buttonHeight,
                                                ),
                                            ],
                                          ),
                                        ),
                                      Padding(
                                        padding: EdgeInsets.only(top: buttonHeight * 0.1),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            SizedBox(width: buttonWidth, height: buttonHeight),
                                            _buildNumpadButton('0', width: buttonWidth, height: buttonHeight),
                                            _buildNumpadButton('⌫', width: buttonWidth, height: buttonHeight, isBackspace: true),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: maxHeight * 0.05),
                          SizedBox(
                            width: numpadWidth * 0.7,
                            height: buttonHeight * 1.2,
                            child: ElevatedButton(
                              onPressed: cpf.length == 11
                                  ? () {
                                      _resetTimer();
                                      _validateAndProceed(provider);
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: Text(
                                'Enviar',
                                style: TextStyle(
                                  fontSize: buttonHeight * 0.4,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNumpadButton(
    String text, {
    required double width,
    required double height,
    bool isBackspace = false,
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: () {
          _resetTimer();
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
          style: TextStyle(
            fontSize: height * 0.5,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}