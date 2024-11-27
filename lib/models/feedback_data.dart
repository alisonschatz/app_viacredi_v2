class FeedbackData {
  final int npsRating;
  final Map<String, int> starRatings;
  final String? cpf;
  final String? comment;
  final DateTime timestamp;

  FeedbackData({
    required this.npsRating,
    required this.starRatings,
    this.cpf,
    this.comment,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'npsRating': npsRating,
    'starRatings': starRatings,
    'cpf': cpf,
    'comment': comment,
    'timestamp': timestamp.toIso8601String(),
  };
}