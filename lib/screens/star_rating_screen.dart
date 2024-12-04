import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/feedback_provider.dart';
import '../services/inactivity_timer_service.dart';
import 'cpf_screen.dart';

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

  bool get canProceed => ratings.values.every((rating) => rating > 0);

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
    return Consumer<FeedbackProvider>(
      builder: (context, provider, child) {
        return GestureDetector(
          onTapDown: (_) => _resetTimer(),
          behavior: HitTestBehavior.translucent,
          child: Scaffold(
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
                        const SizedBox(height: 50),
                        _buildStarRatingSection('Atendimento dos colaboradores'),
                        const SizedBox(height: 50),
                        _buildStarRatingSection('Tempo de espera'),
                        const SizedBox(height: 60),
                        ElevatedButton(
                          onPressed: canProceed
                              ? () {
                                  _resetTimer();
                                  ratings.forEach((key, value) {
                                    provider.setStarRating(key, value);
                                  });
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
                              horizontal: 50,
                              vertical: 20,
                            ),
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStarRatingSection(String title) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            5,
            (index) => MouseRegion(
              onEnter: (_) {
                _resetTimer();
                setState(() {
                  ratings[title] = index + 1;
                });
              },
              onExit: (_) {
                _resetTimer();
                if (ratings[title] == 0) {
                  setState(() {
                    ratings[title] = 0;
                  });
                }
              },
              child: GestureDetector(
                onTap: () {
                  _resetTimer();
                  setState(() {
                    ratings[title] = index + 1;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 200),
                    tween: Tween<double>(
                      begin: 1.0,
                      end: ratings[title]! > index ? 1.2 : 1.0,
                    ),
                    builder: (context, scale, child) {
                      return Transform.scale(
                        scale: scale,
                        child: Image.asset(
                          ratings[title]! > index
                              ? 'assets/img/totem/estrela_active.png'
                              : 'assets/img/totem/starlight.png',
                          width: 60,
                          height: 60,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}