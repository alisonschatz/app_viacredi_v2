import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/feedback_provider.dart';
import '../widgets/background_container.dart';
import '../services/inactivity_timer_service.dart';
import 'star_rating_screen.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  int? selectedRating;

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
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;
    final gridWidth = screenWidth > 1200 ? 1200.0 : screenWidth * 0.9;

    final textSize = (screenWidth * 0.035).clamp(24.0, 44.0);
    final contentPadding = (screenHeight * 0.02).clamp(20.0, 40.0);

    return Consumer<FeedbackProvider>(
      builder: (context, provider, child) {
        return GestureDetector(
          onTapDown: (_) => _resetTimer(),
          behavior: HitTestBehavior.translucent,
          child: Scaffold(
            body: BackgroundContainer(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: gridWidth,
                        constraints: BoxConstraints(
                          maxWidth: 1200,
                          minHeight: textSize * 3,
                        ),
                        padding: EdgeInsets.only(bottom: contentPadding),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Container(
                            constraints: BoxConstraints(maxWidth: gridWidth),
                            child: Text(
                              'Em uma escala de 0 a 10 o quanto você indicaria a experiência de hoje para amigos e familiares?',
                              style: TextStyle(
                                fontSize: textSize,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),
                      
                      SizedBox(
                        width: gridWidth,
                        height: 130, 
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 11,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            childAspectRatio: 1,
                          ),
                          itemCount: 11,
                          itemBuilder: (context, index) {
                            return ElevatedButton(
                              onPressed: () {
                                _resetTimer();
                                setState(() {
                                  selectedRating = index;
                                });
                                provider.setNpsRating(index);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: selectedRating == index
                                    ? Colors.blue.shade700
                                    : _getColorForRating(index),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.zero,
                              ),
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    index.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 0),

                      SizedBox(
                        width: gridWidth * 0.3,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: selectedRating != null
                              ? () {
                                  _resetTimer();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const StarRatingScreen(),
                                    ),
                                  );
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            disabledBackgroundColor: Colors.grey,
                            padding: EdgeInsets.zero,
                          ),
                          child: const Text(
                            'Enviar',
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
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getColorForRating(int rating) {
    if (rating <= 2) return Colors.brown;
    if (rating <= 4) return Colors.orange;
    if (rating <= 6) return Colors.yellow[700]!;
    if (rating <= 8) return Colors.lightGreen;
    return Colors.green;
  }
}