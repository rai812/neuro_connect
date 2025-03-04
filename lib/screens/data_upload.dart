import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';
import '../model/user_model.dart';
import 'dart:math';

  // store user data to database
  void storePatientData(context, mobileNumber, name, dob, sex, email) async {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    UserModel userModel = UserModel(
      phoneNumber: mobileNumber,
      uid: mobileNumber,
      password: "12345",// generate password,
      role: 'Patient',
      resetPassword: true,
    );
    await ap.saveUserDataToFirebase(context: context, userModel: userModel);
    // save user data to firebase
    // get datetime from sting 
    DateTime _selectedDate = DateTime.parse(dob);
    PatientInfoModel patientModel = PatientInfoModel(
      name: name,
      email: email,
      userId: userModel.uid,
      gender: sex,
      id: '',
      dob: _selectedDate!,
    );
 
    patientModel.id = await ap.getNewPatientId();

    ap.savePatientDataToFirebaseAdmin(
      context: context,
      userModel: patientModel,
      onSuccess: () {
      },
    );
  }


class DataLoadingScreen extends StatefulWidget {
  @override
  _DataLoadingScreenState createState() => _DataLoadingScreenState();
}

class _DataLoadingScreenState extends State<DataLoadingScreen> {
  // List<List<dynamic>> _csvData = [];
  List<Map<String, dynamic>> _results = [];
  List<Map<String, String>> patients = [];
  bool _isLoading = false;

  // # Future<void> _pickFile() async {
  // #   FilePickerResult? result = await FilePicker.platform.pickFiles(
  // #     type: FileType.custom,
  // #     allowedExtensions: ['csv'],
  // #   );

  // #   if (result != null) {
  // #     File file = File(result.files.single.path!);
  // #     final input = file.openRead();
  // #     final fields = await input.transform(utf8.decoder).transform(CsvToListConverter()).toList();
  // #     setState(() {
  // #       _csvData = fields;
  // #     });
  // #   }
  // # }
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
          if (row[1]?.value == null || row[2]?.value == null) break;

          // check if row[2] is valid phone number
          if (row[2]?.value?.toString().length != 10) {
            continue;
          }

          // strip the string from start or end spaces and add to the list
          patients.add({
            'name': row[1]?.value?.toString().trim() ?? "User ${Random().nextInt(100)}", // random name
            'phone': row[2]?.value?.toString().trim() ?? "0${Random().nextInt(100)}",
            'dob': row[3]?.value?.toString().trim() ?? '1980-01-01',
            'email': row[4]?.value?.toString().trim() ?? 'abc@test.com',
            'sex': row[5]?.value?.toString().trim() ?? 'Male',
          });
        }
      }
      setState(() {});
    }
  }
  Future<void> _processCsvData(BuildContext context) async {

    setState(() {
      _isLoading = true;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    List<Map<String, dynamic>> results = [];

    for (var i = 0; i < patients.length; i++) {
        try {
            var row = patients[i];
            String mobileNumber = row['phone']?.toString() ?? '';
            String name = row['name']?.toString() ?? '';
            String dob = row['dob']?.toString() ?? '';
            String sex = row['sex']?.toString() ?? '';
            String email = row['email']?.toString() ?? '';

            final patientExists = await authProvider.getPatientByMobile(mobileNumber);
            if (patientExists.isNotEmpty) {
                results.add({
                'row': row,
                'status': 'failed',
                'reason': 'Patient already exists',
                });
            } else {
                storePatientData(context, mobileNumber, name, dob, sex, email);
                results.add({
                'row': row,
                'status': 'success',
                });
            }
        } catch (e) {
            results.add({
                'row': patients[i],
                'status': 'failed',
                'reason': e.toString(),
            });
        }
    }

    setState(() {
      _results = results;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Loading Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: pickFile,
              child: Text('Import XLS File'),
            ),
            Expanded(
                // show spinner while loading
                child: _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                  itemCount: _results.length,
                  itemBuilder: (context, index) {
                    var result = _results[index];
                    var row = result['row'];
                    var status = result['status'];
                    var reason = result['reason'] ?? '';
                    return ListTile(
                        title: Text(row.entries.map((e) => '${e.key}: ${e.value}').join(', ')),
                        subtitle: Text(status == 'success' ? 'Success' : 'Failed: $reason'),
                        trailing: status == 'success' ? Icon(Icons.check) : Icon(Icons.error),
                        tileColor: status == 'success' ? Colors.green[100] : Colors.red[100],
                    );
                  },
                )
            ),
            // submit button
            ElevatedButton(
              onPressed: () {
                // Save the results to a file
                _processCsvData(context);
              },
              child: Text('Submit'),
            ),

          ],
        ),
      ),
    );
  }
}


