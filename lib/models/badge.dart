/// Represents a digital badge earned by the user
class Badge {
  final String id;
  final String name;
  final String description;
  final String iconPath;
  final BadgeType type;
  final int requiredPoints;
  final DateTime? earnedDate;

  const Badge({
    required this.id,
    required this.name,
    required this.description,
    required this.iconPath,
    required this.type,
    required this.requiredPoints,
    this.earnedDate,
  });

  bool get isEarned => earnedDate != null;

  Badge copyWith({
    String? id,
    String? name,
    String? description,
    String? iconPath,
    BadgeType? type,
    int? requiredPoints,
    DateTime? earnedDate,
  }) {
    return Badge(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconPath: iconPath ?? this.iconPath,
      type: type ?? this.type,
      requiredPoints: requiredPoints ?? this.requiredPoints,
      earnedDate: earnedDate ?? this.earnedDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'iconPath': iconPath,
      'type': type.toString(),
      'requiredPoints': requiredPoints,
      'earnedDate': earnedDate?.toIso8601String(),
    };
  }

  factory Badge.fromJson(Map<String, dynamic> json) {
    return Badge(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      iconPath: json['iconPath'] as String,
      type: BadgeType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => BadgeType.achievement,
      ),
      requiredPoints: json['requiredPoints'] as int,
      earnedDate: json['earnedDate'] != null 
          ? DateTime.parse(json['earnedDate'] as String) 
          : null,
    );
  }
}

enum BadgeType {
  achievement,
  streak,
  landmark,
  master,
}
