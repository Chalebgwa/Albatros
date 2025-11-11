/// Represents a quiz question for a landmark
class Question {
  final String id;
  final String landmarkId;
  final String questionText;
  final List<String> options;
  final int correctAnswerIndex;
  final int points;
  final String explanation;

  const Question({
    required this.id,
    required this.landmarkId,
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
    required this.points,
    required this.explanation,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'landmarkId': landmarkId,
      'questionText': questionText,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
      'points': points,
      'explanation': explanation,
    };
  }

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as String,
      landmarkId: json['landmarkId'] as String,
      questionText: json['questionText'] as String,
      options: List<String>.from(json['options'] as List),
      correctAnswerIndex: json['correctAnswerIndex'] as int,
      points: json['points'] as int,
      explanation: json['explanation'] as String,
    );
  }
}
