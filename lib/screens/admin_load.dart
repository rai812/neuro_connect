import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';
import '../model/user_model.dart';
import '../model/booking_model.dart';
import 'dart:io';
import 'dart:math';
class AdminLoadScreen extends StatefulWidget {
  @override
  _AdminLoadScreenState createState() => _AdminLoadScreenState();
}

class _AdminLoadScreenState extends State<AdminLoadScreen> {
  List<Map<String, String>> patients = [];

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xls', 'xlsx'],
    );

    if (result != null) {
      // var bytes = result.files.first.bytes;
      var bytes = File(result.files.single.path!).readAsBytesSync();
      var excel = Excel.decodeBytes(bytes!);

      for (var table in excel.tables.keys) {
        for (var row in excel.tables[table]!.rows) {
          // if name is null then break the loop
          if (row[1]?.value == null) break;
          patients.add({
            'name': row[1]?.value?.toString() ?? "User ${Random().nextInt(100)}", // random name
            'phone': row[2]?.value?.toString() ?? "0${Random().nextInt(100)}",
            'dob': row[3]?.value?.toString() ?? '1980-01-01',
            'email': row[4]?.value?.toString() ?? 'abc@test.com',
          });
        }
      }
      setState(() {});
    }
  }

  Future<void> processPatients(BuildContext context) async {

    await createClinic(context);

    // Create a random doctor
    await createDoctor(context);

    // Create pending bookings for all patients
    for (var patient in patients) {
      var patietnInfoModel = await createPatient(context, patient);
      var booking = await createPendingBooking(context, patietnInfoModel);

      // Schedule half of the pending bookings
      if (patients.indexOf(patient) % 2 == 0) {
        booking = await scheduleBooking(context, booking);

        // Complete half of the scheduled bookings
        if (patients.indexOf(patient) % 4 == 0) {
          booking = await completeBooking(context, booking);
          await uploadPrescription(booking);
        }
      }
    }
  }

  Future<void> createClinic(BuildContext context) async {
    // Implement clinic creation logic
    final ap = Provider.of<AuthProvider>(context, listen: false);
    return ap.createRandomClinic(); 
  }
  Future<void> createDoctor(BuildContext context) async {
    // Implement doctor creation logic
    final ap = Provider.of<AuthProvider>(context, listen: false);
    return ap.createRandomDoctor();
  }

  Future<PatientInfoModel> createPatient(BuildContext context, Map<String, String> patient) async {
    // Implement user creation logic
    final ap = Provider.of<AuthProvider>(context, listen: false);

    UserModel userModel = UserModel(
      phoneNumber: patient['phone']!,
      role: 'patient',
      uid: patient['phone']!,
      password: '12345',
      resetPassword: false,
    );
    await ap.createUser(userModel);

    // create a date time object from string date

    DateTime dob = DateTime.parse(patient['dob']!);

    PatientInfoModel patientInfoModel = PatientInfoModel(
      name: patient['name']!,
      email: patient['email']!,
      dob: dob,
      gender: 'Male',
      id: patient['phone']!,
      userId: patient['phone']!,
    );
    if (!mounted) return patientInfoModel;
    ap.savePatientDataToFirebaseAdmin(context : context,  userModel : patientInfoModel, onSuccess:  (){
      print('Patient data saved');
    });
    await ap.getPatientsDataFromFirestore();
    return ap.patients.where((element) => element.userId == patient['phone']).first;
  }

  Future<BookingModel> createPendingBooking(BuildContext context, PatientInfoModel patient) async {
    // Implement pending booking creation logic
    final ap = Provider.of<AuthProvider>(context, listen: false);
    BookingModel booking = BookingModel(
      doctorId: ap.doctors.first.id,
      patientId: patient.id,
      id: await  ap.getNewBookingId(),
      appointmentDate: '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
      appointmentTime: TimeOfDay.now().format(context),
      appointmentStatus: 'pending',
      paymentStatus: 'pending',
      prescriptionId: '',
      tokenNumber: '',
      remark: '',
      timestamp: DateTime.now(),
    );
    ap.saveBookingDataToFirebase(context: context, booking: booking, onSuccess: (){
      print('Booking data saved');
    });

    return booking;
  }

  Future<BookingModel> scheduleBooking(BuildContext context, BookingModel booking) async {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    var bookinMap = booking.toMap();
    bookinMap['appointmentStatus'] = 'scheduled';
    booking = BookingModel.fromMap(bookinMap);
    ap.saveBookingDataToFirebase(context: context, booking: booking, onSuccess: (){
      print('Booking data saved');
    });
    // Implement booking scheduling logic
    return booking;
  }

  Future<BookingModel> completeBooking(BuildContext context, BookingModel booking) async {
    // Implement booking completion logic
    final ap = Provider.of<AuthProvider>(context, listen: false);
    var bookinMap = booking.toMap();
    bookinMap['appointmentStatus'] = 'completed';
    booking = BookingModel.fromMap(bookinMap);
    ap.saveBookingDataToFirebase(context: context, booking: booking, onSuccess: (){
      print('Booking data saved');
    });
    // Implement booking scheduling logic
    return booking;    
  }

  Future<void> uploadPrescription(booking) async {
    // Implement prescription upload logic
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Load Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: pickFile,
              child: Text('Pick Excel File'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await processPatients(context);
              },
              child: Text('Process Patients'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: patients.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(patients[index]['name']!),
                    subtitle: Text(patients[index]['phone']!),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}