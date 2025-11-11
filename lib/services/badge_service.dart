import '../models/badge.dart';

/// Service for managing badges and achievements
class BadgeService {
  /// Available badges in the system
  static final List<Badge> _availableBadges = [
    Badge(
      id: 'badge_first_landmark',
      name: 'First Discovery',
      description: 'Discover your first landmark',
      iconPath: 'assets/badges/first_discovery.png',
      type: BadgeType.achievement,
      requiredPoints: 0,
    ),
    Badge(
      id: 'badge_explorer',
      name: 'Explorer',
      description: 'Discover 5 different landmarks',
      iconPath: 'assets/badges/explorer.png',
      type: BadgeType.landmark,
      requiredPoints: 50,
    ),
    Badge(
      id: 'badge_globe_trotter',
      name: 'Globe Trotter',
      description: 'Discover all landmarks',
      iconPath: 'assets/badges/globe_trotter.png',
      type: BadgeType.landmark,
      requiredPoints: 100,
    ),
    Badge(
      id: 'badge_streak_3',
      name: '3-Day Streak',
      description: 'Complete quizzes for 3 days in a row',
      iconPath: 'assets/badges/streak_3.png',
      type: BadgeType.streak,
      requiredPoints: 30,
    ),
    Badge(
      id: 'badge_streak_7',
      name: 'Week Warrior',
      description: 'Complete quizzes for 7 days in a row',
      iconPath: 'assets/badges/streak_7.png',
      type: BadgeType.streak,
      requiredPoints: 70,
    ),
    Badge(
      id: 'badge_perfect_score',
      name: 'Perfect Score',
      description: 'Answer all questions correctly on first try',
      iconPath: 'assets/badges/perfect_score.png',
      type: BadgeType.achievement,
      requiredPoints: 50,
    ),
    Badge(
      id: 'badge_century',
      name: 'Century Club',
      description: 'Earn 100 total points',
      iconPath: 'assets/badges/century.png',
      type: BadgeType.achievement,
      requiredPoints: 100,
    ),
    Badge(
      id: 'badge_master',
      name: 'Quiz Master',
      description: 'Earn 500 total points',
      iconPath: 'assets/badges/master.png',
      type: BadgeType.master,
      requiredPoints: 500,
    ),
  ];

  List<Badge> getAllBadges() {
    return List.unmodifiable(_availableBadges);
  }

  Badge? getBadgeById(String id) {
    try {
      return _availableBadges.firstWhere((badge) => badge.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Check if a badge should be awarded based on progress
  List<Badge> checkForNewBadges({
    required int totalPoints,
    required int currentStreak,
    required int landmarksDiscovered,
    required List<String> earnedBadgeIds,
  }) {
    final newBadges = <Badge>[];

    for (final badge in _availableBadges) {
      // Skip already earned badges
      if (earnedBadgeIds.contains(badge.id)) {
        continue;
      }

      bool shouldAward = false;

      switch (badge.id) {
        case 'badge_first_landmark':
          shouldAward = landmarksDiscovered >= 1;
          break;
        case 'badge_explorer':
          shouldAward = landmarksDiscovered >= 5;
          break;
        case 'badge_globe_trotter':
          shouldAward = landmarksDiscovered >= 5; // Adjust based on total landmarks
          break;
        case 'badge_streak_3':
          shouldAward = currentStreak >= 3;
          break;
        case 'badge_streak_7':
          shouldAward = currentStreak >= 7;
          break;
        case 'badge_century':
          shouldAward = totalPoints >= 100;
          break;
        case 'badge_master':
          shouldAward = totalPoints >= 500;
          break;
        default:
          shouldAward = totalPoints >= badge.requiredPoints;
      }

      if (shouldAward) {
        newBadges.add(badge.copyWith(earnedDate: DateTime.now()));
      }
    }

    return newBadges;
  }
}
