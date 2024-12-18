import 'package:digi_diagnos/model/user_model.dart';
import 'package:digi_diagnos/screens/appointment_screen.dart';
import 'package:digi_diagnos/screens/phone.dart';
import 'package:digi_diagnos/screens/user_info.dart';
import 'package:digi_diagnos/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:digi_diagnos/provider/auth_provider.dart';
import '../model/booking_model.dart';
// import 'adminScreen.dart';
import 'admin_home.dart';
import 'editProfile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

// class _ProfileScreenState extends State<ProfileScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('My Profile'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Consumer<AuthProvider>(
//             builder: (context, authProvider, child) {
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   if (authProvider.isLoading)
//                     Center(child: CircularProgressIndicator())
//                   else if (authProvider.isSignedIn)
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         // CircleAvatar(
//                         //   radius: 50,
//                         //   backgroundImage: NetworkImage(authProvider.userModel.profilePic as String),
//                         // ),
//                         // SizedBox(height: 20),
//                         Text(
//                           'Name: ${authProvider.patientsInfoModel[0].name ?? "N/A"}',
//                           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                         ),
//                         SizedBox(height: 10),
//                         Text(
//                           'Phone: ${authProvider.userModel.phoneNumber ?? "N/A"}',
//                           style: TextStyle(fontSize: 16, color: Colors.grey),
//                         ),
//                         SizedBox(height: 10),
//                         // Text(
//                         //   'Bio: ${authProvider.patientsInfoModel[].bio ?? "N/A"}',
//                         //   style: TextStyle(fontSize: 16, color: Colors.grey),
//                         // ),
//                         // SizedBox(height: 10),
//                         Text(
//                           'Email: ${authProvider.patientsInfoModel[0].email ?? "N/A"}',
//                           style: TextStyle(fontSize: 16, color: Colors.grey),
//                         ),
//                         // Add more user details here

//                         if (authProvider.userModel.role == 'admin')
//                           ElevatedButton(
//                             style: ButtonStyle(
//                               backgroundColor: MaterialStateProperty.all(Color(0xFF3E69FE)),
//                             ),
//                             onPressed: () {
//                               // Navigate to the developer screen
//                               Navigator.push(context, MaterialPageRoute(
//                                 builder: (BuildContext context) =>  AdminHomeScreen(),
//                               ));
//                             },
//                             child: Text('Go to Developer Screen'),
//                           ),
//                         // Add a decorative button with the logic
//                         ElevatedButton(
//                           style: ButtonStyle(
//                             backgroundColor: MaterialStateProperty.all(Color(0xFF3E69FE)),
//                           ),
//                           onPressed: () async {
//                             // Trigger loading data from Firestore
//                             await authProvider.getDataFromFirestore();
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(content: Text('Data loaded from Firestore')),
//                             );
//                             Navigator.push(context, MaterialPageRoute (
//                               builder: (BuildContext context) => const EditProfileScreen(),
//                             ),);
//                           },
//                           child: Text('Edit Profile'),
//                         ),
//                       ],
//                     )
//                   else
//                     Center(
//                       child: ElevatedButton(
//                         onPressed: () async {
//                           // Trigger loading data from Firestore

//                           await authProvider.getDataFromFirestore();
//                         },
//                         child: Text('Load Data from Firestore'),
//                       ),
//                     ),
//                   SizedBox(height: 20,),
//                   Container(
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(20),
//                         color: Colors.white,
//                         boxShadow: [BoxShadow(
//                           color: Colors.grey,
//                           offset: Offset(0.0, 1.0),
//                           blurRadius: 6.0,
//                         ),]
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // ListTile(
//                           //   leading: Icon(Icons.place),
//                           //   title: Text('Addresses'),
//                           //   onTap: () {
//                           //     // Add your settings logic here
//                           //   },
//                           // ),
//                           // ListTile(
//                           //   leading: Icon(Icons.electric_bolt),
//                           //   title: Text('Electronic Health Records'),
//                           //   onTap: () {
//                           //     // Add your settings logic here
//                           //   },
//                           // ),
//                           // ListTile(
//                           //   leading: Icon(Icons.settings),
//                           //   title: Text('Settings'),
//                           //   onTap: () {
//                           //     // Add your settings logic here
//                           //   },
//                           // ),
//                           // ListTile(
//                           //   leading: Icon(Icons.contact_emergency),
//                           //   title: Text('Contact Us'),
//                           //   onTap: () {
//                           //     // Add your settings logic here
//                           //   },
//                           // ),
//                           ListTile(
//                             leading: Icon(Icons.logout),
//                             title: Text('LogOut'),
//                             onTap: () {
//                               // Add your settings logic here
//                               // Call the AuthProvider method for user sign out
//                               AuthProvider().userSignOut();
//                               Navigator.of(context).pushReplacement(MaterialPageRoute (
//                                 builder: (BuildContext context) => const RegisterScreen(),
//                               ),); // Navigate to login screen
//                             },
//                           ),
//                           // Add more menu items here
//                         ],

//                       ),
//                     ),
//                   ),
//                   Container(
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Icon(Icons.facebook, size: 30),
//                           Icon(Icons.email, size: 30),
//                           Icon(Icons.whatshot, size: 30),
//                           Icon(Icons.facebook, size: 30),
//                           Icon(Icons.email, size: 30),
//                           Icon(Icons.whatshot, size: 30),
//                           // Add more social media icons here
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

class _ProfileScreenState extends State<ProfileScreen> {

  Future<Widget> loadWidget () async {
    final authProvider = Provider.of<AuthProvider>(context, listen: true);
    if (authProvider.role == 'admin') {
      return 
            Container(
            child: 
            FutureBuilder<List<DoctorInfoModel>>(
              future: authProvider.getAllDoctors(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("Error: ${snapshot.error}"),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty ?? true) {
                  return Center(
                    child: Text("No Doctors listed."),
                  );
                } else {
            
                  return ListView.builder(
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) {
                          return DoctorCard(doctorInfoModel: snapshot.data![index], showControles: true,);
                        },
                  );
                }
              },
            ),
          );
    } else if (authProvider.role == 'Doctor') {

      return Container(
            child: 
            FutureBuilder<List<DoctorInfoModel>>(
              future: authProvider.getDoctors(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("Error: ${snapshot.error}"),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty ?? true) {
                  return Center(
                    child: Text("No Doctors listed."),
                  );
                } else {
            
                  return ListView.builder(
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) {
                          return DoctorCard(doctorInfoModel: snapshot.data![index], showControles: true,);
                        },
                  );
                }
              },
            ),
          );
    } else if (authProvider.role == 'Patient') {
        return FutureBuilder<List<PatientInfoModel>>(
          future: authProvider.getPatients(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty ?? true) {
              return Center(
                child: Text("No Patient added."),
              );
            } else {
        
              return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      return PatientCard(patientInfoModel: snapshot.data![index]);
                    },
              );
            }
          },
        );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
      ),
      drawer: const DrawerWidget(),
      body: FutureBuilder(
          future: loadWidget(),
          builder: (BuildContext context, AsyncSnapshot<Widget> widget){
            if (!widget.hasData) {
             return Center(
               child: CircularProgressIndicator(),
             );
            }
            return widget.data!;
          },
        ),      
    );
  }
}


class DoctorCard extends StatefulWidget {
  final DoctorInfoModel doctorInfoModel;
  final bool showControles;
  const DoctorCard({Key? key, required this.doctorInfoModel, required this.showControles}) : super(key: key);

  @override
  State<DoctorCard> createState() => _DoctorCardState();
}

class _DoctorCardState extends State<DoctorCard> {

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: 
          Card(
      margin: EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      elevation: 5.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage: NetworkImage(widget.doctorInfoModel.profilePicId ), // Replace with your image asset path
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dr. ${widget.doctorInfoModel.name}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${widget.doctorInfoModel.specialization}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                if (widget.doctorInfoModel.currentStatus == 'Available')
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // green dot
                      Container(
                        height: 12,
                        width: 12,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Text(
                        '${widget.doctorInfoModel.currentStatus}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'at: ${authProvider.clinicsInfoModel.firstWhere((test) => test.id == widget.doctorInfoModel.clinicId).name}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            SizedBox(height: 8),
            Divider(color: Colors.grey),
            SizedBox(height: 8),
            if (widget.showControles)
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (authProvider.userModel.role == 'admin' || widget.doctorInfoModel.userId == authProvider.userModel.uid)
                TextButton(
                  onPressed: () {
                    // push context such that user have a back button to go back
                    Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditDoctorScreen(doctorInfoModel: widget.doctorInfoModel),
                                ),
                    );
                  },
                  child: Text(
                    'Edit Profile',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
                    ),
                  ),
                ),
                if (authProvider.userModel.role == 'Patient')
                TextButton(
                  onPressed: () {
                    // Add your booking action here
                    bookAppointment(context, widget.doctorInfoModel.id);
                  },
                  child: Text(
                    'Book Appointment',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
                    ),
                  ),
                ),
                if (authProvider.userModel.role == 'admin' || widget.doctorInfoModel.userId == authProvider.userModel.uid)
                TextButton(
                  onPressed: () {
                    // Add your booking action here
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditDoctorStatusScreen(doctorInfoModel: widget.doctorInfoModel),
                    ),
                  );
                  },
                  child: Text(
                    'Update Status',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
                    ),
                  ),
                ),
                if (authProvider.role == 'Doctor' && authProvider.doctorsInfoModel[authProvider.activeDoctorIndex].id == widget.doctorInfoModel.id)
                  // Showing that the doctor is active
                  Text(
                    'Active',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 14,
                    ),
                  )
                else if (authProvider.role == 'Doctor' && authProvider.doctorsInfoModel[authProvider.activeDoctorIndex].id != widget.doctorInfoModel.id)
                  TextButton(
                    onPressed: () {
                      // Add your booking action here
                      authProvider.setActiveDoctor(widget.doctorInfoModel.id);
                      // force redraw of this widget to show the active status
                      setState(() {});
                    },
                    child: Text(
                      'Make Active',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 14,
                      ),
                    ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    );
  }

    Future<void> bookAppointment(BuildContext context, String doctorId) async {

    final AuthProvider authProvider =
    Provider.of<AuthProvider>(context, listen: false);

    try {

      

      // check if there is already a pending booking with same patientId and doctorId 
      // if yes then show a message that you already have a pending booking
      // else create a new booking
      if (await authProvider.isBookingAlreadyExist(authProvider.patientsInfoModel[authProvider.activePatientIndex].id, doctorId, 'pending')) {
              showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
              title: Text('Already have a pending booking'),
              content: Text('Please wait for the doctor to accept the booking.'),
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
        return;
      }
      String id = await authProvider.getNewBookingId();
      // for now select the first patient as active patient
      // later we will add the logic to select the active patient
      // based on the user selection
      // For now select first doctor as active doctor 
      BookingModel booking = BookingModel(
        id: id, 
        patientId: authProvider.patientsInfoModel[authProvider.activePatientIndex].id, 
        appointmentDate: '', 
        appointmentTime: '', 
        appointmentStatus: 'pending', 
        paymentStatus: 'Not Paid', 
        doctorId: doctorId, 
        prescriptionId: '',
        timestamp: DateTime.fromMillisecondsSinceEpoch(0),
        tokenNumber: '',
        remark: '',
        );

      authProvider.saveBookingDataToFirebase(context: context, booking: booking, onSuccess: () {
        // show the message on the Global Snackbar
        // use the parent context here
        showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
              title: Text('Clinic informed about your booking'),
              content: Text('Please wait for the call from clinic.'),
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
        // Navigator.pop(context);
      });
    } catch (e) {
      print('Error booking appointment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error booking appointment. Please try again.'),
        ),
      );
    }
  }
}

class PatientCard extends StatelessWidget {
  final PatientInfoModel patientInfoModel;
  const PatientCard({Key? key, required this.patientInfoModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: 
       Card(
      margin: EdgeInsets.all(8.0),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      elevation: 5.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage: AssetImage('assets/images/doctor6.png'), // Replace with your image asset path
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${patientInfoModel.name}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '${patientInfoModel.gender}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            '${patientInfoModel.email}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            '${patientInfoModel.userId}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Divider(color: Colors.grey),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (patientInfoModel.userId == authProvider.userModel.uid)
                TextButton(
                  onPressed: () {
                    Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditPatientScreen(patientInfoModel: patientInfoModel),
                                ),
                    );
                  },
                  child: Text(
                    'Edit Profile',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
                    ),
                  ),
                ),
                if (patientInfoModel.userId == authProvider.userModel.uid)
                TextButton(
                  onPressed: () {
                    // Add your booking action here
                    // TODO select active patient 
                  },
                  child: Text(
                    'Select Active',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // TODO patient profile screen  
                    Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PatientDetailsScreen(patientInfoModel: patientInfoModel),
                                ),
                    );
                  },
                  child: Text(
                    'Info',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    ),
    );
  }
}

class PatientDetailsScreen extends StatelessWidget {
  final PatientInfoModel patientInfoModel;
  const PatientDetailsScreen({Key? key, required this.patientInfoModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    Future<List<BookingDetails>> getBookingForPatient (PatientInfoModel patientInfoModel) async {
      List<BookingDetails> bookings = await authProvider.getBookingDetailsByPatient(patientInfoModel, "pending", ""); 
      bookings.addAll(await authProvider.getBookingDetailsByPatient(patientInfoModel, "scheduled", ""));
      bookings.addAll(await authProvider.getBookingDetailsByPatient(patientInfoModel, "completed", ""));
      return bookings; 
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Details'),
        // back button
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${patientInfoModel.name}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Phone: ${patientInfoModel.userId ?? "N/A"}',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 10),
            Text(
              'Email: ${patientInfoModel.email ?? "N/A"}',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 10),
            Text(
              'Date of Birth: ${patientInfoModel.dob ?? "N/A"}',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 20),
            Text(
              'Bookings:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: FutureBuilder<List<BookingDetails>>(
                future: getBookingForPatient(patientInfoModel),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text("No bookings found."));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        final booking = snapshot.data![index];
                        return BookingCard(booking: booking);
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}