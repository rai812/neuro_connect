// booking_model.dart
// class BookingModel {
//   final String id;
//   final String userId;
//   final String appointmentDate;
//   final String appointmentTime;
//   final String appointmentStatus;
//   final String paymentStatus;
//   final String doctorId;
//   final String previousVisit;
//   final String prescriptionId;

//   BookingModel({
//     required this.id,
//     required this.userId,
//     required this.appointmentDate,
//     required this.appointmentTime,
//     required this.appointmentStatus,
//     required this.paymentStatus,
//     required this.doctorId,
//     required this.previousVisit,
//     required this.prescriptionId,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'userId': userId,
//       'appointmentDate': appointmentDate,
//       'appointmentTime': appointmentTime,
//       'appointmentStatus': appointmentStatus,
//       'paymentStatus': paymentStatus,
//       'doctorId': doctorId,
//       'previousVisit': previousVisit,
//       'prescriptionId': prescriptionId,
//     };
//   }

//   factory BookingModel.fromMap(Map<String, dynamic> map) {
//     return BookingModel(
//       id: map['id'],
//       userId: map['userId'],
//       appointmentDate: map['appointmentDate'],
//       appointmentTime: map['appointmentTime'],
//       appointmentStatus: map['appointmentStatus'],
//       paymentStatus: map['paymentStatus'],
//       doctorId: map['doctorId'],
//       previousVisit: map['previousVisit'],
//       prescriptionId: map['prescriptionId'],
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';

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
    );
  }
}
