import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';

class Dashboard extends StatelessWidget {
  final int totalPatients;
  final int pendingBookings;
  final int scheduledBookings;
  final int completedBookings;

  Dashboard({
    required this.totalPatients,
    required this.pendingBookings,
    required this.scheduledBookings,
    required this.completedBookings,
  });

  void _deleteAllData(BuildContext context) {
    // Implement the logic to delete all patient data and their bookings
    final ap = Provider.of<AuthProvider>(context, listen: false);
    ap.deleteAllData();
  }

  void _downloadXls() {
    // Implement the logic to download an XLS file with the data dump
  }

  @override
  Widget build(BuildContext context) {
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
                  onPressed: () => _deleteAllData(context),
                  child: Text('Delete All Data'),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _downloadXls,
                  child: Text('Download XLS'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}