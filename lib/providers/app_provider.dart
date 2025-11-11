import 'package:flutter/foundation.dart';
import '../models/user_progress.dart';
import '../models/badge.dart';
import '../models/mission.dart';
import '../models/landmark.dart';
import '../models/question.dart';
import '../services/storage_service.dart';
import '../services/badge_service.dart';
import '../services/mission_service.dart';
import '../services/landmark_service.dart';

/// Main provider for managing app state
class AppProvider extends ChangeNotifier {
  final StorageService _storageService = StorageService();
  final BadgeService _badgeService = BadgeService();
  final MissionService _missionService = MissionService();
  final LandmarkService _landmarkService = LandmarkService();

  UserProgress _userProgress = const UserProgress();
  List<Badge> _badges = [];
  List<Mission> _missions = [];
  Landmark? _currentLandmark;
  Question? _currentQuestion;

  UserProgress get userProgress => _userProgress;
  List<Badge> get badges => _badges;
  List<Mission> get missions => _missions;
  Landmark? get currentLandmark => _currentLandmark;
  Question? get currentQuestion => _currentQuestion;

  List<Badge> get earnedBadges => 
      _badges.where((badge) => badge.isEarned).toList();
  
  List<Mission> get activeMissions => 
      _missions.where((mission) => !mission.isCompleted).toList();
  
  List<Mission> get completedMissions => 
      _missions.where((mission) => mission.isCompleted).toList();

  /// Initialize app data
  Future<void> initialize() async {
    await _loadUserProgress();
    await _loadBadges();
    await _loadMissions();
  }

  Future<void> _loadUserProgress() async {
    _userProgress = await _storageService.getUserProgress();
    notifyListeners();
  }

  Future<void> _loadBadges() async {
    final savedBadges = await _storageService.getBadges();
    if (savedBadges.isEmpty) {
      // Initialize with all available badges
      _badges = _badgeService.getAllBadges();
    } else {
      _badges = savedBadges;
    }
    notifyListeners();
  }

  Future<void> _loadMissions() async {
    final savedMissions = await _storageService.getMissions();
    if (savedMissions.isEmpty) {
      // Initialize with generated missions
      _missions = _missionService.generateMissions();
    } else {
      _missions = _missionService.resetExpiredMissions(savedMissions);
    }
    await _storageService.saveMissions(_missions);
    notifyListeners();
  }

  /// Recognize a landmark from AR detection
  Future<void> recognizeLandmark(String detectedText) async {
    final landmark = _landmarkService.recognizeLandmark(detectedText);
    if (landmark != null) {
      _currentLandmark = landmark;
      
      // Get a question for this landmark
      final questions = _landmarkService.getQuestionsForLandmark(landmark.id);
      if (questions.isNotEmpty) {
        _currentQuestion = questions.first;
      }
      
      notifyListeners();
    }
  }

  /// Set current landmark manually (for testing)
  void setCurrentLandmark(Landmark landmark) {
    _currentLandmark = landmark;
    final questions = _landmarkService.getQuestionsForLandmark(landmark.id);
    if (questions.isNotEmpty) {
      _currentQuestion = questions.first;
    }
    notifyListeners();
  }

  /// Submit an answer to the current question
  Future<bool> submitAnswer(int selectedIndex) async {
    if (_currentQuestion == null || _currentLandmark == null) {
      return false;
    }

    final isCorrect = selectedIndex == _currentQuestion!.correctAnswerIndex;

    if (isCorrect) {
      await _awardPoints(_currentQuestion!.points);
      await _updateLandmarkProgress(_currentLandmark!.id);
      await _updateStreak();
      await _checkAndAwardBadges();
      await _updateMissions();
    }

    return isCorrect;
  }

  Future<void> _awardPoints(int points) async {
    _userProgress = _userProgress.copyWith(
      totalPoints: _userProgress.totalPoints + points,
    );
    await _storageService.saveUserProgress(_userProgress);
    notifyListeners();
  }

  Future<void> _updateLandmarkProgress(String landmarkId) async {
    final completedIds = List<String>.from(_userProgress.completedLandmarkIds);
    if (!completedIds.contains(landmarkId)) {
      completedIds.add(landmarkId);
    }

    final visitCounts = Map<String, int>.from(_userProgress.landmarkVisitCounts);
    visitCounts[landmarkId] = (visitCounts[landmarkId] ?? 0) + 1;

    _userProgress = _userProgress.copyWith(
      completedLandmarkIds: completedIds,
      landmarkVisitCounts: visitCounts,
    );
    await _storageService.saveUserProgress(_userProgress);
    notifyListeners();
  }

  Future<void> _updateStreak() async {
    final now = DateTime.now();
    final lastActivity = _userProgress.lastActivityDate;

    int newStreak = _userProgress.currentStreak;

    if (lastActivity == null) {
      newStreak = 1;
    } else {
      final daysDiff = now.difference(lastActivity).inDays;
      if (daysDiff == 0) {
        // Same day, keep streak
        newStreak = _userProgress.currentStreak;
      } else if (daysDiff == 1) {
        // Consecutive day, increase streak
        newStreak = _userProgress.currentStreak + 1;
      } else {
        // Streak broken, reset to 1
        newStreak = 1;
      }
    }

    final longestStreak = newStreak > _userProgress.longestStreak 
        ? newStreak 
        : _userProgress.longestStreak;

    _userProgress = _userProgress.copyWith(
      currentStreak: newStreak,
      longestStreak: longestStreak,
      lastActivityDate: now,
    );
    await _storageService.saveUserProgress(_userProgress);
    notifyListeners();
  }

  Future<void> _checkAndAwardBadges() async {
    final newBadges = _badgeService.checkForNewBadges(
      totalPoints: _userProgress.totalPoints,
      currentStreak: _userProgress.currentStreak,
      landmarksDiscovered: _userProgress.completedLandmarkIds.length,
      earnedBadgeIds: _userProgress.earnedBadgeIds,
    );

    if (newBadges.isNotEmpty) {
      final earnedIds = List<String>.from(_userProgress.earnedBadgeIds);
      
      for (final badge in newBadges) {
        earnedIds.add(badge.id);
        // Update badge in list
        final index = _badges.indexWhere((b) => b.id == badge.id);
        if (index != -1) {
          _badges[index] = badge;
        }
      }

      _userProgress = _userProgress.copyWith(earnedBadgeIds: earnedIds);
      await _storageService.saveUserProgress(_userProgress);
      await _storageService.saveBadges(_badges);
      notifyListeners();
    }
  }

  Future<void> _updateMissions() async {
    bool updated = false;

    for (int i = 0; i < _missions.length; i++) {
      final mission = _missions[i];
      
      if (mission.isCompleted) continue;

      bool shouldUpdate = false;
      int increment = 0;

      switch (mission.type) {
        case MissionType.landmark:
          if (_currentLandmark != null) {
            shouldUpdate = true;
            increment = 1;
          }
          break;
        case MissionType.daily:
        case MissionType.weekly:
        case MissionType.special:
          shouldUpdate = true;
          increment = 1;
          break;
      }

      if (shouldUpdate) {
        _missions[i] = _missionService.updateProgress(mission, increment);
        
        if (_missions[i].isCompleted && !mission.isCompleted) {
          // Mission just completed, award bonus points
          await _awardPoints(_missions[i].rewardPoints);
        }
        
        updated = true;
      }
    }

    if (updated) {
      await _storageService.saveMissions(_missions);
      notifyListeners();
    }
  }

  /// Clear current landmark and question
  void clearCurrentQuiz() {
    _currentLandmark = null;
    _currentQuestion = null;
    notifyListeners();
  }

  /// Get all landmarks
  List<Landmark> getAllLandmarks() {
    return _landmarkService.getAllLandmarks();
  }

  /// Reset all progress (for testing)
  Future<void> resetProgress() async {
    await _storageService.clearAll();
    _userProgress = const UserProgress();
    _badges = _badgeService.getAllBadges();
    _missions = _missionService.generateMissions();
    _currentLandmark = null;
    _currentQuestion = null;
    notifyListeners();
  }
}
