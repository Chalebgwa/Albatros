/// Represents a landmark that can be recognized in AR
class Landmark {
  final String id;
  final String name;
  final String description;
  final String imagePath;
  final List<String> recognitionKeywords;
  final double latitude;
  final double longitude;

  const Landmark({
    required this.id,
    required this.name,
    required this.description,
    required this.imagePath,
    required this.recognitionKeywords,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imagePath': imagePath,
      'recognitionKeywords': recognitionKeywords,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory Landmark.fromJson(Map<String, dynamic> json) {
    return Landmark(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imagePath: json['imagePath'] as String,
      recognitionKeywords: List<String>.from(json['recognitionKeywords'] as List),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }
}
