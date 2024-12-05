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
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;
    final maxWidth = screenWidth > 1200 ? 1200.0 : screenWidth * 0.9;

    // Cálculos responsivos
    final titleSize = (screenWidth * 0.05).clamp(32.0, 62.0);
    final buttonWidth = (screenWidth * 0.15).clamp(120.0, 180.0);
    final buttonHeight = (screenHeight * 0.1).clamp(50.0, 80.0);
    final buttonFontSize = (screenWidth * 0.025).clamp(20.0, 32.0);
    final buttonSpacing = (screenWidth * 0.05).clamp(20.0, 100.0);
    final verticalSpacing = (screenHeight * 0.06).clamp(30.0, 60.0);

    return GestureDetector(
      onTapDown: (_) => _resetTimer(),
      behavior: HitTestBehavior.translucent,
      child: Scaffold(
        body: BackgroundContainer(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: screenHeight * 0.02,
              ),
              child: Container(
                width: maxWidth,
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Gostaria de informar seu CPF?',
                        style: TextStyle(
                          fontSize: titleSize,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: verticalSpacing),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildOptionButton(
                          context,
                          'Sim',
                          Colors.green,
                          _navigateToNumpad,
                          buttonWidth,
                          buttonHeight,
                          buttonFontSize,
                        ),
                        SizedBox(width: buttonSpacing),
                        _buildOptionButton(
                          context,
                          'Não',
                          Colors.orange,
                          _skipAndNavigateToSuccess,
                          buttonWidth,
                          buttonHeight,
                          buttonFontSize,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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
    double width,
    double height,
    double fontSize,
  ) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35),
          ),
          padding: EdgeInsets.zero,
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}