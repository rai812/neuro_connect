import 'package:neurocare/screens/allServices.dart';
import 'package:neurocare/screens/help.dart';
import 'package:neurocare/screens/profile.dart';
import 'package:neurocare/screens/user_info.dart';
import 'package:neurocare/screens/search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../provider/auth_provider.dart';
import '../provider/cart_provider.dart';
import 'appointment_screen.dart';
import 'cart.dart';
import 'home.dart';
import 'offers.dart';
import 'admin_home.dart';
import 'schedule.dart';

class NavBar extends StatefulWidget {
  String role;
  NavBar({Key? key, required this.role}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {

  int selectedIndex = 0;
  List<Widget> screens = [
    HomeScreen(),
    AllBookingsScreen(),
    // SpecialOffers(),
    ProfileScreen(),
  ];

    int remainingMinutes = 6;
    late Timer _timer;

    void startTimer() {
      _timer = Timer.periodic(const Duration(minutes: 2), (timer) {
        setState(() {
          if (remainingMinutes > 0) {
            remainingMinutes--;
            remainingMinutes--;
          }
        });
      });
    }


    @override
    void initState() {
      super.initState();
      startTimer();
    }


    @override
    void dispose() {
      _timer.cancel();
      super.dispose();
    }


  @override
  Widget build(BuildContext context) {
    // final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    void refreshScreen() async {
      // Add your refresh logic here
      await authProvider.getDataFromFirestore();
      setState(() {
        remainingMinutes = 6;  
      });
    }

    if (remainingMinutes <= 0) {
      refreshScreen();
    }



    if (widget.role == "admin" || authProvider.role == "Doctor") {
      screens = [
        AdminHomeScreen(),
        // AllDoctorsScreen(),
        authProvider.doctors.isNotEmpty 
          ? DoctorScheduleScreen(doctor: authProvider.doctors[0]) 
          : Center(child: Text("No doctors available")),
        SearchScreen(),
        const ProfileScreen(),
      ];
    } else {
      screens = [
        HomeScreen(),
        // AllBookingsScreen(),
        // SpecialOffers(),
        const ProfileScreen(),
      ];
    }

    Widget getIcon() {
      if (selectedIndex == screens.length - 1) {
        if (authProvider.role == "Doctor") {
          return Icon(Icons.person_add_alt_1_rounded);
        } else if (authProvider.role == "Patient") {
          return Icon(Icons.person_add_alt_1_rounded);
        }
        else if (authProvider.role == "admin") {
          return Icon(Icons.person_add_alt_1_rounded);
        }
        else {
          return Icon(Icons.person_add_alt_1_rounded);
        }
      } else {
        return Icon(Icons.schedule_send_sharp);
      }
    }

    Widget getLabel() {
      if (selectedIndex == screens.length - 1) {
        if (authProvider.role == "Doctor") {
          return Text("Add Doctor");
        } else if (authProvider.role == "Patient") {
          return Text("Add Patient");
        }
        else if (authProvider.role == "admin") {
          return Text("Add New Patient");
        }
        else {
          return 
              Text("Add Doctor");
        }
      } else {
        return Text("Book Appointment");;
      }
    }

    Widget getFloatingButton() {
     return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            onPressed: () async {
                if (selectedIndex == screens.length - 1) {
                  if (authProvider.role == "Doctor") {
                    Navigator.push(context, 
                      MaterialPageRoute(builder: (context) => ADDDoctorScreen())
                    );
                  } else if (authProvider.role == "Patient") {  
                    Navigator.push(context, 
                      MaterialPageRoute(builder: (context) => AddPatientScreen())
                    );
                  }
                  else if (authProvider.role == "admin") {
                    Navigator.push(context, 
                      MaterialPageRoute(builder: (context) => AdminAddPatientScreen())
                    );
                  }
                  else {
                    Navigator.push(context, 
                      MaterialPageRoute(builder: (context) => AllDoctorsScreen())
                    );
                  }
                // Navigator.pop(context);
                }
                else {
                  // Admin booking screen for admin and doctor TODO
                  if (authProvider.role == "Doctor") {
                    Navigator.push(context, 
                      MaterialPageRoute(builder: (context) => NewBookingScreen())
                    );
                  } else if (authProvider.role == "Patient") {  
                    Navigator.push(context, 
                      MaterialPageRoute(builder: (context) => AllDoctorsScreen())
                    );
                  }
                  else if (authProvider.role == "admin") {
                    Navigator.push(context, 
                      MaterialPageRoute(builder: (context) => NewBookingScreen())
                    );
                  }
                  else {
                  Navigator.push(context, 
                      MaterialPageRoute(builder: (context) => AllDoctorsScreen())
                    );
                  }
                }
            },
            backgroundColor: Color(0xFF3E69FE),
            icon:getIcon(),
            label: getLabel(),
            heroTag: "btn1",
          ),
          SizedBox(
            height: 10,
          ),
          if (authProvider.role == "Patient")
            FloatingActionButton.extended(
            onPressed: () async {

              if (await authProvider.isHelpAlreadyExist(authProvider.patientsInfoModel[authProvider.activePatientIndex].id, 'pending'))
              {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                  title: Text('Clinic has already been notified for previous help request'),
                  content: Text('Please wait for the clinic to respond back.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                    Navigator.of(context).pop();
                      },
                      child: Text('Okay'),
                    ),
                  ],
                    );
                  },
                );

              }
              else 
              {
                // gaurd with mounted check
                if (!mounted) return;
                await triggerHelp(context);
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                  title: Text('Clinic has been notified'),
                  content: Text('Please wait for the clinic to respond back.'),
                  actions: [
                    
                    TextButton(
                      onPressed: () {
                    Navigator.of(context).pop();
                      },
                      child: Text('Okay'),
                    ),
                  ],
                    );
                  },
                );

              }
              // show a pop up saying that the clinic is notified and will contact you soon
            },
            backgroundColor: Color(0xFF3E69FE),
            icon:Icon(Icons.help_outline_rounded),
            label: Text("Get Help"),
            heroTag: "btn2",
          ),
          SizedBox(
            height: 10,
          ),
          if (authProvider.role == "admin" || authProvider.role == "Doctor")
            FloatingActionButton.extended(
            onPressed: () async {

              await authProvider.getDataFromFirestore();
              {
                setState(() {
                  remainingMinutes = 6;
                });
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                  title: Text('Refressh Complete'),
                  actions: [
                    TextButton(
                      onPressed: () {
                    Navigator.of(context).pop();
                      },
                      child: Text('Okay'),
                    ),
                  ],
                    );
                  },
                );

              }
              // show a pop up saying that the clinic is notified and will contact you soon
            },
            backgroundColor: Color(0xFF3E69FE),
            icon:Icon(Icons.refresh),
            label: Text("Refresh"),
            heroTag: "btn3",
          )
        ]
      );
    }
    Widget? buildTimer() {
      if (remainingMinutes <= 2) {
      return Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
        color: const Color.fromARGB(136, 255, 2, 2),
        borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
        'refressing in $remainingMinutes min',
        style: TextStyle(color: Colors.white, fontSize: 8),
        ),
      );
    }
      else {
        // return an empty container
        return null;
      }
    }
    return Scaffold(
      backgroundColor: Colors.white,
      bottomSheet: buildTimer(),
      body: screens[selectedIndex],
      bottomNavigationBar: Container(
        height: 60,
        child: BottomNavigationBar(
          elevation: 5,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Color(0xFF3E69FE),
          unselectedItemColor: Colors.black54,
          currentIndex: selectedIndex,
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: "Home",
            ),
            if (authProvider.role == "admin" || authProvider.role == "Doctor")
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined),
              label: "Schedule",
            ),
            if (authProvider.role == "admin" || authProvider.role == "Doctor")
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: "Search",
              ),
            BottomNavigationBarItem(
              icon: Icon(Icons.perm_identity),
              label: "Profile",
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () async {
      //       if (selectedIndex == screens.length - 1) {
      //         if (authProvider.role == "Doctor") {
      //           Navigator.push(context, 
      //             MaterialPageRoute(builder: (context) => ADDDoctorScreen())
      //           );
      //         } else if (authProvider.role == "Patient") {  
      //           Navigator.push(context, 
      //             MaterialPageRoute(builder: (context) => AddPatientScreen())
      //           );
      //         }
      //         else if (authProvider.role == "admin") {
      //           Navigator.push(context, 
      //             MaterialPageRoute(builder: (context) => AdminAddPatientScreen())
      //           );
      //         }
      //         else {
      //           Navigator.push(context, 
      //             MaterialPageRoute(builder: (context) => AllDoctorsScreen())
      //           );
      //         }
      //       // Navigator.pop(context);
      //       }
      //       else {
      //         // Admin booking screen for admin and doctor TODO
      //         if (authProvider.role == "Doctor") {
      //           Navigator.push(context, 
      //             MaterialPageRoute(builder: (context) => NewBookingScreen())
      //           );
      //         } else if (authProvider.role == "Patient") {  
      //           Navigator.push(context, 
      //             MaterialPageRoute(builder: (context) => AllDoctorsScreen())
      //           );
      //         }
      //         else if (authProvider.role == "admin") {
      //           Navigator.push(context, 
      //             MaterialPageRoute(builder: (context) => NewBookingScreen())
      //           );
      //         }
      //         else {
      //         Navigator.push(context, 
      //             MaterialPageRoute(builder: (context) => AllDoctorsScreen())
      //           );
      //         }
      //       }
      //   },
      //   backgroundColor: Color(0xFF3E69FE),
      //   icon:getIcon(),
      //   label: getLabel(),

      // ),
      floatingActionButton: getFloatingButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      // give some offset to the floating action button so that text added to it is visible
    );
  }
}
