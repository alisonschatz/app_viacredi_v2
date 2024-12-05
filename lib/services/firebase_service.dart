import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/feedback_data.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveFeedback(FeedbackData feedback) async {
    try {
      // Cria uma coleção 'feedback' e dentro dela uma coleção com o ano e mês atual
      final now = DateTime.now();
      final yearMonth = '${now.year}_${now.month.toString().padLeft(2, '0')}';
      
      await _firestore
          .collection('feedback')
          .doc(yearMonth)
          .collection('responses')
          .add({
        'npsRating': feedback.npsRating,
        'starRatings': feedback.starRatings,
        'cpf': feedback.cpf,
        'comment': feedback.comment,
        'timestamp': Timestamp.fromDate(feedback.timestamp),
        'date': feedback.timestamp.toLocal().toString().split(' ')[0], // YYYY-MM-DD
        'time': feedback.timestamp.toLocal().toString().split(' ')[1], // HH:mm:ss
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error saving feedback: $e');
      }
      rethrow;
    }
  }

  // Método para obter todos os feedbacks de um mês específico
  Stream<QuerySnapshot> getFeedbacksByMonth(int year, int month) {
    final yearMonth = '${year}_${month.toString().padLeft(2, '0')}';
    
    return _firestore
        .collection('feedback')
        .doc(yearMonth)
        .collection('responses')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // Método para obter estatísticas de NPS
  Future<Map<String, dynamic>> getNPSStatistics(int year, int month) async {
    final yearMonth = '${year}_${month.toString().padLeft(2, '0')}';
    
    final querySnapshot = await _firestore
        .collection('feedback')
        .doc(yearMonth)
        .collection('responses')
        .get();

    int promoters = 0;
    int passives = 0;
    int detractors = 0;

    for (var doc in querySnapshot.docs) {
      final rating = doc.data()['npsRating'] as int;
      if (rating >= 9) {
        promoters++;
      } else if (rating >= 7) {
        passives++;
      } else {
        detractors++;
      }
    }

    final total = querySnapshot.docs.length;
    final npsScore = total > 0 
        ? ((promoters - detractors) / total * 100).round()
        : 0;

    return {
      'total': total,
      'promoters': promoters,
      'passives': passives,
      'detractors': detractors,
      'npsScore': npsScore,
    };
  }

  // Método para obter média das avaliações por estrelas
  Future<Map<String, double>> getStarRatingsAverage(int year, int month) async {
    final yearMonth = '${year}_${month.toString().padLeft(2, '0')}';
    
    final querySnapshot = await _firestore
        .collection('feedback')
        .doc(yearMonth)
        .collection('responses')
        .get();

    Map<String, List<int>> ratings = {
      'Ambiente do Posto de Atendimento': [],
      'Atendimento dos colaboradores': [],
      'Tempo de espera': [],
    };

    for (var doc in querySnapshot.docs) {
      final starRatings = doc.data()['starRatings'] as Map<String, dynamic>;
      starRatings.forEach((key, value) {
        ratings[key]?.add(value as int);
      });
    }

    Map<String, double> averages = {};
    ratings.forEach((key, values) {
      if (values.isNotEmpty) {
        averages[key] = values.reduce((a, b) => a + b) / values.length;
      } else {
        averages[key] = 0;
      }
    });

    return averages;
  }
}