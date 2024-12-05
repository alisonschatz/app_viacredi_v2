import 'package:flutter/material.dart';
import 'rating_screen.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const RatingScreen()),
          (Route<dynamic> route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final screenHeight = constraints.maxHeight;
          
          // Cálculos responsivos
          final containerWidth = screenWidth > 1200 ? 1200.0 : screenWidth * 0.9;
          final thanksSize = (screenWidth * 0.1).clamp(60.0, 140.0);
          final messageSize = (screenWidth * 0.045).clamp(24.0, 60.0);
          final loaderSize = (screenWidth * 0.04).clamp(40.0, 50.0);
          

          return Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/img/totem/bg.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: -25,
                  right: -10,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 200,
                      maxHeight: 200,
                    ),
                    child: Image.asset(
                      'assets/img/totem/desenho.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Center(
                  child: SingleChildScrollView(
                    child: Container(
                      width: containerWidth,
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                        vertical: screenHeight * 0.02,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FittedBox(
                            child: Text(
                              'Obrigado!',
                              style: TextStyle(
                                fontSize: thanksSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: messageSize,
                                  color: Colors.black,
                                ),
                                children: const [
                                  TextSpan(text: 'Seus dados foram enviados com '),
                                  TextSpan(
                                    text: 'sucesso!',
                                    style: TextStyle(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.03),
                          SizedBox(
                            width: loaderSize,
                            height: loaderSize,
                            child: const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                              strokeWidth: 4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}