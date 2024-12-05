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
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final maxWidth = screenWidth > 1200 ? 1200.0 : screenWidth * 0.9;

    final starSize = (screenWidth * 0.08).clamp(40.0, 60.0);
    final titleSize = (screenWidth * 0.025).clamp(18.0, 26.0);

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
                  // Elemento decorativo
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
                  // Conteúdo principal
                  Center(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                        vertical: 20,
                      ),
                      child: Container(
                        width: maxWidth,
                        constraints: const BoxConstraints(maxWidth: 1200),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ...ratings.keys.map((title) => Padding(
                                  padding: const EdgeInsets.only(bottom: 40),
                                  child: _buildStarRatingSection(
                                    title,
                                    titleSize,
                                    starSize,
                                  ),
                                )),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: maxWidth * 0.4,
                              height: 50,
                              child: ElevatedButton(
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
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  disabledBackgroundColor: Colors.grey,
                                ),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    child: Text(
                                      'Enviar',
                                      style: TextStyle(
                                        fontSize: titleSize * 0.8,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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

  Widget _buildStarRatingSection(String title, double titleSize, double starSize) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            title,
            style: TextStyle(
              fontSize: titleSize,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
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
                          width: starSize,
                          height: starSize,
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