import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_progress.dart';
import '../models/badge.dart';
import '../models/mission.dart';

/// Service for persisting and retrieving user data
class StorageService {
  static const String _userProgressKey = 'user_progress';
  static const String _badgesKey = 'badges';
  static const String _missionsKey = 'missions';

  Future<void> saveUserProgress(UserProgress progress) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userProgressKey, jsonEncode(progress.toJson()));
  }

  Future<UserProgress> getUserProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_userProgressKey);
    if (jsonStr == null) {
      return const UserProgress();
    }
    return UserProgress.fromJson(jsonDecode(jsonStr) as Map<String, dynamic>);
  }

  Future<void> saveBadges(List<Badge> badges) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = badges.map((b) => b.toJson()).toList();
    await prefs.setString(_badgesKey, jsonEncode(jsonList));
  }

  Future<List<Badge>> getBadges() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_badgesKey);
    if (jsonStr == null) {
      return [];
    }
    final jsonList = jsonDecode(jsonStr) as List;
    return jsonList.map((json) => Badge.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<void> saveMissions(List<Mission> missions) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = missions.map((m) => m.toJson()).toList();
    await prefs.setString(_missionsKey, jsonEncode(jsonList));
  }

  Future<List<Mission>> getMissions() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_missionsKey);
    if (jsonStr == null) {
      return [];
    }
    final jsonList = jsonDecode(jsonStr) as List;
    return jsonList.map((json) => Mission.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
