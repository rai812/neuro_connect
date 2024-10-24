import 'package:digi_diagnos/provider/auth_provider.dart';
import 'package:digi_diagnos/screens/appointment_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../model/user_model.dart';

class DoctorScheduleScreen extends StatefulWidget {
  DoctorInfoModel doctor;
  DoctorScheduleScreen({required this.doctor});
  @override
  _DoctorScheduleScreenState createState() => _DoctorScheduleScreenState();
}

class _DoctorScheduleScreenState extends State<DoctorScheduleScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<BookingDetails>> _appointments = {};
  bool _isLoading = true; // Spinner loading indicator

  @override
  void initState() {
    super.initState();
    _fetchAppointmentsForMonth(_focusedDay); // Fetch data for the current month on load
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dr ${widget.doctor.name}\'s Schedule'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2024, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            calendarFormat: _calendarFormat,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay; // update `_focusedDay` here as well
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
              _fetchAppointmentsForMonth(focusedDay); // Fetch data for the new month
            },
            eventLoader: _getAppointmentsForDay,
            calendarStyle: const CalendarStyle(
              markersAlignment: Alignment.bottomCenter,
            ),
            calendarBuilders: CalendarBuilders(
      markerBuilder: (context, day, events) => events.isNotEmpty
                ? Padding(
                  padding: const EdgeInsets.only(top: 30, left: 45),
                  child: Container(
                      width: 24,
                      height: 24,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Colors.lightBlue,
                      ),
                      child: Text(
                        '${events.length}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                )
                : null,
            )
          ),
          const SizedBox(height: 8.0),
          if (_selectedDay != null) _buildAppointmentList(),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     if (_selectedDay != null) {
      //       _showAddAppointmentDialog(context);
      //     }
      //   },
      //   child: Icon(Icons.add),
      // ),
    );
  }

  List<BookingDetails> _getAppointmentsForDay(DateTime day) {
    return _appointments[day] ?? [];
  }

  // Future<List<BookingDetails>> _getAppointmentsForDay(DateTime day) async {
  //   final ap = Provider.of<AuthProvider>(context, listen: true);
  //   List<BookingDetails> appointments = [];
  //   await ap.getBookingDetails('scheduled', "${day!.day}/${day!.month}/${day!.year}").then((bookings) {
  //     for (var booking in bookings) {
  //       appointments.add(booking);
  //     }
  //   });
  //   await ap.getBookingDetails('completed', "${day!.day}/${day!.month}/${day!.year}").then((bookings) {
  //     for (var booking in bookings) {
  //       appointments.add(booking);
  //     }
  //   });
  //   return appointments;
  // }

  Future<void> _fetchAppointmentsForMonth(DateTime focusedDay) async {
    setState(() {
      _isLoading = true; // Show spinner while loading data
    });

    // Simulate a network call or database fetch

    // get the start and end date of the month
    DateTime firstDay = DateTime.utc(focusedDay.year, focusedDay.month, 1);
    DateTime lastDay = DateTime.utc(focusedDay.year, focusedDay.month + 1, 0);
    final ap = Provider.of<AuthProvider>(context, listen: false);
    Map<DateTime, List<BookingDetails>> fetchedAppointments = {};
    await ap.getBookingDetailsInDateRange(firstDay, lastDay).then((bookings) {
      for (var booking in bookings) {
        // create the date time from the timestamp
        DateTime date = booking.bookingModel.timestamp;
        // remove the time part
        date = DateTime.utc(date.year, date.month, date.day);
        if (fetchedAppointments[date] == null) {
          fetchedAppointments[date] = [];
        }
        fetchedAppointments[date]!.add(booking);
      }
    });

    setState(() {
      _appointments.addAll(fetchedAppointments);
      _isLoading = false; // Hide spinner after loading data
    });
  }

  Future<List<BookingDetails>> _fetchAppointmentsForSelectedDay() async {
    // Simulate a delay to mimic a network call or database fetch
    // await Future.delayed(Duration(seconds: 1));
    DateTime day = _appointments.keys.firstWhere((element) => isSameDay(element, _selectedDay));
    // Fetch the appointments for the selected day
    return _appointments[day] ?? [];
  }

  Widget _buildAppointmentList() {

     return Expanded(
      child: _isLoading
          ? Center(child: CircularProgressIndicator()) // Show spinner while loading
          : FutureBuilder<List<BookingDetails>>(
        future: _fetchAppointmentsForSelectedDay(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No appointments for this day.'));
          } else {
            final appointments = snapshot.data!;
            return ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                return BookingCard(booking: appointments[index]);
              },
            );
          }
        },
      ),
    );
  }

  // void _showAddAppointmentDialog(BuildContext context) {
  //   final _appointmentController = TextEditingController();
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text('Add Appointment'),
  //         content: TextField(
  //           controller: _appointmentController,
  //           decoration: InputDecoration(hintText: 'Enter appointment details'),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: Text('Cancel'),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               final appointment = _appointmentController.text;
  //               if (appointment.isNotEmpty) {
  //                 setState(() {
  //                   _appointments[_selectedDay!] = _appointments[_selectedDay!] ?? [];
  //                   _appointments[_selectedDay!]!.add(appointment);
  //                 });
  //               }
  //               Navigator.of(context).pop();
  //             },
  //             child: Text('Add'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
