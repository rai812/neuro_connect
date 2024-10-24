// class UserModel {
//   String name;
//   String email;
//   String bio;
//   String phoneNumber;
//   String role;
//   String uid;
//   String gender;
//   String specialization;
//   String password;

//   UserModel({
//     required this.name,
//     required this.email,
//     required this.bio,
//     required this.phoneNumber,
//     required this.role,
//     required this.uid,
//     required this.gender,
//     required this.specialization,
//     required this.password,
//   });

//   // from map
//   factory UserModel.fromMap(Map<String, dynamic> map) {
//     return UserModel(
//       name: map['name'] ?? '',
//       email: map['email'] ?? '',
//       bio: map['bio'] ?? '',
//       uid: map['uid'] ?? '',
//       role: map['role'] ?? '',
//       phoneNumber: map['phoneNumber'] ?? '',
//       gender: map['gender'] ?? 'Male',
//       specialization: map['specialization'] ?? '',
//       password: map['password'] ?? '',
//     );
//   }

//   // to map
//   Map<String, dynamic> toMap() {
//     return {
//       "name": name,
//       "email": email,
//       "uid": uid,
//       "bio": bio,
//       "role":role,
//       "phoneNumber": phoneNumber,
//       "gender": gender,
//       "specialization": specialization,
//       "password": password,
//     };
//   }
// }

class UserModel {
  String phoneNumber;
  String role;
  String uid;
  String password;
  bool  resetPassword;

  UserModel({
    required this.phoneNumber,
    required this.role,
    required this.uid,
    required this.password,
    required this.resetPassword,
  });

  // from map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      role: map['role'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      password: map['password'] ?? '',
      resetPassword: map['resetPassword'] ?? false,
    );
  }

  // to map
  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "role":role,
      "phoneNumber": phoneNumber,
      "password": password,
      "resetPassword": resetPassword,
    };
  }
}

class PatientInfoModel {
  String name;
  String email;
  String gender;
  String userId;
  String id;
  DateTime dob;
  PatientInfoModel({
    required this.name,
    required this.email,
    required this.gender,
    required this.userId,
    required this.id,
    required this.dob,
     });

  // from map
  factory PatientInfoModel.fromMap(Map<String, dynamic> map) {
    return PatientInfoModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      userId: map['userId'] ?? '',
      gender: map['gender'] ?? 'Male',
      id: map['id'] ?? '',
      dob: DateTime.fromMillisecondsSinceEpoch(map['dob']),
    );
  }

  // to map
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "email": email,
      "userId": userId,
      "gender": gender,
      "id": id,
      "dob": dob.millisecondsSinceEpoch,
    };
  }

  // implement toString
  @override
  String toString() {
    return name;
  }
}

class DoctorInfoModel {
  String name;
  String email;
  String bio;
  String userId;
  String gender;
  String specialization;
  String experience;
  String profilePicId;
  String clinicId;
  String currentStatus;
  String id;

  DoctorInfoModel({
    required this.name,
    required this.email,
    required this.bio,
    required this.userId,
    required this.gender,
    required this.specialization,
    required this.experience,
    required this.profilePicId,
    required this.id,
    required this.clinicId,
    required this.currentStatus
  });

  // from map
  factory DoctorInfoModel.fromMap(Map<String, dynamic> map) {
    return DoctorInfoModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      bio: map['bio'] ?? '',
      userId: map['userId'] ?? '',
      id: map['id'] ?? '',
      experience: map['experience'] ?? '',
      gender: map['gender'] ?? 'Male',
      specialization: map['specialization'] ?? '',
      profilePicId: map['profilePicId'] ?? '',
      clinicId: map['clinicId'] ?? '',
      currentStatus: map['currentStatus'] ?? '',
    );
  }

  // to map
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "email": email,
      "profilePicId": profilePicId,
      "bio": bio,
      "userId":userId,
      "id": id,
      "gender": gender,
      "specialization": specialization,
      "experience": experience,
      "clinicId": clinicId,
      "currentStatus": currentStatus,
    };
  }

  // implement toString
  @override
  String toString() {
    return 'Dr. $name';
  }
}

class ClinicInfoModel {
  String name;
  String address;
  String id;

  ClinicInfoModel({
    required this.name,
    required this.address,
    required this.id,
     });

  // from map
  factory ClinicInfoModel.fromMap(Map<String, dynamic> map) {
    return ClinicInfoModel(
      name: map['name'] ?? '',
      address: map['address'] ?? '',
      id: map['id'] ?? '',
    );
  }

  // to map
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "address": address,
      "id": id,
    };
  }
}