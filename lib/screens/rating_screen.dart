import 'package:app_viacredi_v2/pages/star_rating_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/background_container.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  int? selectedRating;

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
                'Em uma escala de 0 a 10 o quanto você indicaria a experiência de hoje para amigos e familiares?',
                style: TextStyle(
                  fontSize: 44, 
                  fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 11,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: 11,
                itemBuilder: (context, index) {
                  return ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedRating = index;
                      });
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
                    child: Text(
                      index.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,  // Increased font size
                        fontWeight: FontWeight.bold,  // Made numbers bold
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: selectedRating != null
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const StarRatingScreen(),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,  // Changed to blue
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35),
                  ),
                  disabledBackgroundColor: Colors.grey,
                ),
                child: const Text(
                  'Enviar',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,  // Made text bold
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

  Color _getColorForRating(int rating) {
    if (rating <= 2) return Colors.brown;
    if (rating <= 4) return Colors.orange;
    if (rating <= 6) return Colors.yellow[700]!;
    if (rating <= 8) return Colors.lightGreen;
    return Colors.green;
  }
}