// booking_model.dart
class DiagnosisModel {
  final String id;
  final String name;
  final String description;

  DiagnosisModel({
    required this.id,
    required this.name,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }

  factory DiagnosisModel.fromMap(Map<String, dynamic> map) {
    return DiagnosisModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
    );
  }
}
