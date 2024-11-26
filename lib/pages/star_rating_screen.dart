import 'package:app_viacredi_v2/pages/cpf_screen.dart';
import 'package:flutter/material.dart';

class StarRatingScreen extends StatefulWidget {
  const StarRatingScreen({super.key});

  @override
  State<StarRatingScreen> createState() => _StarRatingScreenState();
}

class _StarRatingScreenState extends State<StarRatingScreen> {
  final Map<String, int> ratings = {
    'Ambiente do Posto de Atendimento': 0,
    'Atendimento dos colaboradores': 0,
    'Tempo de espera': 0,
  };

  final Map<String, int> hoverRatings = {
    'Ambiente do Posto de Atendimento': 0,
    'Atendimento dos colaboradores': 0,
    'Tempo de espera': 0,
  };

  bool get canProceed => ratings.values.every((rating) => rating > 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/totem/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: -20,
              child: Image.asset(
                'assets/img/totem/desenho.png',
                height: 180,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStarRatingSection('Ambiente do Posto de Atendimento'),
                  const SizedBox(height: 50), // Increased spacing
                  _buildStarRatingSection('Atendimento dos colaboradores'),
                  const SizedBox(height: 50), // Increased spacing
                  _buildStarRatingSection('Tempo de espera'),
                  const SizedBox(height: 60), // Increased spacing
                  ElevatedButton(
                    onPressed: canProceed
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CpfScreen(),
                              ),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40, // Increased padding
                        vertical: 20, // Increased padding
                      ),
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35), // Increased radius
                      ),
                      disabledBackgroundColor: Colors.grey,
                    ),
                    child: const Text(
                      'Enviar',
                      style: TextStyle(
                        fontSize: 28, // Increased font size
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStarRatingSection(String title) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 26, // Increased font size
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20), // Increased spacing
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            5,
            (index) => MouseRegion(
              onEnter: (_) {
                setState(() {
                  hoverRatings[title] = index + 1;
                });
              },
              onExit: (_) {
                setState(() {
                  hoverRatings[title] = 0;
                });
              },
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    ratings[title] = index + 1;
                  });
                },
                child: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 200),
                  tween: Tween<double>(
                    begin: 1.0,
                    end: _shouldHighlight(title, index) ? 1.2 : 1.0,
                  ),
                  builder: (context, scale, child) {
                    return Transform.scale(
                      scale: scale,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8, // Increased padding
                          vertical: 4,
                        ),
                        child: Image.asset(
                          _getStarImage(title, index),
                          width: 60, // Increased star size
                          height: 60, // Increased star size
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  bool _shouldHighlight(String title, int index) {
    if (hoverRatings[title]! > 0) {
      return index < hoverRatings[title]!;
    }
    return false;
  }

  String _getStarImage(String title, int index) {
    if (hoverRatings[title]! > 0) {
      return index < hoverRatings[title]!
          ? 'assets/img/totem/estrela_active.png'
          : 'assets/img/totem/starlight.png';
    }
    return ratings[title]! > index
        ? 'assets/img/totem/estrela_active.png'
        : 'assets/img/totem/starlight.png';
  }
}