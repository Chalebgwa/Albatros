import '../models/mission.dart';

/// Service for managing missions and challenges
class MissionService {
  /// Generate daily and weekly missions
  List<Mission> generateMissions() {
    return [
      // Daily missions
      const Mission(
        id: 'daily_1',
        title: 'Daily Explorer',
        description: 'Discover 1 landmark today',
        type: MissionType.daily,
        targetValue: 1,
        rewardPoints: 5,
      ),
      const Mission(
        id: 'daily_2',
        title: 'Quiz Enthusiast',
        description: 'Answer 3 questions correctly today',
        type: MissionType.daily,
        targetValue: 3,
        rewardPoints: 10,
      ),
      // Weekly missions
      const Mission(
        id: 'weekly_1',
        title: 'Weekly Wanderer',
        description: 'Discover 3 landmarks this week',
        type: MissionType.weekly,
        targetValue: 3,
        rewardPoints: 20,
      ),
      const Mission(
        id: 'weekly_2',
        title: 'Knowledge Seeker',
        description: 'Answer 10 questions correctly this week',
        type: MissionType.weekly,
        targetValue: 10,
        rewardPoints: 30,
      ),
      // Special missions
      const Mission(
        id: 'special_1',
        title: 'Perfect Week',
        description: 'Maintain a 7-day streak',
        type: MissionType.special,
        targetValue: 7,
        rewardPoints: 50,
      ),
      const Mission(
        id: 'landmark_paris',
        title: 'Paris Explorer',
        description: 'Discover the Eiffel Tower',
        type: MissionType.landmark,
        targetValue: 1,
        rewardPoints: 15,
      ),
    ];
  }

  /// Update mission progress
  Mission updateProgress(Mission mission, int increment) {
    final newProgress = (mission.currentProgress + increment).clamp(0, mission.targetValue);
    final isCompleted = newProgress >= mission.targetValue;
    
    return mission.copyWith(
      currentProgress: newProgress,
      isCompleted: isCompleted,
      completedDate: isCompleted && mission.completedDate == null 
          ? DateTime.now() 
          : mission.completedDate,
    );
  }

  /// Check if mission is expired (for daily/weekly missions)
  bool isMissionExpired(Mission mission) {
    if (mission.completedDate != null) {
      final now = DateTime.now();
      final completedDate = mission.completedDate!;
      
      switch (mission.type) {
        case MissionType.daily:
          // Daily missions expire after 1 day
          return now.difference(completedDate).inDays >= 1;
        case MissionType.weekly:
          // Weekly missions expire after 7 days
          return now.difference(completedDate).inDays >= 7;
        default:
          return false;
      }
    }
    return false;
  }

  /// Reset expired missions
  List<Mission> resetExpiredMissions(List<Mission> missions) {
    return missions.map((mission) {
      if (isMissionExpired(mission)) {
        return Mission(
          id: mission.id,
          title: mission.title,
          description: mission.description,
          type: mission.type,
          targetValue: mission.targetValue,
          rewardPoints: mission.rewardPoints,
        );
      }
      return mission;
    }).toList();
  }
}
