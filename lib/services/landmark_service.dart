import '../models/landmark.dart';
import '../models/question.dart';

/// Service for managing landmark data and questions
class LandmarkService {
  /// Sample landmarks data - in a production app, this would come from a backend
  static final List<Landmark> _landmarks = [
    Landmark(
      id: 'landmark_1',
      name: 'Eiffel Tower',
      description: 'Iconic iron lattice tower in Paris, France',
      imagePath: 'assets/landmarks/eiffel_tower.jpg',
      recognitionKeywords: ['eiffel', 'tower', 'paris', 'iron', 'france'],
      latitude: 48.8584,
      longitude: 2.2945,
    ),
    Landmark(
      id: 'landmark_2',
      name: 'Statue of Liberty',
      description: 'Colossal neoclassical sculpture in New York Harbor',
      imagePath: 'assets/landmarks/statue_of_liberty.jpg',
      recognitionKeywords: ['statue', 'liberty', 'new york', 'freedom', 'torch'],
      latitude: 40.6892,
      longitude: -74.0445,
    ),
    Landmark(
      id: 'landmark_3',
      name: 'Great Wall of China',
      description: 'Ancient series of fortifications in northern China',
      imagePath: 'assets/landmarks/great_wall.jpg',
      recognitionKeywords: ['great wall', 'china', 'wall', 'fortress'],
      latitude: 40.4319,
      longitude: 116.5704,
    ),
    Landmark(
      id: 'landmark_4',
      name: 'Taj Mahal',
      description: 'Ivory-white marble mausoleum in Agra, India',
      imagePath: 'assets/landmarks/taj_mahal.jpg',
      recognitionKeywords: ['taj mahal', 'india', 'marble', 'agra', 'mausoleum'],
      latitude: 27.1751,
      longitude: 78.0421,
    ),
    Landmark(
      id: 'landmark_5',
      name: 'Colosseum',
      description: 'Ancient amphitheater in Rome, Italy',
      imagePath: 'assets/landmarks/colosseum.jpg',
      recognitionKeywords: ['colosseum', 'rome', 'italy', 'amphitheater', 'gladiator'],
      latitude: 41.8902,
      longitude: 12.4922,
    ),
  ];

  /// Sample questions data
  static final List<Question> _questions = [
    Question(
      id: 'q1',
      landmarkId: 'landmark_1',
      questionText: 'In which year was the Eiffel Tower completed?',
      options: ['1887', '1889', '1891', '1893'],
      correctAnswerIndex: 1,
      points: 10,
      explanation: 'The Eiffel Tower was completed in 1889 as the entrance arch to the 1889 World\'s Fair.',
    ),
    Question(
      id: 'q2',
      landmarkId: 'landmark_2',
      questionText: 'What does the Statue of Liberty hold in her right hand?',
      options: ['A book', 'A sword', 'A torch', 'A flag'],
      correctAnswerIndex: 2,
      points: 10,
      explanation: 'The Statue of Liberty holds a torch in her right hand, symbolizing enlightenment.',
    ),
    Question(
      id: 'q3',
      landmarkId: 'landmark_3',
      questionText: 'Approximately how long is the Great Wall of China?',
      options: ['5,500 km', '13,000 km', '21,000 km', '30,000 km'],
      correctAnswerIndex: 2,
      points: 10,
      explanation: 'The Great Wall of China is approximately 21,000 kilometers long including all branches.',
    ),
    Question(
      id: 'q4',
      landmarkId: 'landmark_4',
      questionText: 'Who built the Taj Mahal?',
      options: ['Akbar', 'Shah Jahan', 'Aurangzeb', 'Humayun'],
      correctAnswerIndex: 1,
      points: 10,
      explanation: 'The Taj Mahal was commissioned by Mughal emperor Shah Jahan in memory of his wife.',
    ),
    Question(
      id: 'q5',
      landmarkId: 'landmark_5',
      questionText: 'What was the primary use of the Colosseum?',
      options: ['Religious ceremonies', 'Gladiatorial contests', 'Royal residence', 'Market place'],
      correctAnswerIndex: 1,
      points: 10,
      explanation: 'The Colosseum was primarily used for gladiatorial contests and public spectacles.',
    ),
  ];

  List<Landmark> getAllLandmarks() {
    return List.unmodifiable(_landmarks);
  }

  Landmark? getLandmarkById(String id) {
    try {
      return _landmarks.firstWhere((landmark) => landmark.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Question> getQuestionsForLandmark(String landmarkId) {
    return _questions.where((q) => q.landmarkId == landmarkId).toList();
  }

  Question? getQuestionById(String id) {
    try {
      return _questions.firstWhere((question) => question.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Simple keyword-based landmark recognition
  /// In production, this would use ML model for image recognition
  Landmark? recognizeLandmark(String detectedText) {
    final lowerText = detectedText.toLowerCase();
    
    for (final landmark in _landmarks) {
      for (final keyword in landmark.recognitionKeywords) {
        if (lowerText.contains(keyword.toLowerCase())) {
          return landmark;
        }
      }
    }
    
    return null;
  }
}
