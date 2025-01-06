import 'package:neurocare/model/booking_model.dart';
import 'package:neurocare/model/user_model.dart';
import 'package:neurocare/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';
import '../widgets/custom_button.dart';
import 'package:dropdown_search/dropdown_search.dart';

class BookingScreen extends StatefulWidget {
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController pathologistController = TextEditingController();
  String selectedGender = 'Male'; // Default gender selection
  String selectedPaymentOption = 'Cash'; // Default payment option
  String selectedTime = '';
  List<String> availableTimings = [
    '09:00 AM',
    '10:00 AM',
    '11:00 AM',
    '01:00 PM',
    '02:00 PM',
    '03:00 PM',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Appointment'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // InkWell(
              //   onTap: () async {
              //     // TODO: Show calendar and update selected date
              //     DateTime? pickedDate = await showDatePicker(
              //       context: context,
              //       initialDate: DateTime.now(),
              //       firstDate: DateTime.now(),
              //       lastDate: DateTime.now().add(Duration(days: 30)),
              //     );

              //     if (pickedDate != null && pickedDate != DateTime.now()) {
              //       setState(() {
              //         dateController.text =
              //         "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
              //       });
              //     }
              //   },
              //   child: IgnorePointer(
              //     child: TextField(
              //       controller: dateController,
              //       readOnly: true,
              //       decoration: InputDecoration(
              //         labelText: 'Appointment Date',
              //         suffixIcon: Icon(Icons.calendar_today),
              //       ),
              //     ),
              //   ),
              // ),
              // SizedBox(height: 16),

              // SizedBox(height: 16),
              // Text('Select Time:',style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              // Add a grid of available timings
              // SizedBox(height: 5,),
              // GridView.builder(
              //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //     crossAxisCount: 3,
              //     mainAxisSpacing: 10.0,
              //     crossAxisSpacing: 10.0,
              //     childAspectRatio: 2.0,
              //   ),
              //   shrinkWrap: true,
              //   itemCount: availableTimings.length,
              //   itemBuilder: (context, index) {
              //     return ElevatedButton(
              //       onPressed: () {
              //         setState(() {
              //           selectedTime = availableTimings[index];
              //           timeController.text = selectedTime;
              //         });
              //       },
              //       style: ButtonStyle(
              //         backgroundColor: MaterialStateProperty.all(
              //           selectedTime == availableTimings[index]
              //               ? Color(0xFF3E69FE)
              //               : Colors.grey,
              //         ),
              //       ),
              //       child: Text(availableTimings[index]),
              //     );
              //   },
              // ),
              SizedBox(height: 20,),
              TextField(
                controller: pathologistController,
                decoration: InputDecoration(
                  labelText: 'Preferred Pathologist',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(12.0),
                ),
              ),
              SizedBox(height: 16),
              Text('Select Gender:'),
              DropdownButton<String>(
                value: selectedGender,
                onChanged: (value) {
                  setState(() {
                    selectedGender = value!;
                  });
                },
                items: ['Male', 'Female', 'Others'].map<DropdownMenuItem<String>>(
                      (String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  },
                ).toList(),
              ),
              SizedBox(height: 16),
              Text('Select Payment Option:'),
              DropdownButton<String>(
                value: selectedPaymentOption,
                onChanged: (value) {
                  setState(() {
                    selectedPaymentOption = value!;
                  });
                },
                items: ['Cash', 'Credit Card', 'Debit Card'].map<DropdownMenuItem<String>>(
                      (String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  },
                ).toList(),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  await bookAppointment(context);
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.all(16.0)),
                ),
                child: Text('Book Appointment'),
              ),
            ],
          ),
        ),
      ),
    );
  }

// create a booking edit screen


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
        appointmentDate: dateController.text.trim(), 
        appointmentTime: timeController.text.trim(), 
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
          content: Text('Error booking appointment. p try again.'),
        ),
      );
    }
  }

  String determineAppointmentStatus() {
    // TODO: Add logic to determine appointment status based on dates
    // For example, check if the selected date is within the next week
    // Return 'Pending' or 'Confirmed' accordingly
    return 'Pending';
  }

  String determinePaymentStatus() {
    // TODO: Add logic to determine payment status based on selected payment option
    // Return 'Paid' or 'Unpaid' accordingly
    return 'Unpaid';
  }
 
}

class BookingEditScreen extends StatefulWidget {

final BookingDetails apponintment;

  BookingEditScreen({
    required this.apponintment,
  });

  @override
  _BookingEditScreenState createState() => _BookingEditScreenState();
}

class _BookingEditScreenState extends State<BookingEditScreen> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  // final TextEditingController lastBooking = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  // String currentStatus = 'Pending'; // Default status selection
  static const List<String> statusList = <String>['Pending', 'Scheduled', 'Completed'];
  String currentStatus = statusList.first;
  final TextEditingController tokenController = TextEditingController();
  final TextEditingController remarkController = TextEditingController();
  @override
  void initState() {
    super.initState();
    dateController.text = widget.apponintment.bookingModel.appointmentDate;
    timeController.text = widget.apponintment.bookingModel.appointmentTime;
    statusController.text = widget.apponintment.bookingModel.appointmentStatus;
    currentStatus = statusList.firstWhere((test) => test.toLowerCase() == widget.apponintment.bookingModel.appointmentStatus);
    tokenController.text = widget.apponintment.bookingModel.tokenNumber;
    remarkController.text = widget.apponintment.bookingModel.remark;
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Appointment'),
        // back button
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Text('Patient Name: ${widget.apponintment.patient.name}' ),
              SizedBox(height: 16),
              Text('Patient Phone: ${  widget.apponintment.patient.userId}' ),
              SizedBox(height: 16),
              Text('Doctor Name: ${widget.apponintment.doctor.name}' ),
              InkWell(
                onTap: () async {
                  // TODO: Show calendar and update selected date
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 30)),
                  );

                  if (pickedDate != null && pickedDate != DateTime.now()) {
                    setState(() {
                      dateController.text = 
                          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                    });
                  }
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
              const Text('Select Status:'),
              // Expanded(
              //       child: DropdownSearch<String>(
              //         onChanged: (value) {
              //           setState(() {
              //             statusController.text = value!;
              //             currentStatus = value;
              //           });
              //         },
              //         items: ['Pending', 'Scheduled', 'Completed'],
              //         dropdownDecoratorProps: DropDownDecoratorProps(
              //           dropdownSearchDecoration: InputDecoration(
              //             labelText: "Select Status",
              //             hintText: "Select Status",
              //           ),
              //         ),
              //         popupProps: PopupProps.bottomSheet(
              //             bottomSheetProps: BottomSheetProps(elevation: 16, backgroundColor: Color(0xFFAADCEE))),
              //       ),
              // ),
              DropdownButton<String>(
                // controller: genderController,
                key: Key(widget.apponintment.bookingModel.id),
                value : currentStatus,
                icon: const Icon(Icons.sailing),
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),                
                onChanged: (value) {
                  setState(() {
                    statusController.text = value!.toLowerCase();
                    currentStatus = value!;
                  });
                },
                items: ['Pending', 'Scheduled', 'Completed'].map<DropdownMenuItem<String>>(
                      (String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  },
                ).toList(),
              ),
              SizedBox(height: 16),
              TextField(
                controller: tokenController,
                decoration: InputDecoration(
                  labelText: 'Token Number',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(12.0),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: remarkController,
                decoration: InputDecoration(
                  labelText: 'Remark',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(12.0),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.90,
                child: CustomButton(
                  text: "Save",
                  onPressed: () => editAppointment(context, widget.apponintment.bookingModel),
                ),
              )
            ],
          )
        ),
      ),
    );
  }

// create a booking edit screen


  Future<void> editAppointment(BuildContext context, BookingModel booking) async {
    final AuthProvider authProvider =
    Provider.of<AuthProvider>(context, listen: false);

    try {
      BookingModel updatedBooking = BookingModel(id: booking.id, 
      patientId: booking.patientId, 
      appointmentDate: dateController.text, 
      appointmentTime: timeController.text, 
      appointmentStatus: statusController.text.toLowerCase(), 
      paymentStatus: booking.paymentStatus, 
      doctorId: booking.doctorId, 
      prescriptionId: booking.prescriptionId, timestamp: booking.timestamp, tokenNumber: tokenController.text, remark: remarkController.text);

      authProvider.saveBookingDataToFirebase(context: context, booking: updatedBooking, onSuccess: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Appointment Updated successfully!'),
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
}
