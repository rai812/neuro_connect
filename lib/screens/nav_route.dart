import 'package:digi_diagnos/screens/allServices.dart';
import 'package:digi_diagnos/screens/help.dart';
import 'package:digi_diagnos/screens/profile.dart';
import 'package:digi_diagnos/screens/user_info.dart';
import 'package:digi_diagnos/screens/search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  var screens = [
    HomeScreen(),
    AllBookingsScreen(),
    // SpecialOffers(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    if (widget.role == "admin" || authProvider.role == "Doctor") {
      screens = [
        AdminHomeScreen(),
        // AllDoctorsScreen(),
        DoctorScheduleScreen(doctor: authProvider.doctors[0]),
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

          )
        ]
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
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
      floatingActionButton: FloatingActionButton.extended(
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

      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      // give some offset to the floating action button so that text added to it is visible
    );
  }
}
