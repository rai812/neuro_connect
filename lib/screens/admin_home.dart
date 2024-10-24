import 'package:digi_diagnos/screens/home.dart';
import 'package:flutter/material.dart';
// import 'package:digi_diagnos/model/user_model.dart';
import 'package:digi_diagnos/screens/appointment_screen.dart';
// import 'package:digi_diagnos/screens/testDetails.dart';
// import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import '../model/labModal.dart';
// import '../model/testModal.dart';
// import '../model/booking_model.dart';
import '../provider/auth_provider.dart';
// import '../widgets/labCard.dart';
// import 'allLabs.dart';
// import 'allServices.dart';
// import 'nav_route.dart';
// import 'home.dart';
import '../widgets/drawer.dart';

class AdminHomeScreen extends StatefulWidget {
  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  DateTime? _selectedDate;
  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  Future<List<BookingDetails>> getAllBookings(status) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.role == "Doctor") {
      return authProvider.getBookingDetails(status, "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}");
    }
    else {
      return authProvider.getBookingDetails(status, "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}");
    }
    
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: true);
    var tabs = [
        Tab(text: 'Pending Bookings'),
        Tab(text: 'Scheduled Bookings'),
        Tab(text: 'Completed Bookings'),

        // Tab(text: 'All Bookings'),
    ];

    return Scaffold(
      appBar: AppBar(
        // title: Text('Home Screen'),
        bottom: TabBar(
          controller: _tabController,
          tabs: tabs,
          labelColor: const Color.fromARGB(179, 248, 249, 252),
          unselectedLabelColor: const Color.fromARGB(179, 12, 12, 12),
          indicatorColor: const Color.fromARGB(179, 80, 105, 248),
        ),
      ),
      drawer: DrawerWidget(),
      body: TabBarView(

        controller: _tabController,
        children: [
          // Pending Bookings Tab
          Center(
            child: 
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Pending Bookings",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromARGB(179, 80, 105, 248),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  FutureBuilder<List<BookingDetails>>(
                    // Replace with the actual method to fetch the top 2 labs
                    future: authProvider.getBookingDetails("Pending", ""), // get pending bookings
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text("Error: ${snapshot.error}"),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Text("No Pending booking request."),
                        );
                      } else {
                        // Use the fetched list of top labs to create LabCard widgets
                        List<BookingDetails> topLabs = snapshot.data!;

                        return Column(
                          children: topLabs.map((booking) => BookingCard(booking: booking)).toList(),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),           

          ),
          // Scheduled Bookings Tab
          Center(
            child: Container(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Scheduled Bookings",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromARGB(179, 80, 105, 248),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        ElevatedButton(
                          onPressed: () => _selectDate(context),
                          child: Text('Select Date'),
                        ),
                      if (_selectedDate != null)
                        Text("Showing Appointments for ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"),
              
                        FutureBuilder<List<BookingDetails>>(
                          // Replace with the actual method to fetch the top 2 labs
                          future: getAllBookings("scheduled"), // get pending bookings
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text("Error: ${snapshot.error}"),
                              );
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return Center(
                                child: Text("No Scheduled booking request."),
                              );
                            } else {
                              // Use the fetched list of top labs to create LabCard widgets
                              List<BookingDetails> topLabs = snapshot.data!;
                              return Column(
                                children: topLabs.map((booking) => BookingCard(booking: booking)).toList(),
                              );
                              // return Column(
                              //   children: [
                              //     BookingCard(booking: topLabs[0]),
                              //     // SizedBox(height: 5),
                              //     // BookingCard(booking: topLabs[0]),
                              //   ],
                              // );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
              
                ],
              ),
            ),
          ),

          Center(
            child: 
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Completed Bookings",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromARGB(179, 80, 105, 248),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  FutureBuilder<List<BookingDetails>>(
                    // Replace with the actual method to fetch the top 2 labs
                    future: authProvider.getBookingDetails("Completed", ""), // get pending bookings
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text("Error: ${snapshot.error}"),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Text("No Complete booking request."),
                        );
                      } else {
                        // Use the fetched list of top labs to create LabCard widgets
                        List<BookingDetails> topLabs = snapshot.data!;

                        return Column(
                          children: topLabs.map((booking) => BookingCard(booking: booking)).toList(),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),           

          ),
        ],
      ),
    );
  }
}
