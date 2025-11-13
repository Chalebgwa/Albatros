/// Tracks user progress and achievements
class UserProgress {
  final int totalPoints;
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastActivityDate;
  final List<String> completedLandmarkIds;
  final List<String> earnedBadgeIds;
  final Map<String, int> landmarkVisitCounts;

  const UserProgress({
    this.totalPoints = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastActivityDate,
    this.completedLandmarkIds = const [],
    this.earnedBadgeIds = const [],
    this.landmarkVisitCounts = const {},
  });

  UserProgress copyWith({
    int? totalPoints,
    int? currentStreak,
    int? longestStreak,
    DateTime? lastActivityDate,
    List<String>? completedLandmarkIds,
    List<String>? earnedBadgeIds,
    Map<String, int>? landmarkVisitCounts,
  }) {
    return UserProgress(
      totalPoints: totalPoints ?? this.totalPoints,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastActivityDate: lastActivityDate ?? this.lastActivityDate,
      completedLandmarkIds: completedLandmarkIds ?? this.completedLandmarkIds,
      earnedBadgeIds: earnedBadgeIds ?? this.earnedBadgeIds,
      landmarkVisitCounts: landmarkVisitCounts ?? this.landmarkVisitCounts,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalPoints': totalPoints,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'lastActivityDate': lastActivityDate?.toIso8601String(),
      'completedLandmarkIds': completedLandmarkIds,
      'earnedBadgeIds': earnedBadgeIds,
      'landmarkVisitCounts': landmarkVisitCounts,
    };
  }

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return UserProgress(
      totalPoints: json['totalPoints'] as int? ?? 0,
      currentStreak: json['currentStreak'] as int? ?? 0,
      longestStreak: json['longestStreak'] as int? ?? 0,
      lastActivityDate: json['lastActivityDate'] != null 
          ? DateTime.parse(json['lastActivityDate'] as String) 
          : null,
      completedLandmarkIds: json['completedLandmarkIds'] != null
          ? List<String>.from(json['completedLandmarkIds'] as List)
          : [],
      earnedBadgeIds: json['earnedBadgeIds'] != null
          ? List<String>.from(json['earnedBadgeIds'] as List)
          : [],
      landmarkVisitCounts: json['landmarkVisitCounts'] != null
          ? Map<String, int>.from(json['landmarkVisitCounts'] as Map)
          : {},
    );
  }
}
