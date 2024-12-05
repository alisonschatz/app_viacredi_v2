import 'package:flutter/material.dart';

class BackgroundContainer extends StatelessWidget {
  final Widget child;

  const BackgroundContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/img/totem/bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: screenHeight * 0.02,
            left: 0,
            right: 0,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 400,
                  maxHeight: 120,
                ),
                child: SizedBox(
                  width: screenWidth * 0.4,
                  child: AspectRatio(
                    aspectRatio: 2 / 1,
                    child: Image.asset(
                      'assets/img/totem/logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          Positioned(
            top: -25,
            right: -10,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 200,
                maxHeight: 200,
              ),
              child: SizedBox(
                width: screenWidth * 0.15,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset(
                    'assets/img/totem/desenho.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),

          // Container para o conteúdo principal
          Positioned.fill(
            top: screenHeight * 0.15,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: screenHeight * 0.02,
              ),
              child: child,
            ),
          ),

          SafeArea(
            child: Container(),
          ),
        ],
      ),
    );
  }
}