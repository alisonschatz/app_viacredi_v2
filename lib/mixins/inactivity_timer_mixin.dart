// lib/mixins/inactivity_timer_mixin.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/inactivity_timer_provider.dart';

mixin InactivityTimerMixin<T extends StatefulWidget> on State<T> {
  void resetInactivityTimer() {
    if (mounted) {
      Provider.of<InactivityTimerProvider>(context, listen: false).resetTimer();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      resetInactivityTimer();
    });
  }
}