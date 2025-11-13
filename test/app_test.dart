import 'package:flutter_test/flutter_test.dart';
import 'package:albatros/models/landmark.dart';
import 'package:albatros/models/question.dart';
import 'package:albatros/models/badge.dart';
import 'package:albatros/models/mission.dart';
import 'package:albatros/models/user_progress.dart';
import 'package:albatros/services/landmark_service.dart';
import 'package:albatros/services/badge_service.dart';
import 'package:albatros/services/mission_service.dart';

void main() {
  group('Landmark Model Tests', () {
    test('Landmark should serialize to JSON correctly', () {
      const landmark = Landmark(
        id: 'test_1',
        name: 'Test Landmark',
        description: 'Test description',
        imagePath: 'assets/test.jpg',
        recognitionKeywords: ['test', 'landmark'],
        latitude: 0.0,
        longitude: 0.0,
      );

      final json = landmark.toJson();
      expect(json['id'], 'test_1');
      expect(json['name'], 'Test Landmark');
      expect(json['recognitionKeywords'], ['test', 'landmark']);
    });

    test('Landmark should deserialize from JSON correctly', () {
      final json = {
        'id': 'test_1',
        'name': 'Test Landmark',
        'description': 'Test description',
        'imagePath': 'assets/test.jpg',
        'recognitionKeywords': ['test', 'landmark'],
        'latitude': 0.0,
        'longitude': 0.0,
      };

      final landmark = Landmark.fromJson(json);
      expect(landmark.id, 'test_1');
      expect(landmark.name, 'Test Landmark');
      expect(landmark.recognitionKeywords.length, 2);
    });
  });

  group('Question Model Tests', () {
    test('Question should serialize correctly', () {
      const question = Question(
        id: 'q1',
        landmarkId: 'l1',
        questionText: 'Test question?',
        options: ['A', 'B', 'C', 'D'],
        correctAnswerIndex: 1,
        points: 10,
        explanation: 'Test explanation',
      );

      final json = question.toJson();
      expect(json['correctAnswerIndex'], 1);
      expect(json['points'], 10);
    });
  });

  group('Badge Model Tests', () {
    test('Badge isEarned should be false when earnedDate is null', () {
      const badge = Badge(
        id: 'b1',
        name: 'Test Badge',
        description: 'Test',
        iconPath: 'assets/badge.png',
        type: BadgeType.achievement,
        requiredPoints: 10,
      );

      expect(badge.isEarned, false);
    });

    test('Badge isEarned should be true when earnedDate is set', () {
      final badge = Badge(
        id: 'b1',
        name: 'Test Badge',
        description: 'Test',
        iconPath: 'assets/badge.png',
        type: BadgeType.achievement,
        requiredPoints: 10,
        earnedDate: DateTime.now(),
      );

      expect(badge.isEarned, true);
    });
  });

  group('Mission Model Tests', () {
    test('Mission progress should calculate correctly', () {
      const mission = Mission(
        id: 'm1',
        title: 'Test Mission',
        description: 'Test',
        type: MissionType.daily,
        targetValue: 10,
        currentProgress: 5,
        rewardPoints: 20,
      );

      expect(mission.progress, 0.5);
    });

    test('Mission copyWith should update fields', () {
      const mission = Mission(
        id: 'm1',
        title: 'Test Mission',
        description: 'Test',
        type: MissionType.daily,
        targetValue: 10,
        rewardPoints: 20,
      );

      final updated = mission.copyWith(currentProgress: 5, isCompleted: true);
      expect(updated.currentProgress, 5);
      expect(updated.isCompleted, true);
      expect(updated.id, 'm1'); // Should preserve original values
    });
  });

  group('UserProgress Model Tests', () {
    test('UserProgress should initialize with default values', () {
      const progress = UserProgress();
      expect(progress.totalPoints, 0);
      expect(progress.currentStreak, 0);
      expect(progress.completedLandmarkIds.length, 0);
    });

    test('UserProgress copyWith should update fields correctly', () {
      const progress = UserProgress();
      final updated = progress.copyWith(
        totalPoints: 100,
        currentStreak: 5,
      );

      expect(updated.totalPoints, 100);
      expect(updated.currentStreak, 5);
    });

    test('UserProgress should serialize to JSON', () {
      const progress = UserProgress(
        totalPoints: 50,
        currentStreak: 3,
        completedLandmarkIds: ['l1', 'l2'],
      );

      final json = progress.toJson();
      expect(json['totalPoints'], 50);
      expect(json['currentStreak'], 3);
      expect((json['completedLandmarkIds'] as List).length, 2);
    });
  });

  group('LandmarkService Tests', () {
    late LandmarkService service;

    setUp(() {
      service = LandmarkService();
    });

    test('Should return all landmarks', () {
      final landmarks = service.getAllLandmarks();
      expect(landmarks.isNotEmpty, true);
      expect(landmarks.length, 5); // We have 5 landmarks
    });

    test('Should find landmark by id', () {
      final landmark = service.getLandmarkById('landmark_1');
      expect(landmark, isNotNull);
      expect(landmark?.name, 'Eiffel Tower');
    });

    test('Should return null for invalid id', () {
      final landmark = service.getLandmarkById('invalid_id');
      expect(landmark, isNull);
    });

    test('Should recognize landmark from keywords', () {
      final landmark = service.recognizeLandmark('This is the Eiffel Tower');
      expect(landmark, isNotNull);
      expect(landmark?.name, 'Eiffel Tower');
    });

    test('Should return null for unrecognized text', () {
      final landmark = service.recognizeLandmark('Random text with no landmarks');
      expect(landmark, isNull);
    });

    test('Should get questions for landmark', () {
      final questions = service.getQuestionsForLandmark('landmark_1');
      expect(questions.isNotEmpty, true);
      expect(questions.first.landmarkId, 'landmark_1');
    });
  });

  group('BadgeService Tests', () {
    late BadgeService service;

    setUp(() {
      service = BadgeService();
    });

    test('Should return all badges', () {
      final badges = service.getAllBadges();
      expect(badges.isNotEmpty, true);
      expect(badges.length, greaterThan(5));
    });

    test('Should find badge by id', () {
      final badge = service.getBadgeById('badge_first_landmark');
      expect(badge, isNotNull);
      expect(badge?.name, 'First Discovery');
    });

    test('Should award first landmark badge', () {
      final newBadges = service.checkForNewBadges(
        totalPoints: 10,
        currentStreak: 1,
        landmarksDiscovered: 1,
        earnedBadgeIds: [],
      );

      expect(newBadges.any((b) => b.id == 'badge_first_landmark'), true);
    });

    test('Should award streak badge at 3 days', () {
      final newBadges = service.checkForNewBadges(
        totalPoints: 30,
        currentStreak: 3,
        landmarksDiscovered: 3,
        earnedBadgeIds: [],
      );

      expect(newBadges.any((b) => b.id == 'badge_streak_3'), true);
    });

    test('Should not award already earned badges', () {
      final newBadges = service.checkForNewBadges(
        totalPoints: 100,
        currentStreak: 5,
        landmarksDiscovered: 5,
        earnedBadgeIds: ['badge_first_landmark', 'badge_century'],
      );

      expect(newBadges.any((b) => b.id == 'badge_first_landmark'), false);
      expect(newBadges.any((b) => b.id == 'badge_century'), false);
    });
  });

  group('MissionService Tests', () {
    late MissionService service;

    setUp(() {
      service = MissionService();
    });

    test('Should generate missions', () {
      final missions = service.generateMissions();
      expect(missions.isNotEmpty, true);
      expect(missions.any((m) => m.type == MissionType.daily), true);
      expect(missions.any((m) => m.type == MissionType.weekly), true);
    });

    test('Should update mission progress', () {
      const mission = Mission(
        id: 'm1',
        title: 'Test',
        description: 'Test',
        type: MissionType.daily,
        targetValue: 5,
        currentProgress: 2,
        rewardPoints: 10,
      );

      final updated = service.updateProgress(mission, 2);
      expect(updated.currentProgress, 4);
      expect(updated.isCompleted, false);
    });

    test('Should complete mission when target reached', () {
      const mission = Mission(
        id: 'm1',
        title: 'Test',
        description: 'Test',
        type: MissionType.daily,
        targetValue: 5,
        currentProgress: 4,
        rewardPoints: 10,
      );

      final updated = service.updateProgress(mission, 1);
      expect(updated.currentProgress, 5);
      expect(updated.isCompleted, true);
      expect(updated.completedDate, isNotNull);
    });

    test('Should not exceed target value', () {
      const mission = Mission(
        id: 'm1',
        title: 'Test',
        description: 'Test',
        type: MissionType.daily,
        targetValue: 5,
        currentProgress: 4,
        rewardPoints: 10,
      );

      final updated = service.updateProgress(mission, 10);
      expect(updated.currentProgress, 5); // Should clamp to target
    });

    test('Daily mission should be expired after 1 day', () {
      final mission = Mission(
        id: 'm1',
        title: 'Test',
        description: 'Test',
        type: MissionType.daily,
        targetValue: 5,
        rewardPoints: 10,
        isCompleted: true,
        completedDate: DateTime.now().subtract(const Duration(days: 2)),
      );

      expect(service.isMissionExpired(mission), true);
    });
  });
}
