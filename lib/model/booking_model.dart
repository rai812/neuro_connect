class BookingModel {
  final String id;
  final String patientId;
  final String appointmentDate;
  final String appointmentTime;
  final String appointmentStatus;
  final String paymentStatus;
  final String doctorId;
  final String prescriptionId;
  // Add a timestamp field
  final DateTime timestamp;
  final String tokenNumber;
  final String remark;

  BookingModel({
    required this.id,
    required this.patientId,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.appointmentStatus,
    required this.paymentStatus,
    required this.doctorId,
    required this.prescriptionId,
    required this.timestamp,
    required this.tokenNumber,
    required this.remark,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patientId': patientId,
      'appointmentDate': appointmentDate,
      'appointmentTime': appointmentTime,
      'appointmentStatus': appointmentStatus,
      'paymentStatus': paymentStatus,
      'doctorId': doctorId,
      'prescriptionId': prescriptionId,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'tokenNumber': tokenNumber,
      'remark': remark,
    };
  }

  factory BookingModel.fromMap(Map<String, dynamic> map) {
    return BookingModel(
      id: map['id'],
      patientId: map['patientId'],
      appointmentDate: map['appointmentDate'],
      appointmentTime: map['appointmentTime'],
      appointmentStatus: map['appointmentStatus'],
      paymentStatus: map['paymentStatus'],
      doctorId: map['doctorId'],
      prescriptionId: map['prescriptionId'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
      tokenNumber: map['tokenNumber'],
      remark: map['remark'] ?? '',
    );
  }
}

class HelpModel {
  final String id;
  final String patientId;
  final String title;
  final String description;
  final DateTime timestamp;
  final DateTime closingTimestamp;
  final String status;

  HelpModel({
    required this.id,
    required this.patientId,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.closingTimestamp,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patientId': patientId,
      'title': title,
      'description': description,
      'status': status,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'closingTimestamp': closingTimestamp.millisecondsSinceEpoch,
    };
  }

  factory HelpModel.fromMap(Map<String, dynamic> map) {
    return HelpModel(
      id: map['id'],
      patientId: map['patientId'],
      title: map['title'],
      description: map['description'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
      closingTimestamp: DateTime.fromMillisecondsSinceEpoch(map['closingTimestamp']),
      status: map['status'],
    );
  }
}

// refferal model for refferal request and its status
class ReferralModel {
  final String id;
  final String referrerId;
  final String patientMobileId;
  final String patientName;
  final String status;
  final DateTime timestamp;

  ReferralModel({
    required this.id,
    required this.referrerId,
    required this.patientMobileId,
    required this.patientName,
    required this.status,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'referrerId': referrerId,
      'patientMobileId': patientMobileId,
      'patientName': patientName,
      'status': status,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  factory ReferralModel.fromMap(Map<String, dynamic> map) {
    return ReferralModel(
      id: map['id'],
      referrerId: map['referrerId'],
      patientMobileId: map['patientMobileId'],
      patientName: map['patientName'],
      status: map['status'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
    );
  }
}