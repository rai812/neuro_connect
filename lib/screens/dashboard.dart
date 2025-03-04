import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';
import '../model/user_model.dart';
import 'package:dropdown_search/dropdown_search.dart';

class Dashboard extends StatelessWidget {

    int totalPatients = 0;
    int pendingBookings = 0;
    int scheduledBookings = 0;
    int completedBookings = 0;

  Dashboard({Key? key}) : super(key: key);

  // set the totalPatients, pendingBookings, scheduledBookings, and completedBookings in the initState

  void _deleteAllData(BuildContext context) {
    // Implement the logic to delete all patient data and their bookings
    final ap = Provider.of<AuthProvider>(context, listen: false);
    ap.deleteAllData();
  }

  void _downloadXls(context) {
    // Implement the logic to download an XLS file with the data dump
    final ap = Provider.of<AuthProvider>(context, listen: false);
    ap.downloadAndDumpAllData();
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: true);
    final totalPatients = ap.patients.length;
    final pendingBookings = ap.pendingBookings;
    final scheduledBookings = ap.scheduledBookings;
    final completedBookings = ap.completedBookings;

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Patients: $totalPatients', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Pending Bookings: $pendingBookings', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Scheduled Bookings: $scheduledBookings', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Completed Bookings: $completedBookings', style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  // onPressed: () => _deleteAllData(context),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.grey),
                  ),
                  child: Text('Delete All Data'),
                  onPressed: null,
                  
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => _downloadXls(context),
                  child: Text('Download Data'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ResetPasswordScreen extends StatefulWidget {
  ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {

  String _selectedPatient = '';

  void _resetPassword(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    if (_selectedPatient.isNotEmpty) {
      ap.resetPassword(_selectedPatient);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password reset successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please Choose a Patient')),
      );
    }
  }

  Widget _customPopupItemBuilderPatient(BuildContext context, PatientInfoModel item, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
      child: ListTile(
        selected: isSelected,
        title: Text(item.name),
        subtitle: Text(item.userId.toString()),
        leading: const CircleAvatar(
          backgroundImage: AssetImage('assets/images/doctor6.png'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownSearch<PatientInfoModel>(
              asyncItems: (filter) => authProvider.getPatientByName(filter),
              compareFn: (i, s) => i.id == s.id,
              onChanged: (PatientInfoModel? newValue) {
                setState(() {
                  _selectedPatient = newValue!.id;
                });
              },
              popupProps: PopupPropsMultiSelection.modalBottomSheet(
                isFilterOnline: true,
                showSelectedItems: true,
                showSearchBox: true,
                itemBuilder: _customPopupItemBuilderPatient,
              ),
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: "Patient",
                  hintText: "Choose a Patient",
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _resetPassword(context),
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}