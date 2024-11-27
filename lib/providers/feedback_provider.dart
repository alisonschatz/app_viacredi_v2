import 'package:flutter/foundation.dart';
import '../services/firebase_service.dart';
import '../models/feedback_data.dart';

class FeedbackProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  
  int? npsRating;
  Map<String, int> starRatings = {
    'Ambiente do Posto de Atendimento': 0,
    'Atendimento dos colaboradores': 0,
    'Tempo de espera': 0,
  };
  String? cpf;
  String? comment;

  void setNpsRating(int rating) {
    npsRating = rating;
    notifyListeners();
  }

  void setStarRating(String category, int rating) {
    starRatings[category] = rating;
    notifyListeners();
  }

  void setCpf(String? value) {
    cpf = value;
    notifyListeners();
  }

  void setComment(String? value) {
    comment = value;
    notifyListeners();
  }

  Future<void> submitFeedback() async {
    if (npsRating == null) return;

    final feedback = FeedbackData(
      npsRating: npsRating!,
      starRatings: starRatings,
      cpf: cpf,
      comment: comment,
      timestamp: DateTime.now(),
    );

    await _firebaseService.saveFeedback(feedback);
    
    // Limpar os dados após envio
    npsRating = null;
    starRatings = {
      'Ambiente do Posto de Atendimento': 0,
      'Atendimento dos colaboradores': 0,
      'Tempo de espera': 0,
    };
    cpf = null;
    comment = null;
    notifyListeners();
  }
}