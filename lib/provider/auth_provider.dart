
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digi_diagnos/model/diagnosis_model.dart';
import 'package:digi_diagnos/model/medicine_model.dart';
import 'package:digi_diagnos/model/prescription_model.dart';
// import 'package:digi_diagnos/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../model/booking_model.dart';
import '../model/labModal.dart';
import '../model/testModal.dart';
import '../model/user_model.dart';
import '../screens/otp.dart';
import '../screens/user_info.dart';
// import '../screens/home.dart';
import '../screens/nav_route.dart';
import '../utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class BookingDetails {
  final BookingModel bookingModel;
  final PatientInfoModel patient;
  final DoctorInfoModel doctor;
  final PrescriptionModel prescription;
  BookingDetails({
    required this.bookingModel,
    required this.patient,
    required this.doctor,
    required this.prescription,
  });
}

class AuthProvider extends ChangeNotifier {
  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _uid;
  String get uid => _uid!;
  String? _role;
  String get role => _role!;
  UserModel? _userModel;
  UserModel get userModel => _userModel!;
  List<PatientInfoModel> _patientsInfoModel = [];
  List<PatientInfoModel> get patientsInfoModel => _patientsInfoModel;
  int _activePatientIndex = 0;
  int get activePatientIndex => _activePatientIndex;
  List<DoctorInfoModel> _doctorsInfoModel = [];
  List<DoctorInfoModel> get doctorsInfoModel => _doctorsInfoModel;
  int _activeDoctorIndex = 0;
  int get activeDoctorIndex => _activeDoctorIndex;
  List<ClinicInfoModel> _clinicsInfoModel = [];
  List<ClinicInfoModel> get clinicsInfoModel => _clinicsInfoModel;    
  List<BookingModel> _bookings = [];
  List<TestModel> _tests = [];
  List<LabModel> _labs = [];
  List<TestModel> get tests => _tests;
  List<LabModel> get labs => _labs;
  List<BookingModel> get bookings => _bookings;
  List<MedicineModel> _medicines = [];
  List<MedicineModel> get medicines => _medicines;

  List<DiagnosisModel> _diagnosis = [];
  List<DiagnosisModel> get diagnosis => _diagnosis;

  List<DoctorInfoModel> _doctors = [];
  List<DoctorInfoModel> get doctors => _doctors;

  List<PatientInfoModel> _patients = [];
  List<PatientInfoModel> get patients => _patients;

//   final String whatsAppAccessToken ='EAARjS6nj7jYBOZCzfebysonFoCnjELfIKAnOyH0mIiqLDdYDM260PJbVEkrnatxpOYbD7G0AUuYZBn77rvFiSC2ekIZCRosZA5nEdEG48ELss2nRPaT6pK2FzG9b9dDed9JAB3aXRKhWBXcLlrZBqHeNVZBwCEHqrMaHoZBDke55m5B1CCWZCmb8M6Qwe8ODfWK8QtRAJbyCqiM1VBAVo1MZD';
//   final String fromNumberId = '1082772452xxxxx';

//  final whatsapp = WhatsApp(accessToken, fromNumberId);

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  AuthProvider() {
    checkSign();
  }


  void checkSign() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _isSignedIn = s.getBool("is_signedin") ?? false;
    notifyListeners();
  }

  Future setSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.setBool("is_signedin", true);
    _isSignedIn = true;
    notifyListeners();
  }

  // sign in with phone and password 
  // void signInWithPhoneAndPassword(BuildContext context, String phoneNumber, String password) async {
  //   try {
      
  //     // search in firebase with same mobile number and if no user found then create new user
  //     await _firebaseFirestore.collection('users').where('phoneNumber', isEqualTo: phoneNumber).get().then((value) async {
  //       if (value.docs.isEmpty) {
  //         // user is not there so create new user
  //         await _firebaseFirestore.collection('users').doc(phoneNumber).set({
  //           'phoneNumber': phoneNumber,
  //           'password': password,
  //           'name': '',
  //           'email': '',
  //           'bio': '',
  //           'role': 'Patient',
  //           'gender': '',
  //           'specialization': '',
  //           'uid': phoneNumber,
  //         }).then((onValue)  async {

  //             QuerySnapshot snapshot =
  //             await _firebaseFirestore.collection("users").where('phoneNumber', isEqualTo: phoneNumber).get();
  //             if (snapshot.docs.isNotEmpty) {
  //               _uid = snapshot.docs.first.id;
  //               await setSignIn();
  //               await getDataFromFirestore();
  //               await saveUserDataToSP();
  //               if (_userModel!.gender == "" || _userModel!.role == "")
  //               {
  //                   // new user 
  //                   Navigator.pushAndRemoveUntil(
  //                       context,
  //                       MaterialPageRoute(
  //                           builder: (context) => const UserInfromationScreen()),
  //                           (route) => false); 
  //               }
  //               else {
  //                 Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
  //                               builder: (context) =>  const NavBar(),
  //                             ),
  //                             (route) => false);
  //               }

  //             } 

  //         });
  //       } else {
  //           // check if password is correct
  //           var data = value.docs.first;
  //           if (data['password'] != password) {
  //             showSnackBar(context, "Password is incorrect");
  //           } else {
  //             _uid = data['uid'];
  //             await setSignIn();
  //             await getDataFromFirestore();
  //             await saveUserDataToSP();
  //             if ( _userModel!.gender == ""|| _userModel!.role == "")
  //             {
  //                 // new user 
  //                 Navigator.pushAndRemoveUntil(
  //                     context,
  //                     MaterialPageRoute(
  //                         builder: (context) => const UserInfromationScreen()),
  //                         (route) => false); 
  //             }
  //             else {
  //               Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
  //                             builder: (context) =>  const NavBar(),
  //                           ),
  //                           (route) => false);
  //             }
              
  //           }
  //       }
  //     });
  //   } on FirebaseAuthException catch (e) {
  //     showSnackBar(context, e.message.toString());
  //   }
  // }

  void signInWithPhoneAndPassword(BuildContext context, String phoneNumber, String password) async {
    try {
      
      // search in firebase with same mobile number and if no user found then create new user
      await _firebaseFirestore.collection('users').where('phoneNumber', isEqualTo: phoneNumber).get().then((value) async {
        if (value.docs.isEmpty) {
          // user is not there so create new user
          await _firebaseFirestore.collection('users').doc(phoneNumber).set({
            'phoneNumber': phoneNumber,
            'password': password,
            'role': 'Patient',
            'uid': phoneNumber,
            'resetPassword': false,
          }).then((onValue)  async {

              QuerySnapshot snapshot =
              await _firebaseFirestore.collection("users").where('phoneNumber', isEqualTo: phoneNumber).get();
              if (snapshot.docs.isNotEmpty) {
                _uid = snapshot.docs.first.id;
                _role = snapshot.docs.first['role'];
                await setSignIn();
                await getDataFromFirestore();
                await saveUserDataToSP();
                if (_role == 'Patient' && _patientsInfoModel!.isEmpty)
                {
                    // new user 
                    // add patinet info
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddPatientScreen()),
                            (route) => false); 
                }
                else if (_role == 'Doctor' && _doctorsInfoModel!.isEmpty)
                {
                    // new user 
                    // add doctor info
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ADDDoctorScreen()),
                            (route) => false); 
                }
                else {
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                                builder: (context) =>   NavBar(role: _role!,),
                              ),
                              (route) => false);
                }

              } 

          });
        } else {
            // check if password is correct
            var data = value.docs.first;
            var storedPassword = data['password'];
            // check if reset password is true
            if (data['resetPassword']) {
              // accept the given password and update the reset password to false
              await _firebaseFirestore.collection('users').doc(data.id).update({
                'password': password,
                'resetPassword': false,
              });
              storedPassword = password;
            } 
            
            if (storedPassword != password) {
              showSnackBar(context, "Password is incorrect");
            } else {
              _uid = data['uid'];
              _role = data['role'];
              await setSignIn();
              await getDataFromFirestore();
              await saveUserDataToSP();
                if (_role == 'Patient' && _patientsInfoModel!.isEmpty)
                {
                    // new user 
                    // add patinet info
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddPatientScreen()),
                            (route) => false); 
                }
                else if (_role == 'Doctor' && _doctorsInfoModel!.isEmpty)
                {
                    // new user 
                    // add doctor info
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ADDDoctorScreen()),
                            (route) => false); 
                }
                else {
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                                builder: (context) =>  NavBar(role: _role!,),
                              ),
                              (route) => false);
                }

              
            }
        }
      });
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
    }
  }

  // signin
  void signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted:
              (PhoneAuthCredential phoneAuthCredential) async {
            await _firebaseAuth.signInWithCredential(phoneAuthCredential);
          },
          verificationFailed: (error) {
            throw Exception(error.message);
          },
          codeSent: (verificationId, forceResendingToken) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtpScreen(verificationId: verificationId),
              ),
            );
          },
          codeAutoRetrievalTimeout: (verificationId) {});
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
    }
  }

  // verify otp
  void verifyOtp({
    required BuildContext context,
    required String verificationId,
    required String userOtp,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      PhoneAuthCredential creds = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOtp);

      User? user = (await _firebaseAuth.signInWithCredential(creds)).user;

      if (user != null) {
        // carry our logic
        _uid = user.uid;
        onSuccess();
      }
      _isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
    }
  }


  // DATABASE OPERTAIONS
  Future<bool> checkExistingUser() async {
    DocumentSnapshot snapshot =
    await _firebaseFirestore.collection("users").doc(_uid).get();
    if (snapshot.exists) {
      print("USER EXISTS");
      return true;
    } else {
      print("NEW USER");
      return false;
    }
  }

  void savePatientDataToFirebaseAdmin({
    required BuildContext context,
    required PatientInfoModel userModel,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      
      // uploading to database
      await _firebaseFirestore
          .collection("patients")
          .doc(userModel.id)
          .set(userModel.toMap())
          .then((value) {
        onSuccess();
        
      });
      await  getPatientsDataFromFirestore();
      _isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
    }
  }


  void savePatientDataToFirebase({
    required BuildContext context,
    required PatientInfoModel userModel,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      
      // uploading to database
      await _firebaseFirestore
          .collection("patients")
          .doc(userModel.id)
          .set(userModel.toMap())
          .then((value) {
        onSuccess();
        _isLoading = false;
      final updatedPatinetIndex =
      _patientsInfoModel.indexWhere((value) => value.id == userModel.id);
      if (updatedPatinetIndex != -1) {
        _patientsInfoModel[updatedPatinetIndex] = userModel;
      }
      else {
        _patientsInfoModel.add(userModel);
      }
        notifyListeners();
      });
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> getNewPatientId() async {
    return _firebaseFirestore.collection("patients").doc().id;
  }

  Future<String> getNewDoctorId() async {
    return _firebaseFirestore.collection("doctors").doc().id;
  }

  void saveDoctorDataToFirebaseAdmin({
    required BuildContext context,
    required DoctorInfoModel userModel,
    required File profilePic,
    required Function onSuccess,
    bool upload = true,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      
      if (upload) {
        // uploading profile pic
        await storeFileToStorage("profilePic/${userModel.id}", profilePic).then((value) {
          userModel.profilePicId = value;
        });
      }

      // uploading to database
      await _firebaseFirestore
          .collection("doctors")
          .doc(userModel.id)
          .set(userModel.toMap())
          .then((value) {
        onSuccess();
        _isLoading = false;
      });
      await  getDoctorsDataFromFirestore();
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  void saveDoctorDataToFirebase({
    required BuildContext context,
    required DoctorInfoModel userModel,
    required File profilePic,
    required Function onSuccess,
    bool upload = true,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      
      if (upload) {
        // uploading profile pic
        await storeFileToStorage("profilePic/${userModel.id}", profilePic).then((value) {
          userModel.profilePicId = value;
        });
      }

      // uploading to database
      await _firebaseFirestore
          .collection("doctors")
          .doc(userModel.id)
          .set(userModel.toMap())
          .then((value) {
        onSuccess();
        _isLoading = false;
        final updatedDoctorIndex =
        _doctorsInfoModel.indexWhere((value) => value.id == userModel.id);
        if (updatedDoctorIndex != -1) {
          _doctorsInfoModel[updatedDoctorIndex] = userModel;
        }
        else {
          _doctorsInfoModel.add(userModel);
        }
        getDataFromFirestore();
        notifyListeners();
      });
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  void setActiveDoctor(id) {
    // search in doctor_info_model and get the index of the doctor
    _activeDoctorIndex = _doctorsInfoModel.indexWhere((element) => element.id == id);
  }

  void setActivePatient(id) {
    // search in doctor_info_model and get the index of the doctor
    _activePatientIndex = _patientsInfoModel.indexWhere((element) => element.id == id);
  }

  Future saveUserDataToFirebase({
    required BuildContext context,
    required UserModel userModel,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      _userModel = userModel;

      // uploading to database
      await _firebaseFirestore
          .collection("users")
          .doc(userModel.uid)
          .set(userModel.toMap())
          .then((value) {
        _isLoading = false;
        notifyListeners();
      });
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> storeFileToStorage(String ref, File file) async {
    UploadTask uploadTask = _firebaseStorage.ref().child(ref).putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> deletePatient(String patientId) async {
    try {
      await _firebaseFirestore.collection("patients").doc(patientId).delete();

      _patientsInfoModel.removeWhere((patient) => patient.id == patientId);
      notifyListeners();
    } catch (e) {
      print("Error deleting Patient: $e");
    }
  }

    Future<void> deleteDoctor(String doctorId) async {
    try {
      await _firebaseFirestore.collection("doctors").doc(doctorId).delete();

      _bookings.removeWhere((doctor) => doctor.id == doctorId);
      notifyListeners();
    } catch (e) {
      print("Error deleting doctor: $e");
    }
  }

  Future getDataFromFirestore() async {
    print("GETTING DATA FROM FIRESTORE");
    await _firebaseFirestore
        .collection("users")
        .doc(_uid)
        .get()
        .then((DocumentSnapshot snapshot) {
      _userModel = UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
      _uid = userModel.uid;
    });

    await _firebaseFirestore
        .collection("patients")
        .where('userId', isEqualTo: _uid)
        .get()
        .then((QuerySnapshot snapshot) {
            _patientsInfoModel = snapshot.docs
                .map((doc) => PatientInfoModel.fromMap(doc.data() as Map<String, dynamic>))
                .toList();
        });

    await _firebaseFirestore
        .collection("doctors")
        .where('userId', isEqualTo: _uid)
        .get()
        .then((QuerySnapshot snapshot) {
          print(snapshot.docs);
            _doctorsInfoModel = snapshot.docs
                .map((doc) => DoctorInfoModel.fromMap(doc.data() as Map<String, dynamic>))
                .toList();
            print(_doctorsInfoModel);
        });
    
    await _firebaseFirestore
      .collection("clinics")
      .get()
      .then((QuerySnapshot snapshot) {
          _clinicsInfoModel = snapshot.docs
              .map((doc) => ClinicInfoModel.fromMap(doc.data() as Map<String, dynamic>))
              .toList();
    });

    await getDoctorsDataFromFirestore();

    if (_role == 'Doctor' || _role == 'admin') {
      await getPatientsDataFromFirestore();
    }

  }

  Future<List<DoctorInfoModel>> getDoctors() async {
    return _doctors.where((test) => test.userId == _uid).toList();
  }
  
  Future<List<DoctorInfoModel>> getAllDoctors() async {
    return _doctors;
  }

  // seach the patient list with the given name include partial match also
  Future<List<DoctorInfoModel>> getDoctorByName(String name) async {
    if (name == "") {
      return _doctors;
    }
    return _doctors.where((element) => element.name.toLowerCase().contains(name.toLowerCase())).toList();
  }
  

  Future<List<PatientInfoModel>> getAllPatients() async {
    return _patients;
  }

  // search the patient list with the given phone number
  Future<List<PatientInfoModel>> getPatientByMobile(String phoneNumber) async {
    if (phoneNumber == "") {
      return _patients;
    }
    return _patients.where((element) => element.userId == phoneNumber).toList();
  }

  // seach the patient list with the given name include partial match also
  Future<List<PatientInfoModel>> getPatientByName(String name) async {
      if (name == "") {
      return _patients;
    }
    return _patients.where((element) => element.name.toLowerCase().contains(name.toLowerCase())).toList();
  }
  
  // search the patient where the given diagnosis is present
  Future<List<PatientInfoModel>> getPatientByDiagnosys(String diagnosis) async {
    if (diagnosis == "") {
      return _patients;
    }
    diagnosis = diagnosis.toLowerCase();
    // first seach all bookings in firebase which has status as completed and prescriptionId is not empty
    // then get the prescription details from the prescriptionId
    // then get the diagnosis list from the prescription details
    // then search the patient list with the given diagnosis
    List<PatientInfoModel>  candicates = [];
    await _firebaseFirestore.collection("bookings").where('appointmentStatus', isEqualTo: 'completed').where('prescriptionId', isNotEqualTo: "").get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((element) async {
        var booking = BookingModel.fromMap(element.data() as Map<String, dynamic>);
        var prescription = await getPrescriptionDetails(booking.prescriptionId);
        if (prescription.diagnosisList.contains(diagnosis)) {
          var patient = await getPatientDetails(booking.patientId);
          candicates.add(patient);
        }
      });
    });

    return candicates;
  }

  Future<List<PatientInfoModel>> getPatients() async {
    return _patientsInfoModel;
  }


  Future<List<DoctorInfoModel>> getDoctorsDataFromFirestore() async {
    await _firebaseFirestore
        .collection("doctors")
        .get()
        .then((QuerySnapshot snapshot) {
          
      _doctors = snapshot.docs
          .map((doc) => DoctorInfoModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      print("Num Doctors ${_doctors.length}");
    });

    return _doctors;
  }

  Future<List<PatientInfoModel>> getPatientsDataFromFirestore() async {
    await _firebaseFirestore
        .collection("patients")
        .get()
        .then((QuerySnapshot snapshot) {
          
      _patients = snapshot.docs
          .map((doc) => PatientInfoModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      // print("Num Doctors ${_doctors.length}");
    });

    return _patients;
  }

  // STORING DATA LOCALLY
  Future saveUserDataToSP() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    await s.setString("user_model", jsonEncode(userModel.toMap()));
  }


  Future getDataFromSP() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    String data = s.getString("user_model") ?? '';
    _userModel = UserModel.fromMap(jsonDecode(data));
    _uid = _userModel!.uid;
    _role = _userModel!.role;
    notifyListeners();
  }

  Future userSignOut() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    await _firebaseAuth.signOut();
    _isSignedIn = false;
    notifyListeners();
    s.clear();
  }

  Future<String> getNewPrescriptionId() async {
    return _firebaseFirestore.collection("prescriptions").doc().id;
  }

void savePrescriptionDataToFirebase({
    required BuildContext context,
    required PrescriptionModel prescriptionModel,
    required File prescriptionFile,
    required Function onSuccess,
    required BookingDetails bookingDetails,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      
        // uploading profile pic
      await storeFileToStorage("prescriptions/${bookingDetails.patient.userId}/${bookingDetails.patient.id}/${DateTime.now()}", prescriptionFile).then((value) {
        prescriptionModel.fileId = value;
      });
    
      // uploading to database
      await _firebaseFirestore
          .collection("prescriptions")
          .doc(prescriptionModel.id)
          .set(prescriptionModel.toMap())
          .then((value) {
        // onSuccess();
          _isLoading = false;
          BookingModel bookingModel = BookingModel(id: bookingDetails.bookingModel.id, 
          patientId: bookingDetails.bookingModel.patientId, 
          appointmentDate: bookingDetails.bookingModel.appointmentDate, 
          appointmentTime: bookingDetails.bookingModel.appointmentTime, 
          appointmentStatus: bookingDetails.bookingModel.appointmentStatus, 
          paymentStatus: bookingDetails.bookingModel.paymentStatus, 
          doctorId: bookingDetails.bookingModel.doctorId, 
          prescriptionId: prescriptionModel.id,
          timestamp: bookingDetails.bookingModel.timestamp);
          // this operation is done by admin so we don't need to update the booking array 
          saveBookingDataToFirebase(context: context, booking: bookingModel, onSuccess: onSuccess);
          notifyListeners();
      });
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> isBookingAlreadyExist(String patientId, String doctorId, String appointmentStatus) async {
    appointmentStatus = appointmentStatus.toLowerCase();
    QuerySnapshot querySnapshot = await _firebaseFirestore
        .collection("bookings")
        .where('patientId', isEqualTo: patientId)
        .where('doctorId', isEqualTo: doctorId)
        .where('appointmentStatus', isEqualTo: appointmentStatus)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  Future<String> getNewBookingId() async {
    return _firebaseFirestore.collection("bookings").doc().id;
  }

  void saveBookingDataToFirebase({
    required BuildContext context,
    required BookingModel booking,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      
      // uploading to database
      await _firebaseFirestore
          .collection("bookings")
          .doc(booking.id)
          .set(booking.toMap())
          .then((value) {
        onSuccess();
        _isLoading = false;
      final updatedBookingIndex =
      _bookings.indexWhere((value) => value.id == booking.id);
      if (updatedBookingIndex != -1) {
        _bookings[updatedBookingIndex] = booking;
      }
      else {
        _bookings.add(booking);
      }
        notifyListeners();
      });
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
    }
  }


  // Future bookAppointment({
  //   required String appointmentDate,
  //   required String appointmentTime,
  //   required String appointmentStatus,
  //   required String paymentStatus,
  //   required String doctorId,
  //   required String previousVisitId,
  // }) async {
  //   try {
  //     String bookingId = _firebaseFirestore.collection("bookings").doc().id;

  //     BookingModel booking = BookingModel(
  //       id: bookingId,
  //       userId: _uid!,
  //       appointmentDate: appointmentDate,
  //       appointmentTime: appointmentTime,
  //       appointmentStatus: appointmentStatus,
  //       paymentStatus: paymentStatus,
  //       doctorId: doctorId,
  //       previousVisit: previousVisitId,
  //       prescriptionId: "",
  //     );

  //     await _firebaseFirestore
  //         .collection("bookings")
  //         .doc(bookingId)
  //         .set(booking.toMap());

  //     _bookings.add(booking);
  //     triggerEmailToDoctor(doctorId);
  //     notifyListeners();
  //   } catch (e) {
  //     print("Error booking appointment: $e");
  //   }
  // }

  void triggerEmailToDoctor(doctorId) async {

    // given the doctor id loop in doctos list and get the email of the doctor
    var doctor = _doctorsInfoModel.firstWhere((element) => element.id == doctorId);
    var email = doctor.email;
    print(email);
    // send email to the doctor
  }

  Future<List<BookingModel>> getMyBookings({ patientId,  status, String date = ""}) async {
    try {

      if (date != "") {
        QuerySnapshot querySnapshot = await _firebaseFirestore
            .collection("bookings")
            .where('appointmentStatus', isEqualTo: status)
            .where('appointmentDate', isEqualTo: date)
            .where('patientId', isEqualTo: patientId)
            .get();

        List<BookingModel> bookings = querySnapshot.docs
            .map((doc) => BookingModel.fromMap(doc.data() as Map<String, dynamic>))
            .toList();

        return bookings;
      }
      else {
        QuerySnapshot querySnapshot = await _firebaseFirestore
            .collection("bookings")
            .where('appointmentStatus', isEqualTo: status)
            .where('patientId', isEqualTo: patientId)
            .get();

        List<BookingModel> bookings = querySnapshot.docs
            .map((doc) => BookingModel.fromMap(doc.data() as Map<String, dynamic>))
            .toList();

        return bookings;
      }
    } catch (e) {
      print("Error getting bookings: $e");
      throw e; // Re-throw the exception to propagate it to the caller
    }
  }

  Future<List<BookingDetails>> getMyBookingDetails(status, date) async {
    try {

      // force the status to be lower case 
      status = status.toLowerCase();
      // if status is all then get all the bookings
      // else pass the status to get the bookings
      List<BookingModel> bookings = await getMyBookings(patientId: _patientsInfoModel[activePatientIndex].id , status: status, date: date);
      List<BookingDetails> bookingDetails = [];

      for (BookingModel booking in bookings) {
        PatientInfoModel patient = PatientInfoModel.fromMap(_patientsInfoModel[activePatientIndex].toMap());
        DoctorInfoModel doctor = _doctors.firstWhere((element) => element.id == booking.doctorId);
        if (booking.prescriptionId != "") {
          PrescriptionModel prescription = await getPrescriptionDetails(booking.prescriptionId);
          bookingDetails.add(BookingDetails(
            bookingModel: booking,
            patient: patient,
            doctor: doctor,
            prescription: prescription,
          ));
        } else {
          bookingDetails.add(BookingDetails(
            bookingModel: booking,
            patient: patient,
            doctor: doctor,
            prescription: PrescriptionModel(
              id: "",
              fileId: "",
              diagnosisList: [],
              remarks: "",
            ),
          ));
        }

        // bookingDetails.add(BookingDetails(
        //   bookingModel: booking,
        //   patient: patient,
        //   doctor: doctor,
        // ));
      }

      return bookingDetails;

    } catch (e) {
      print("getMyBookingDetails: Error getting bookings: $e");
      throw e; // Re-throw the exception to propagate it to the caller
    }
  }


  Future<List<BookingModel>> getAllBookings({ status, String date = ""}) async {
    try {

      if (date != "") {
        QuerySnapshot querySnapshot = await _firebaseFirestore
            .collection("bookings")
            .where('appointmentStatus', isEqualTo: status)
            .where('appointmentDate', isEqualTo: date)
            .get();

        List<BookingModel> bookings = querySnapshot.docs
            .map((doc) => BookingModel.fromMap(doc.data() as Map<String, dynamic>))
            .toList();

        return bookings;
      }
      else {
        QuerySnapshot querySnapshot = await _firebaseFirestore
            .collection("bookings")
            .where('appointmentStatus', isEqualTo: status)
            .get();

        List<BookingModel> bookings = querySnapshot.docs
            .map((doc) => BookingModel.fromMap(doc.data() as Map<String, dynamic>))
            .toList();

        return bookings;
      }
    } catch (e) {
      print("Error getting bookings: $e");
      throw e; // Re-throw the exception to propagate it to the caller
    }
  }

  Future<List<BookingModel>> getAllBookingsInDateRange(DateTime startdate, DateTime endDate) async {

    try {
      
      int start = startdate.millisecondsSinceEpoch;
      int end = endDate.millisecondsSinceEpoch;

      QuerySnapshot querySnapshot = await _firebaseFirestore
          .collection("bookings")
          .where('timestamp', isGreaterThanOrEqualTo: start)
          .where('timestamp', isLessThanOrEqualTo: end)
          .get();

      List<BookingModel> bookings = querySnapshot.docs
          .map((doc) => BookingModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

        return bookings;
    } catch (e) {
      print("Error getting bookings: $e");
      throw e; // Re-throw the exception to propagate it to the caller
    }
    // return [];
  }

  Future<List<BookingDetails>> getBookingDetailsInDateRange(startDate, endDate) async {
    try {

      // if status is all then get all the bookings
      // else pass the status to get the bookings
      List<BookingModel> bookings = await getAllBookingsInDateRange(startDate, endDate);
      List<BookingDetails> bookingDetails = [];

      for (BookingModel booking in bookings) {
        PatientInfoModel patient = await getPatientDetails(booking.patientId);
        DoctorInfoModel doctor = _doctors.firstWhere((element) => element.id == booking.doctorId);
        if (booking.prescriptionId != "") {
          PrescriptionModel prescription = await getPrescriptionDetails(booking.prescriptionId);
          bookingDetails.add(BookingDetails(
            bookingModel: booking,
            patient: patient,
            doctor: doctor,
            prescription: prescription,
          ));
        } else {
          bookingDetails.add(BookingDetails(
            bookingModel: booking,
            patient: patient,
            doctor: doctor,
            prescription: PrescriptionModel(
              id: "",
              fileId: "",
              diagnosisList: [],
              remarks: "",
            ),
          ));
        }

        // bookingDetails.add(BookingDetails(
        //   bookingModel: booking,
        //   patient: patient,
        //   doctor: doctor,
        // ));
      }

      return bookingDetails;

    } catch (e) {
      print("Error getting bookings: $e");
      throw e; // Re-throw the exception to propagate it to the caller
    }
    // return [];
  }


  Future<List<BookingDetails>> getBookingDetails(status, date) async {
    try {

      // force the status to be lower case 
      status = status.toLowerCase();
      // if status is all then get all the bookings
      // else pass the status to get the bookings
      List<BookingModel> bookings = await getAllBookings(status: status, date: date);
      List<BookingDetails> bookingDetails = [];

      for (BookingModel booking in bookings) {
        PatientInfoModel patient = await getPatientDetails(booking.patientId);
        DoctorInfoModel doctor = _doctors.firstWhere((element) => element.id == booking.doctorId);
        if (booking.prescriptionId != "") {
          PrescriptionModel prescription = await getPrescriptionDetails(booking.prescriptionId);
          bookingDetails.add(BookingDetails(
            bookingModel: booking,
            patient: patient,
            doctor: doctor,
            prescription: prescription,
          ));
        } else {
          bookingDetails.add(BookingDetails(
            bookingModel: booking,
            patient: patient,
            doctor: doctor,
            prescription: PrescriptionModel(
              id: "",
              fileId: "",
              diagnosisList: [],
              remarks: "",
            ),
          ));
        }

        // bookingDetails.add(BookingDetails(
        //   bookingModel: booking,
        //   patient: patient,
        //   doctor: doctor,
        // ));
      }

      return bookingDetails;

    } catch (e) {
      print("Error getting bookings: $e");
      throw e; // Re-throw the exception to propagate it to the caller
    }
  }

  // Future<BookingDetails> getBookingDetail(bookingId) async {
  //   try {
  //     // get unique booking from id from firestore 
  //       var booking = await _firebaseFirestore
  //       .collection("bookings")
  //       .doc(bookingId)
  //       .get()
  //       .then((DocumentSnapshot snapshot) {
  //         BookingModel booking = BookingModel.fromMap(snapshot.data() as Map<String, dynamic>);
  //         return booking;
  //       });
  //       PatientInfoModel patient = await getPatientDetails(booking.patientId);
  //       DoctorInfoModel doctor = _doctorsInfoModel.firstWhere((element) => element.id == booking.doctorId);
  //       if (booking.prescriptionId != "") {
  //         PrescriptionModel prescription = await getPrescriptionDetails(booking.prescriptionId);
  //         return BookingDetails(bookingModel: booking, patient: patient, doctor: doctor, prescription: prescription);
  //       } else {
  //         return BookingDetails(bookingModel: booking, patient: patient, doctor: doctor, prescription: PrescriptionModel(
  //           id: "",
  //           fileId: "",
  //           diagnosisList: [],
  //           remarks: "",
  //         ));
  //       }
  //       // return BookingDetails(bookingModel: booking, patient: patient, doctor: doctor);
  //   } catch (e) {
  //     print("Error getting bookings: $e");
  //     throw e; // Re-throw the exception to propagate it to the caller
  //   }
  // }

  // Future<BookingModel> getBooking(bookingId) async {
  //   try {
  //     // get unique booking from id from firestore 
  //       var booking = await _firebaseFirestore
  //       .collection("bookings")
  //       .doc(bookingId)
  //       .get()
  //       .then((DocumentSnapshot snapshot) {
  //         BookingModel booking = BookingModel(
  //           id: snapshot['id'],
  //           userId: snapshot['userId'],
  //           appointmentDate: snapshot['appointmentDate'],
  //           appointmentTime: snapshot['appointmentTime'],
  //           appointmentStatus: snapshot['appointmentStatus'],
  //           paymentStatus: snapshot['paymentStatus'],
  //           doctorId: snapshot['doctorId'],
  //           previousVisit: snapshot['previousVisit'],
  //           prescriptionId: snapshot['prescriptionId'],
  //         );
  //         return booking;
  //       });
  //       return booking;
  //   } catch (e) {
  //     print("Error getting bookings: $e");
  //     throw e; // Re-throw the exception to propagate it to the caller
  //   }
  // }

  Future<List<BookingModel>> getBookings() async {
    try {
      QuerySnapshot querySnapshot = await _firebaseFirestore
          .collection("bookings")
          .where('userId', isEqualTo: _uid)
          .get();

      List<BookingModel> bookings = querySnapshot.docs
          .map((doc) => BookingModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      return bookings;
    } catch (e) {
      print("Error getting bookings: $e");
      throw e; // Re-throw the exception to propagate it to the caller
    }
  }

  Future<void> deleteBooking(String bookingId) async {
    try {
      await _firebaseFirestore.collection("bookings").doc(bookingId).delete();

      _bookings.removeWhere((booking) => booking.id == bookingId);
      notifyListeners();
    } catch (e) {
      print("Error deleting booking: $e");
    }
  }

  // Future<void> updateBooking({
  //   required String bookingId,
  //   required String appointmentDate,
  //   required String appointmentTime,
  //   required String appointmentStatus,
  //   required String paymentStatus,
  //   required String doctorId,
  //   required String prescriptionId,
  // }) async {
  //   try {
  //     await _firebaseFirestore.collection("bookings").doc(bookingId).update({
  //       'appointmentDate': appointmentDate,
  //       'appointmentTime': appointmentTime,
  //       'appointmentStatus': appointmentStatus,
  //       'paymentStatus': paymentStatus,
  //       'doctorId': doctorId,
  //       'prescriptionId': prescriptionId,
  //     });

  //     final updatedBookingIndex =
  //     _bookings.indexWhere((booking) => booking.id == bookingId);
  //     if (updatedBookingIndex != -1) {
  //       _bookings[updatedBookingIndex] = BookingModel(
  //         id: bookingId,
  //         patientId: _uid!,
  //         appointmentDate: appointmentDate,
  //         appointmentTime: appointmentTime,
  //         appointmentStatus: appointmentStatus,
  //         paymentStatus: paymentStatus,
  //         doctorId: doctorId,
  //         prescriptionId: prescriptionId,
  //       );
  //       notifyListeners();
  //     }
  //   } catch (e) {
  //     print("Error updating booking: $e");
  //   }
  // }

  // Future<void> updateUserInfo({
  //   required String name,
  //   required String email,
  //   required String bio,
  //   required String role,
  //   required String gender, 
  //   required String specilization,
  //   required String password,
  // }) async {
  //   _isLoading = true;
  //   notifyListeners();

  //   try {

  //     await _firebaseFirestore.collection("users").doc(_uid).update({
  //       'name': name,
  //       'email': email,
  //       'bio': bio,
  //       'role':role,
  //       'gender': gender,
  //       'specilization': specilization,
  //       'password': password
  //     });

  //     _userModel = UserModel(
  //       name: name,
  //       email: email,
  //       bio: bio,
  //       uid: _uid!,
  //       phoneNumber: _userModel!.phoneNumber,
  //       role: role,
  //       gender: gender,
  //       specialization: specilization,
  //       password: password
  //     );

  //     notifyListeners();
  //   } catch (e) {
  //     print("Error updating user info: $e");
  //   } finally {
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }

  Future<void> rescheduleBooking(String bookingId, String newAppointmentDate, String newAppointmentTime) async {
    try {
      await _firebaseFirestore.collection("bookings").doc(bookingId).update({
        'appointmentDate': newAppointmentDate,
        'appointmentTime': newAppointmentTime,
      });

      // Update the local list of bookings or fetch them again
      await getBookings();
      notifyListeners();
    } catch (e) {
      print("Error rescheduling appointment: $e");
      throw e;
    }
  }

  Future<List<TestModel>> fetchTests() async {
    try {
      QuerySnapshot querySnapshot = await _firebaseFirestore.collection('services').get();
      _tests = querySnapshot.docs
          .map((doc) => TestModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      return _tests;
    } catch (e) {
      print("Error fetching tests: $e");
      throw e;
    }
  }

  Future<List<LabModel>> fetchLabs() async {
    try {
      QuerySnapshot querySnapshot = await _firebaseFirestore.collection('labs').get();
      _labs = querySnapshot.docs
          .map((doc) => LabModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      return _labs;
    } catch (e) {
      print("Error fetching labs: $e");
      throw e;
    }
  }

  Future<List<LabModel>> fetchLabsForTest(List<String> labIds) async {
    try {
      List<LabModel> labs = [];

      // Fetch labs using labIds
      for (String labId in labIds) {
        DocumentSnapshot labSnapshot = await FirebaseFirestore.instance
            .collection('labs')
            .doc(labId)
            .get();

        if (labSnapshot.exists) {
          LabModel lab = LabModel.fromMap(labSnapshot.data() as Map<String, dynamic>);
          labs.add(lab);
        }
      }

      return labs;
    } catch (e) {
      print("Error fetching labs for test: $e");
      throw e;
    }
  }

  Future<List<LabTestModel>> fetchLabTests(String labId) async {
    try {
      // Assuming you have a 'tests' subcollection in each 'lab' document
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('labs')
          .doc(labId)
          .collection('tests')
          .get();

      List<LabTestModel> tests = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        return LabTestModel(
          testName: data['testName'] ?? '', // Adjust the field names based on your actual data model
          testPrice: data['testPrice'] ?? 0.0,
        );
      }).toList();

      return tests;
    } catch (e) {
      print("Error fetching lab tests: $e");
      throw e;
    }
  }


  Future<Map<String, int>> fetchTestsAndPricesForLab(String labId) async {
    try {
      // Assuming you have a 'labs' collection and each lab document has a 'tests' map field
      DocumentSnapshot labDocument = await FirebaseFirestore.instance.collection('labs').doc(labId).get();

      // Check if the lab document exists
      if (!labDocument.exists) {
        throw Exception('Lab with ID $labId not found.');
      }

      // Get the 'tests' map from the lab document
      Map<String, dynamic> testsMap = labDocument.get('tests') ?? {};

      // Convert the dynamic values to int and create a map of tests and prices
      Map<String, int> testsAndPrices = testsMap.map((testName, testPrice) =>
          MapEntry(testName, testPrice is int ? testPrice : int.parse(testPrice.toString())));

      return testsAndPrices;
    } catch (e) {
      // Handle errors, e.g., print an error message
      print('Error fetching tests and prices: $e');
      throw e; // Rethrow the error if necessary
    }
  }



  Future<List<LabModel>> fetchLabsForTestService(String testServiceId) async {
    try {
      QuerySnapshot querySnapshot = await _firebaseFirestore
          .collection('labs')
          .where('tests.${testServiceId}', isGreaterThan: 0)
          .get();

      List<LabModel> labs = querySnapshot.docs
          .map((doc) => LabModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      return labs;
    } catch (e) {
      print("Error fetching labs for test service: $e");
      throw e;
    }
  }


  Future<void> addLabToFirestore(LabModel lab) async {
    try {
      await _firebaseFirestore.collection('labs').add(lab.toMap());
      print('Lab added to Firestore: ${lab.name}');
    } catch (e) {
      print('Error adding lab to Firestore: $e');
      throw e;
    }
  }

  Future<void> addTestToFirestore(TestModel test) async {
    try {
      await _firebaseFirestore.collection('services').add(test.toMap());
      print('Test added to Firestore: ${test.name}');
    } catch (e) {
      print('Error adding test to Firestore: $e');
      throw e;
    }
  }

  Future<LabModel?> getLabFromFirestore(String labId) async {
    try {
      DocumentSnapshot docSnapshot =
      await _firebaseFirestore.collection('labs').doc(labId).get();

      if (docSnapshot.exists) {
        LabModel lab = LabModel.fromMap(docSnapshot.data() as Map<String, dynamic>);
        print('Lab retrieved from Firestore: ${lab.name}');
        return lab;
      } else {
        print('Lab not found in Firestore');
        return null;
      }
    } catch (e) {
      print('Error getting lab from Firestore: $e');
      throw e;
    }
  }

  Future<PatientInfoModel> getPatientDetails(uid) async {
    // get the user details from the uid from firestore
    return await _firebaseFirestore
      .collection("patients")
      .doc(uid)
      .get()
      .then((DocumentSnapshot snapshot) {
        PatientInfoModel patient = PatientInfoModel.fromMap(snapshot.data() as Map<String, dynamic>);
        return patient;
    });
  }

Future<PrescriptionModel> getPrescriptionDetails(id) async {
    // get the user details from the uid from firestore
    return await _firebaseFirestore
      .collection("prescriptions")
      .doc(id)
      .get()
      .then((DocumentSnapshot snapshot) {
        PrescriptionModel prescription = PrescriptionModel.fromMap(snapshot.data() as Map<String, dynamic>);
        return prescription;
    });
  }

}

