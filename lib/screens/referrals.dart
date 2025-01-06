import 'package:neurocare/model/booking_model.dart';
import 'package:neurocare/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:ribbon_widget/ribbon_widget.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';
import '../screens/user_info.dart';
import 'package:dropdown_search/dropdown_search.dart';

class ReferralList extends StatefulWidget {
  @override
  _ReferralListState createState() => _ReferralListState();
}

class _ReferralListState extends State<ReferralList> {
  DateTime? _selectedFromDate = DateTime.now();
  DateTime? _selectedToDate = DateTime.now();
  String _selectedPatient = '';
  final TextEditingController toDateController = TextEditingController();
  final TextEditingController fromDateController = TextEditingController();

  Future<void> _selectDate(BuildContext context, bool toDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: toDate ? _selectedToDate : _selectedFromDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != (toDate ? _selectedToDate : _selectedFromDate)) {
      setState(() {
        if (toDate) {
          _selectedToDate = picked;
          toDateController.text = picked.toLocal().toString().split(' ')[0];
        } else {
          _selectedFromDate = picked;
          fromDateController.text = picked.toLocal().toString().split(' ')[0];
        }
      });
    }
  }

  DateTime getTimeStamp(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
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

    Future<List<ReferralModel>> getReferrals() async {
      if (authProvider.userModel.role == 'admin' || authProvider.userModel.role == 'Doctor') {
        if (_selectedPatient.isNotEmpty && _selectedFromDate != null && _selectedToDate != null) {
          return await authProvider.getReferralsByUserInDateRange(_selectedPatient, _selectedFromDate, _selectedToDate);
        } else if (_selectedPatient.isNotEmpty) {
          return await authProvider.getAllReferralsByUser(_selectedPatient);
        }
        return await authProvider.getAllReferrals();
      } else {
        return await authProvider.getAllReferralsByUser(authProvider.userModel.uid);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Referrals'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Referrals",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(179, 80, 105, 248),
                  ),
                ),
                const SizedBox(height: 10),
                if (authProvider.userModel.role == 'admin')
                  Column(
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
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () async {
                          await _selectDate(context, false);
                        },
                        child: IgnorePointer(
                          child: TextField(
                            controller: fromDateController,
                            readOnly: true,
                            decoration: const InputDecoration(
                              labelText: 'From Date',
                              suffixIcon: Icon(Icons.calendar_today),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      InkWell(
                        onTap: () async {
                          await _selectDate(context, true);
                        },
                        child: IgnorePointer(
                          child: TextField(
                            controller: toDateController,
                            readOnly: true,
                            decoration: const InputDecoration(
                              labelText: 'To Date',
                              suffixIcon: Icon(Icons.calendar_today),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                const SizedBox(height: 5),
                FutureBuilder<List<ReferralModel>>(
                  future: getReferrals(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text("Error: ${snapshot.error}"),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text("No Pending Help request."),
                      );
                    } else {
                      List<ReferralModel> referrals = snapshot.data!;
                      return Column(
                        children: referrals.map((referral) => ReferralCard(referral: referral)).toList(),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddReferralForm(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ReferralEditScreen extends StatefulWidget {
  final ReferralModel referral;
  const ReferralEditScreen({super.key, required this.referral});

  @override
  _ReferralEditScreenState createState() => _ReferralEditScreenState();
}

class _ReferralEditScreenState extends State<ReferralEditScreen> {
  final _formKey = GlobalKey<FormState>();
  String _patientName = '';
  String _patientMobileNumber = '';
  String _referrerName = '';

  void _submitForm(context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userModel = authProvider.userModel;
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await authProvider.getPatientByMobile(_patientMobileNumber).then((patient) async {
        String referralId = await authProvider.getNewReferralId();
        if (patient != null) {
          ReferralModel referral = ReferralModel(
            id: referralId,
            referrerId: userModel.uid,
            patientMobileId: _patientMobileNumber,
            patientName: _patientName,
            status: 'rejected',
            timestamp: DateTime.now(),
          );

          authProvider.saveReferralDataToFirebase(
            context: context,
            referral: referral,
            onSuccess: () {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Referral Rejected as patient already exists'),
                  ),
                );
              }
            },
          );
        } else {
          AdminAddPatientScreen patientScreen = AdminAddPatientScreen();
          await Navigator.push(context, MaterialPageRoute(builder: (context) => patientScreen));
          final patient = await authProvider.getPatientByMobile(_patientMobileNumber);

          if (patient != null) {
            ReferralModel referral = ReferralModel(
              id: referralId,
              referrerId: userModel.uid,
              patientMobileId: _patientMobileNumber,
              patientName: _patientName,
              status: 'completed',
              timestamp: DateTime.now(),
            );
            authProvider.saveReferralDataToFirebase(
              context: context,
              referral: referral,
              onSuccess: () {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Referral added successfully'),
                    ),
                  );
                }
              },
            );
          } else {
            ReferralModel referral = ReferralModel(
              id: referralId,
              referrerId: userModel.uid,
              patientMobileId: _patientMobileNumber,
              patientName: _patientName,
              status: 'rejected',
              timestamp: DateTime.now(),
            );
            authProvider.saveReferralDataToFirebase(
              context: context,
              referral: referral,
              onSuccess: () {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Referral added successfully'),
                    ),
                  );
                }
              },
            );
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Referral'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Patient Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the patient name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _patientName = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Patient Mobile Number'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the patient mobile number';
                  }
                  if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                    return 'Please enter a valid 10-digit mobile number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _patientMobileNumber = value!;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _submitForm(context);
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddReferralForm extends StatefulWidget {
  @override
  _AddReferralFormState createState() => _AddReferralFormState();
}

class _AddReferralFormState extends State<AddReferralForm> {
  final _formKey = GlobalKey<FormState>();
  String _patientName = '';
  String _patientMobileNumber = '';
  String _referrerName = '';

  void _submitForm(context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userModel = authProvider.userModel;
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await authProvider.getPatientByMobile(_patientMobileNumber).then((patient) async {
        String referralId = await authProvider.getNewReferralId();
        if (patient != null) {
          ReferralModel referral = ReferralModel(
            id: referralId,
            referrerId: userModel.uid,
            patientMobileId: _patientMobileNumber,
            patientName: _patientName,
            status: 'rejected',
            timestamp: DateTime.now(),
          );

          authProvider.saveReferralDataToFirebase(
            context: context,
            referral: referral,
            onSuccess: () {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Referral Rejected as patient already exists'),
                  ),
                );
              }
            },
          );
        } else {
          ReferralModel referral = ReferralModel(
            id: referralId,
            referrerId: userModel.uid,
            patientMobileId: _patientMobileNumber,
            patientName: _patientName,
            status: 'pending',
            timestamp: DateTime.now(),
          );
          authProvider.saveReferralDataToFirebase(
            context: context,
            referral: referral,
            onSuccess: () {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Referral added successfully'),
                  ),
                );
              }
            },
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Referral'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Patient Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the patient name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _patientName = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Patient Mobile Number'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the patient mobile number';
                  }
                  if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                    return 'Please enter a valid 10-digit mobile number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _patientMobileNumber = value!;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _submitForm(context);
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReferralCard extends StatelessWidget {
  final ReferralModel referral;
  const ReferralCard({super.key, required this.referral});

  Color getRibbonColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'rejected':
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Ribbon(
        color: getRibbonColor(referral.status),
        title: referral.status,
        titleStyle: const TextStyle(
          color: Colors.white,
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
        location: RibbonLocation.bottomEnd,
        nearLength: 70.0,
        farLength: 120.0,
        child: Card(
          margin: const EdgeInsets.all(8.0),
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
                    'Patient name: ${referral.patientName}',
                    style: const TextStyle(fontSize: 14.0),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Patient phone: ${referral.patientMobileId}',
                    style: const TextStyle(fontSize: 14.0),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Referred By: ${referral.referrerId}',
                    style: const TextStyle(fontSize: 14.0),
                  ),
                  Container(
                    height: 1.0,
                    width: double.infinity,
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (authProvider.userModel.role == 'admin' && referral.status == 'pending')
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReferralEditScreen(referral: referral),
                              ),
                            );
                          },
                          color: const Color(0xFF3E69FE),
                        ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Delete Refferal'),
                                content: const Text('Are you sure you want to delete this referral?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await authProvider.deleteReferral(referral.id);
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Delete'),
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
            ),
          ),
        ),
      ),
    );
  }
}