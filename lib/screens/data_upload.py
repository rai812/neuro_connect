import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';
import '../model/user_model.dart';

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
  List<List<dynamic>> _csvData = [];
  List<Map<String, dynamic>> _results = [];
  bool _isLoading = false;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      final input = file.openRead();
      final fields = await input.transform(utf8.decoder).transform(CsvToListConverter()).toList();
      setState(() {
        _csvData = fields;
      });
    }
  }

  Future<void> _processCsvData(BuildContext context) async {

    setState(() {
      _isLoading = true;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    List<Map<String, dynamic>> results = [];

    for (var i = 1; i < _csvData.length; i++) {
        try {
            var row = _csvData[i];
            String mobileNumber = row[0];
            String name = row[1];
            String dob = row[2];
            String sex = row[3];
            String email = row[4];

            final patientExists = await authProvider.getPatientByMobile(mobileNumber);
            if (patientExists != null) {
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
                'row': _csvData[i],
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
              onPressed: _pickFile,
              child: Text('Import CSV'),
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
                        title: Text(row.join(', ')),
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


