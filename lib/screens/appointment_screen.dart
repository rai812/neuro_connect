import 'package:digi_diagnos/model/user_model.dart';
import 'package:digi_diagnos/screens/home.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';
import '../model/booking_model.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'booking.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../utils/utils.dart';
import 'user_info.dart';
import '../widgets/drawer.dart';
import 'package:dropdown_search/dropdown_search.dart';
import '../model/prescription_model.dart';
import 'package:ribbon_widget/ribbon_widget.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';



class AllBookingsScreen extends StatefulWidget {
  @override
  State<AllBookingsScreen> createState() => _AllBookingsScreenState();
}

class _AllBookingsScreenState extends State<AllBookingsScreen> {

  Future<List<BookingDetails>> getBookings() async {
    final AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    List<BookingDetails> bookings = await authProvider.getMyBookingDetails("pending", "");
    bookings.addAll(await authProvider.getMyBookingDetails("scheduled", ""));
    bookings.addAll(await authProvider.getMyBookingDetails("completed", ""));

    return bookings;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Bookings',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
        // Add a back button to the app bar
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      drawer: DrawerWidget(),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return FutureBuilder<List<BookingDetails>>(
            future: getBookings(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                return Center(child: Text('No bookings available.'));
                // return Center(
                //   child: Column(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //               SizedBox(height: 16),
                //               ElevatedButton(
                //                 onPressed: () async {
                //                   await bookAppointment(context);
                //                   Navigator.pop(context);
                //                 },
                //                 style: ButtonStyle(
                //                   padding: MaterialStateProperty.all(EdgeInsets.all(16.0)),
                //                 ),
                //                 child: Text('Book Appointment'),
                //               ),
                //     ],
                //   ),
                // );
              } else {
                List<BookingDetails> bookings = snapshot.data!;
                return ListView.builder(
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    return BookingCard(booking: bookings[index]);
                  },
                );
              }
            },
          );
        },
      ),
    );
  }
}

class BookingDetailScreen extends StatelessWidget {
  final BookingDetails booking;
  const BookingDetailScreen({Key? key, required this.booking}) : super(key: key);

  String GetPunchline(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Your appointment is pending';
      case 'scheduled':
        return 'Confirmed for your appointment';
      case 'completed':
        return 'Delighted to serve you';
      default:
        return 'Your appointment is pending';
    }
  }

  @override
  Widget build(BuildContext context) {
    // create a new DateTime object from appointment date and appintment time
    //
    //
    DateTime appointmentTime = DateFormat('dd/mm/yyyy hh:mm').parse("${booking.bookingModel.appointmentDate} ${booking.bookingModel.appointmentTime}");
    return Scaffold(
      appBar: AppBar(
        // title: Text('Booking Details'),
        // back button to go back to the all bookings screen
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (authProvider.isLoading)
                    Center(child: CircularProgressIndicator())
                  else if (authProvider.isSignedIn)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/appointment_scheduled.png', width: 300, height: 300),
                        // CircleAvatar(
                        //   radius: 50,
                        //   backgroundImage: NetworkImage(authProvider.userModel.profilePic as String),
                        // ),
                        SizedBox(height: 20),
                        Text(
                          '${booking.patient.name}, we have got you covered!',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "${GetPunchline(booking.bookingModel.appointmentStatus)}",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "${DateFormat('h:mm a').format(appointmentTime)}",
                          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),                        
                        Text(
                          'Dr. ${booking.doctor.name}',
                          style: TextStyle(fontSize: 18,  color: Colors.black54),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "${DateFormat('EEEE, d MMM, yyyy').format(appointmentTime)}",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "${authProvider.clinicsInfoModel[0].name}",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Token Number: ${booking.bookingModel.tokenNumber}",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                        if (booking.bookingModel.remark.isNotEmpty && ( authProvider.userModel.role == 'admin' || authProvider.userModel.role == 'Doctor'))
                          Text(
                            "Remark: ${booking.bookingModel.remark}",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14, color: Colors.black54),
                          ),
                        // SizedBox(height: 10),
                        // Text(
                        //   'Appointment Time: ${booking.bookingModel.appointmentTime}',
                        //   style: TextStyle(fontSize: 16, color: Colors.grey),
                        // ),
                        // Add more user details here
                        SizedBox(height: 20),
                        // if the prescription id is not empty, show the prescription details
                        if (booking.bookingModel.prescriptionId.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Diagnosis: ${booking.prescription.diagnosisList.toString()}',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10),
                              // Add the prescription details here
                              Text(
                                'Remark: ${booking.prescription.remarks}',
                                style: TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                              SizedBox(height: 10),
                              if (booking.prescription.fileId.isNotEmpty)
                                ElevatedButton(
                                  onPressed: () async {
                                    // Add logic to view the prescription file
                                    // download the file from network
                                    String fileUrl = booking.prescription.fileId; // Replace with the actual file URL
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SaveFileScreen(fileUrl: fileUrl),
                                      ),
                                    );

                                    // Open the downloaded file
                                    // OpenFile.open(savePath);
                                  },
                                  child: Text('Download Prescription'),
                                ),
                              SizedBox(height: 10),
                              if (booking.prescription.reportFileId.isNotEmpty)
                                ElevatedButton(
                                  onPressed: () async {
                                    // Add logic to view the prescription file
                                    // download the file from network
                                    String fileUrl = booking.prescription.reportFileId; // Replace with the actual file URL
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SaveFileScreen(fileUrl: fileUrl),
                                      ),
                                    );

                                    // Open the downloaded file
                                    // OpenFile.open(savePath);
                                  },
                                  child: Text('Download Report'),
                                ),  
                            ],
                          ),
                      ],
                    ),
                    // if user is admin then add a floating action button to add prescription
                    // if (authProvider.userModel.role == 'admin')
                    //   FloatingActionButton(
                    //     onPressed: () {
                    //       showModalBottomSheet(
                    //         context: context,
                    //         builder: (context) {
                    //           return FeedbackForm(booking: booking.bookingModel);
                    //         },
                    //       );
                    //     },
                    //     child: Icon(Icons.add),
                    //   ),
                  
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class SaveFileScreen extends StatefulWidget {
  String fileUrl;
  SaveFileScreen({required this.fileUrl});
  @override
  _SaveFileScreenState createState() => _SaveFileScreenState();
}

class _SaveFileScreenState extends State<SaveFileScreen> {
  String? selectedDirectory;

  Future<void> _pickFolder() async {
    String? directory = await FilePicker.platform.getDirectoryPath();

    if (directory != null) {
      setState(() {
        selectedDirectory = directory;
      });
      // You can now use the selected directory path to save files
      print("Selected directory: $selectedDirectory");
    } else {
      // User canceled the picker
      print("Directory selection was canceled.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Save File Before Downloading'),
        // back button to go back to the booking details screen
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _pickFolder,
              child: Text('Choose Folder to Save File'),
            ),
            SizedBox(height: 20),
            if (selectedDirectory != null)
              Text(
                'Selected Directory: $selectedDirectory',
                textAlign: TextAlign.center,
              ),
              ElevatedButton(
                  onPressed: () async {
                    // Add logic to view the prescription file
                    // download the file from network
                    if (selectedDirectory == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please select a directory to save the file')),
                      );
                      return;
                    }
                    String fileUrl = widget.fileUrl; // Replace with the actual file URL
                    // extract the filename from the fileUrl using path package or any other method
                    String fileName = fileUrl.split('/').last;
                    // now filename will have option parameters, so remove them
                    fileName = fileName.split('?')[0];

                    // Use the dio package to download the file
                    Dio dio = Dio();
                    // get folder path from user via file picker

                    String savePath = selectedDirectory! + '/$fileName';
                    await dio.download(fileUrl, savePath);

                    // Show a snackbar to indicate the download completion
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('File downloaded successfully')),
                    );
                    Navigator.pop(context);
                    // Open the downloaded file
                    // OpenFile.open(savePath);
                  },
                  child: Text('Download Prescription'),
                  
                ),

          ],
        ),
      ),
    );
  }
}


class BookingCard extends StatelessWidget {
  final BookingDetails booking;
  const BookingCard({Key? key, required this.booking}) : super(key: key);

  Color getRibbonColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.red;
      case 'scheduled':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      // on click go to the booking details screen
      child: Ribbon(
        color: getRibbonColor(booking.bookingModel.appointmentStatus),
        title: booking.bookingModel.appointmentStatus,
        titleStyle: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
        location: RibbonLocation.bottomEnd,
        nearLength: 70.0,
        farLength: 120.0,
        child: Card(
          margin: EdgeInsets.all(8.0),
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Doctor: ${booking.doctor.name}',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Image.asset(
                        'assets/images/appointment.png', // Replace with the actual image asset path
                        width: 80.0,
                        height: 80.0,
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Appointment Date:',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${booking.bookingModel.appointmentDate}',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3E69FE),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Appointment Time:',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${booking.bookingModel.appointmentTime}',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3E69FE),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Status: ${booking.bookingModel.appointmentStatus}',
                    style: TextStyle(fontSize: 14.0),
                  ),
                  Text(
                    'Patient name: ${booking.patient.name}',
                    style: TextStyle(fontSize: 14.0),
                  ),
                  Text(
                    'Patient phone: ${booking.patient.userId}',
                    style: TextStyle(fontSize: 14.0),
                  ),
                  SizedBox(height: 16.0),
                  Container(
                    height: 1.0,
                    width: double.infinity,
                    color: Colors.white, // Adjust the color as needed
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                        // add a detail button to view the booking details
                        if (booking.bookingModel.appointmentStatus != 'pending')
                        IconButton(
                          icon: Icon(Icons.info),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookingDetailScreen(booking: booking),
                              ),
                            );
                          },
                          color: Color(0xFF3E69FE),
                        ),
                        if (authProvider.userModel.role == 'admin' && booking.bookingModel.appointmentStatus != 'completed')
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                // go to the edit screen
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BookingEditScreen(apponintment: booking),
                                  ),
                                );
                              },
                              color: Color(0xFF3E69FE),
                            ),
                        if (authProvider.userModel.role == 'admin' && booking.bookingModel.appointmentStatus == 'completed')
                            IconButton(
                              icon: Icon(Icons.add_alert_outlined),
                              onPressed: () {
                                // go to the edit screen
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PrescriptionFormScreen(booking: booking),
                                  ),
                                );
                              },
                              color: Color(0xFF3E69FE),
                            ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Delete Booking'),
                                    content: Text('Are you sure you want to delete this booking?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          await authProvider.deleteBooking(booking.bookingModel.id);
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Delete'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// create a new screen for addind a new booking for the doctor who can select the existing patient
class NewBookingScreen extends StatefulWidget {
  @override
  State<NewBookingScreen> createState() => _NewBookingScreenState();
}

class _NewBookingScreenState extends State<NewBookingScreen> {

  DateTime? _selectedDate = DateTime.now();
  TimeOfDay? _selectedTime = TimeOfDay.now();
  String _selectedPatient = '';
  String _selectedDoctor = '';
  String _selectedStatus = 'Pending';
  String _selectedPaymentStatus = 'Not Paid';
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController tokenController = TextEditingController();
  final TextEditingController reffereController = TextEditingController();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        dateController.text = '${picked.day}/${picked.month}/${picked.year}';
        _selectedDate = picked;
      });
  }

  DateTime getTimeStamp(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  Widget _customPopupItemBuilderDoctor(BuildContext context, DoctorInfoModel item, bool isSelected) {
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
        subtitle: Text(item.specialization.toString()),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(item.profilePicId),
        ),
      ),
    );
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
        leading: CircleAvatar(
          backgroundImage: AssetImage('assets/images/doctor6.png'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Booking'),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // change the DropdownButton to searchable dropdown
                  Expanded(
                    child: DropdownSearch<DoctorInfoModel>(
                      asyncItems: (filter) => authProvider.getDoctorByName(filter),
                      compareFn: (i, s) => i.id == s.id,
                      onChanged: (DoctorInfoModel? newValue) {
                        setState(() {
                          _selectedDoctor = newValue!.id;
                        });
                      },
                      popupProps: PopupPropsMultiSelection.modalBottomSheet(
                        isFilterOnline: true,
                        showSelectedItems: true,
                        showSearchBox: true,
                        itemBuilder: _customPopupItemBuilderDoctor,
                        // favoriteItemProps: FavoriteItemProps(
                        //   showFavoriteItems: true,
                        //   favoriteItems: (us) {
                        //     return us.where((e) => e.name.contains("Mrs")).toList();
                        //   },
                        // ),
                      ),
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          labelText: "Doctor",
                          hintText: "Choose a Doctor",
                        ),
                      ),
                    ),
                  ),
                // DropdownButton<String>(
                //   value: _selectedDoctor,
                //   onChanged: (String? newValue) {
                //     setState(() {
                //       _selectedDoctor = newValue!;
                //     });
                //   },
                //   items: authProvider.doctors.map<DropdownMenuItem<String>>((DoctorInfoModel value) {
                //     return DropdownMenuItem<String>(
                //       value: value.id,
                //       child: Text(value.name),
                //     );
                //   }).toList(),
                // ),
                  Expanded(
                    child: DropdownSearch<PatientInfoModel>(
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
                        // favoriteItemProps: FavoriteItemProps(
                        //   showFavoriteItems: true,
                        //   favoriteItems: (us) {
                        //     return us.where((e) => e.name.contains("Mrs")).toList();
                        //   },
                        // ),
                      ),
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          labelText: "Patient",
                          hintText: "Choose a Patient",
                        ),
                      ),
                    ),
                  ),
                // DropdownButton<String>(
                //   value: _selectedPatient,
                //   onChanged: (String? newValue) {
                //     setState(() {
                //       _selectedPatient = newValue!;
                //     });
                //   },
                //   items: authProvider.patients.map<DropdownMenuItem<String>>((PatientInfoModel value) {
                //     return DropdownMenuItem<String>(
                //       value: value.id,
                //       child: Text(" ${value.userId} :  ${value.name}"),
                //     );
                //   }).toList(),
                // ),
                InkWell(
                  onTap: () async {
                    await _selectDate(context);
                  },
                  child: IgnorePointer(
                    child: TextField(
                      controller: dateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Appointment Date',
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text("Selected Date: ${dateController.text}"),
                InkWell(
                  onTap: () async {
                    // TODO: Show calendar and update selected date
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute),
                      // firstDate: DateTime.now(),
                      // lastDate: DateTime.now().add(Duration(days: 30)),
                    );

                    if (pickedTime != null) {
                      setState(() {
                        timeController.text = pickedTime.format(context);
                        _selectedTime = pickedTime;
                      });
                    }
                  },
                  child: IgnorePointer(
                    child: TextField(
                      controller: timeController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Appointment Time',
                        suffixIcon: Icon(Icons.punch_clock_sharp),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text("Token Number"),
                TextField(
                  controller: tokenController,
                  decoration: InputDecoration(
                    labelText: 'Token Number',
                    hintText: 'Enter Token Number',
                  ),
                ),
                SizedBox(height: 16),
                Text("Reffered By"),
                TextField(
                  controller: reffereController,
                  decoration: InputDecoration(
                    labelText: 'Reffered By',
                    hintText: 'Enter Reffered By',
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    String id = await authProvider.getNewBookingId();
                    BookingModel booking = BookingModel(
                      id: id,
                      patientId: _selectedPatient,
                      appointmentDate: dateController.text,
                      appointmentTime: timeController.text,
                      appointmentStatus: 'scheduled',
                      paymentStatus: 'Not Paid',
                      doctorId: _selectedDoctor,
                      prescriptionId: '',
                      timestamp: getTimeStamp(_selectedDate!, _selectedTime!),
                      tokenNumber: tokenController.text,
                      remark: reffereController.text,
                    );

                    authProvider.saveBookingDataToFirebase(context: context, booking: booking, onSuccess: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Booking added successfully!'),
                        ),
                      );
                      Navigator.pop(context);
                    });
                  },
                  child: Text('Add Booking'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class PrescriptionFormScreen extends StatefulWidget {
  const PrescriptionFormScreen({super.key, required this.booking});
  final BookingDetails booking;
  @override
  State<PrescriptionFormScreen> createState() => _PrescriptionFormScreen();
}

class _PrescriptionFormScreen extends State<PrescriptionFormScreen>  {
  
  File? prescription;
  File? report;
  final remakrkController = TextEditingController();
  final diagnosisController = TextEditingController();
  @override
  void initState() {
    super.initState();
    remakrkController.text = 'Any Remarks';
    diagnosisController.text = 'Commans Seperated Diagnosis';
  }

  @override
  void dispose() {
    super.dispose();
    remakrkController.dispose();
    diagnosisController.dispose();
  }

    // for selecting image
  void selectImage() async {
    prescription = await pickImage(context);
    setState(() {});
  }

  void selectReport() async {
    report = await pickDocument(context);
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    double rating = 0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Prescription'),
        // back button to go back to the booking details screen
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      
      body:
    Center(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => selectImage(),
              child: Row(
                children: [
                  Icon(Icons.add_a_photo),
                  SizedBox(width: 8.0),
                  Text('Add Prescription Image'),
                ],
              ),
              
            ),
            SizedBox(height: 16.0), 
            InkWell(
              onTap: () => selectReport(),
              child: Row(
                children: [
                  Icon(Icons.add_a_photo),
                  SizedBox(width: 8.0),
                  Text('Add Report'),
                ],
              ),
              
            ),
            SizedBox(height: 16.0), 
            textFeld(
            label: 'Diagnosis',
            hintText: diagnosisController.text,
            icon: Icons.medical_services,
            inputType: TextInputType.name,
            maxLines: 3,
            controller: diagnosisController,
          ),
          SizedBox(height: 16.0),
            textFeld(
            label: 'Remarks',
            hintText: remakrkController.text,
            icon: Icons.medical_services,
            inputType: TextInputType.name,
            maxLines: 3,
            controller: remakrkController,
          ),
            SizedBox(height: 16.0),
            // Add a TextField for entering feedback
            ElevatedButton(
              onPressed: () async{
                // Add logic to submit the feedback and rating
                var diagnosis = diagnosisController.text.split(',');
                if (diagnosis.length < 1 || diagnosis[0] == 'Commans Seperated Diagnosis') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter diagnosis'),
                    ),
                  );
                  return;
                }
                var remark = remakrkController.text;
                if (remark == 'Any Remarks') {
                  remark = '';
                }
                // ...
                final AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
                String id = await authProvider.getNewPrescriptionId();
                PrescriptionModel prescriptionModel = PrescriptionModel(
                  id: id,
                  fileId: '',
                  diagnosisList: diagnosis,
                  remarks: remakrkController.text,
                  reportFileId: '',
                );
                authProvider.savePrescriptionDataToFirebase(context: context, prescriptionModel: prescriptionModel, prescriptionFile: prescription, reportFile: report, onSuccess: () {
                  // check if context is valid 
                 if (context != null) { 
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Prescription added successfully!'),
                    ),
                  );
                  Navigator.pop(context);
                }
                }, bookingDetails: widget.booking);
                // Close the modal bottom sheet
                // Navigator.of(context).pop();
              },
              // style: ElevatedButton.styleFrom(foregroundColor: Color(0xFF3E69FE)),
              child: Text(
                'Save Prescription',
                // style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}

class FeedbackForm extends StatelessWidget {
  final BookingModel booking;

  const FeedbackForm({Key? key, required this.booking}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double rating = 0;

    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Review Appointment',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.0),
          // Add a TextField for entering feedback
          TextField(
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Feedback',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16.0),
          // Add a RatingBar for rating the appointment
          RatingBar.builder(
            initialRating: rating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemSize: 30.0,
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (value) {
              rating = value;
            },
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              // Add logic to submit the feedback and rating
              // ...

              // Close the modal bottom sheet
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(foregroundColor: Color(0xFF3E69FE)),
            child: Text(
              'Submit Review',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

    Future<void> bookAppointment(BuildContext context) async {
    final AuthProvider authProvider =
    Provider.of<AuthProvider>(context, listen: false);

    try {

      String id = await authProvider.getNewBookingId();
      // for now select the first patient as active patient
      // later we will add the logic to select the active patient
      // based on the user selection
      // For now select first doctor as active doctor 
      BookingModel booking = BookingModel(
        id: id, 
        patientId: authProvider.patientsInfoModel[0].id, 
        appointmentDate: '', 
        appointmentTime: '', 
        appointmentStatus: 'pending', 
        paymentStatus: 'Not Paid', 
        doctorId: authProvider.doctorsInfoModel[0].id, 
        prescriptionId: '',
        timestamp: DateTime.fromMillisecondsSinceEpoch(0),
        tokenNumber: '',
        remark: '',
        );

      authProvider.saveBookingDataToFirebase(context: context, booking: booking, onSuccess: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Appointment requested successfully!'),
          ),
        );
        Navigator.pop(context);
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
