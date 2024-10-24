// booking_model.dart
class MedicineModel {
  final String id;
  final String name;
  final String formula;
  final String description;

  MedicineModel({
    required this.id,
    required this.name,
    required this.formula,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'formula': formula,
      'description': description,
    };
  }

  factory MedicineModel.fromMap(Map<String, dynamic> map) {
    return MedicineModel(
      id: map['id'],
      name: map['name'],
      formula: map['formula'],
      description: map['description'],
    );
  }
}
