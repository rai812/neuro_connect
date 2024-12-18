import 'package:digi_diagnos/model/booking_model.dart';
import 'package:digi_diagnos/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:ribbon_widget/ribbon_widget.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';
import '../widgets/custom_button.dart';

// generate new pending help request 
Future<void> triggerHelp(BuildContext context) async {
    final AuthProvider authProvider =
    Provider.of<AuthProvider>(context, listen: false);

    try {

      String id = await authProvider.getNewHelpId();

      HelpModel help = HelpModel(
        id: id, 
        patientId: authProvider.patientsInfoModel[authProvider.activePatientIndex].id, 
        title: 'Help Needed', 
        description: 'Help Needed', 
        timestamp: DateTime.now(), 
        closingTimestamp: DateTime.fromMillisecondsSinceEpoch(0), 
        status: 'Pending',
        );

      authProvider.saveHelpDataToFirebase(context: context, help: help, onSuccess: () {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Appointment requested successfully!'),
        //   ),
        // );
        // Navigator.pop(context);
      });
    } catch (e) {
      print('Error booking appointment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error Sending help. Please try again.'),
        ),
      );
    }
}

// help edit screen for HelpModel
class HelpEditScreen extends StatefulWidget {
  final HelpModel helpModel;
  HelpEditScreen({required this.helpModel});

  @override
  _HelpEditScreenState createState() => _HelpEditScreenState();
}

class _HelpEditScreenState extends State<HelpEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late String patientName;

  @override
  void initState() {
    _titleController = TextEditingController(text: widget.helpModel.title);
    _descriptionController = TextEditingController(text: widget.helpModel.description);
    PatientInfoModel patientInfo = Provider.of<AuthProvider>(context, listen: false).patients.firstWhere((patient) => patient.id == widget.helpModel.patientId);
    patientName = patientInfo.name;
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Help Status'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // get the Patient name from the patientId
              Text(patientName),
              SizedBox(height: 16),
              // Text Form field for title 
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              // Text Form field for description
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              CustomButton(
                text: 'Close Help Request',
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final helpModel = HelpModel(
                      id: widget.helpModel.id,
                      patientId: widget.helpModel.patientId,
                      title: _titleController.text,
                      description: _descriptionController.text,
                      timestamp: widget.helpModel.timestamp,
                      closingTimestamp:  DateTime.now(), 
                      status: "Completed",
                    );
                    
                    authProvider.saveHelpDataToFirebase(context: context, help: helpModel, onSuccess: (){
                      Navigator.pop(context);
                    });
                    
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HelpCard extends StatelessWidget {
  final HelpModel help;
  const HelpCard({Key? key, required this.help}) : super(key: key);

  Color getRibbonColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.red;
      case 'completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    String patientName = authProvider.patientsInfoModel.firstWhere((patient) => patient.id == help.patientId).name;
    String patientNumber = authProvider.patientsInfoModel.firstWhere((patient) => patient.id == help.patientId).userId;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      // on click go to the help details screen
      child: Ribbon(
        color: getRibbonColor(help.status),
        title: help.status,
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
                  Text(
                    'Patient name: ${patientName}',
                    style: TextStyle(fontSize: 14.0),
                  ),
                  Text(
                    'Patient phone: ${patientNumber}',
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
                        // add a detail button to view the help details
                        if (authProvider.userModel.role == 'admin' && help.status != 'completed')
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                // go to the edit screen
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HelpEditScreen(helpModel: help),
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
                                    title: Text('Delete Help Request'),
                                    content: Text('Are you sure you want to delete this help?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          await authProvider.deleteHelpRequest(help.id);
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
