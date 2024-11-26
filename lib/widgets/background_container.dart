import 'package:flutter/material.dart';

class BackgroundContainer extends StatelessWidget {
  final Widget child;

  const BackgroundContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
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
            top: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'assets/img/totem/logo.png',
                height: 150,
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: -20,
            child: Image.asset(
              'assets/img/totem/desenho.png',
              height: 180,
            ),
          ),
          Positioned.fill(
            top: 100,
            child: child,
          ),
        ],
      ),
    );
  }
}