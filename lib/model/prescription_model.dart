// booking_model.dart
class PrescriptionModel {
  String id;
  // final List<Map<String, String>> medicineList;
  List<String> diagnosisList;
  String remarks;
  String fileId;

  PrescriptionModel({
    required this.id,
    required this.fileId,
    required this.diagnosisList,
    required this.remarks,
  });

 Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fileId': fileId,
      'diagnosisList': diagnosisList,
      'remarks': remarks,
    };
  }

  factory PrescriptionModel.fromMap(Map<String, dynamic> map) {
    List<String> dList  = [];
    map['diagnosisList'].forEach((element) {
      dList.add(element);
    });
    return PrescriptionModel(
      id: map['id'],
      fileId: map['fileId'],
      diagnosisList: dList,
      remarks: map['remarks'],
    );
  }
}
