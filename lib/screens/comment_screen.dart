import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/feedback_provider.dart';
import '../services/inactivity_timer_service.dart';
import '../widgets/background_container.dart';
import 'success_screen.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({super.key});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _commentController = TextEditingController();
  bool _isSubmitting = false;

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

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _navigateToSuccess(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const SuccessScreen(),
      ),
    );
  }

  Future<void> _handleSubmit(BuildContext context, FeedbackProvider provider) async {
    _resetTimer();
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    
    setState(() {
      _isSubmitting = true;
    });

    try {
      await provider.submitFeedback();
      if (!mounted) return;
      _navigateToSuccess(context);
    } catch (e) {
      if (!mounted) return;
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar feedback: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
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
                  final screenWidth = constraints.maxWidth;
                  final screenHeight = constraints.maxHeight;
                  final maxWidth = screenWidth > 1200 ? 1200.0 : screenWidth * 0.9;
                  final titleSize = (screenWidth * 0.035).clamp(32.0, 44.0);
                  const buttonHeight = 45.0;
                  
                  return SingleChildScrollView(
                    child: Center(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 1200),
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.05,
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 120),
                            Container(
                              width: maxWidth,
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    width: maxWidth * 0.3,
                                    height: buttonHeight,
                                    child: ElevatedButton(
                                      onPressed: _isSubmitting 
                                          ? null 
                                          : () => _handleSubmit(context, provider),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(25),
                                        ),
                                        padding: EdgeInsets.zero,
                                      ),
                                      child: _isSubmitting
                                          ? const SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : const Text(
                                              'Finalizar comentário',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'Deixe seu comentário',
                                style: TextStyle(
                                  fontSize: titleSize,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              width: maxWidth,
                              constraints: BoxConstraints(
                                minHeight: screenHeight * 0.3,
                                maxHeight: screenHeight * 0.5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.blue, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: _commentController,
                                maxLines: null,
                                expands: true,
                                style: TextStyle(
                                  fontSize: titleSize * 0.4,
                                  color: Colors.black87,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Digite seu comentário aqui...',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: titleSize * 0.4,
                                  ),
                                  contentPadding: const EdgeInsets.all(20),
                                  border: InputBorder.none,
                                ),
                                onChanged: (value) {
                                  _resetTimer();
                                  provider.setComment(value);
                                },
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.05),
                          ],
                        ),
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
}