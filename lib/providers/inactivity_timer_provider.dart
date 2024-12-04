// lib/providers/inactivity_timer_provider.dart
import 'dart:async';
import 'package:flutter/material.dart';

class InactivityTimerProvider with ChangeNotifier {
  Timer? _inactivityTimer;
  final BuildContext _context;

  InactivityTimerProvider(this._context);

  void resetTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(const Duration(seconds: 15), () {
      // Navega para a rota inicial e limpa a pilha de navegação
      Navigator.of(_context, rootNavigator: true).pushNamedAndRemoveUntil(
        '/',
        (route) => false,
      );
    });
    notifyListeners();
  }

  void cancelTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _inactivityTimer?.cancel();
    super.dispose();
  }
}