// lib/services/inactivity_timer_service.dart
import 'dart:async';
import 'package:flutter/material.dart';

class InactivityTimerService {
  static final InactivityTimerService _instance = InactivityTimerService._internal();
  Timer? _timer;
  late BuildContext _context;

  factory InactivityTimerService() {
    return _instance;
  }

  InactivityTimerService._internal();

  void initialize(BuildContext context) {
    _context = context;
    resetTimer();
  }

  void resetTimer() {
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 15), () {
      _navigateToHome();
    });
  }

  void _navigateToHome() {
    if (_context.mounted) {
      Navigator.of(_context, rootNavigator: true)
          .pushNamedAndRemoveUntil('/', (route) => false);
    }
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}