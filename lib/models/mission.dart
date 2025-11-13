/// Represents a mission or achievement challenge
class Mission {
  final String id;
  final String title;
  final String description;
  final MissionType type;
  final int targetValue;
  final int currentProgress;
  final int rewardPoints;
  final bool isCompleted;
  final DateTime? completedDate;

  const Mission({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.targetValue,
    this.currentProgress = 0,
    required this.rewardPoints,
    this.isCompleted = false,
    this.completedDate,
  });

  double get progress => currentProgress / targetValue;

  Mission copyWith({
    String? id,
    String? title,
    String? description,
    MissionType? type,
    int? targetValue,
    int? currentProgress,
    int? rewardPoints,
    bool? isCompleted,
    DateTime? completedDate,
  }) {
    return Mission(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      targetValue: targetValue ?? this.targetValue,
      currentProgress: currentProgress ?? this.currentProgress,
      rewardPoints: rewardPoints ?? this.rewardPoints,
      isCompleted: isCompleted ?? this.isCompleted,
      completedDate: completedDate ?? this.completedDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.toString(),
      'targetValue': targetValue,
      'currentProgress': currentProgress,
      'rewardPoints': rewardPoints,
      'isCompleted': isCompleted,
      'completedDate': completedDate?.toIso8601String(),
    };
  }

  factory Mission.fromJson(Map<String, dynamic> json) {
    return Mission(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: MissionType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => MissionType.daily,
      ),
      targetValue: json['targetValue'] as int,
      currentProgress: json['currentProgress'] as int? ?? 0,
      rewardPoints: json['rewardPoints'] as int,
      isCompleted: json['isCompleted'] as bool? ?? false,
      completedDate: json['completedDate'] != null 
          ? DateTime.parse(json['completedDate'] as String) 
          : null,
    );
  }
}

enum MissionType {
  daily,
  weekly,
  special,
  landmark,
}
