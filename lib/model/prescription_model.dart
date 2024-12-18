// booking_model.dart
class PrescriptionModel {
  String id;
  // final List<Map<String, String>> medicineList;
  List<String> diagnosisList;
  String remarks;
  String fileId;
  String reportFileId;

  PrescriptionModel({
    required this.id,
    required this.fileId,
    required this.diagnosisList,
    required this.remarks,
    required this.reportFileId,
  });

 Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fileId': fileId,
      'diagnosisList': diagnosisList,
      'remarks': remarks,
      'reportFileId': reportFileId,
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
      // if not present, then set to empty string
      reportFileId: map['reportFileId'] ?? '',

    );
  }
}
