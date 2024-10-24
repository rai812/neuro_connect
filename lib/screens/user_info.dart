// import 'dart:ffi';
import 'dart:io';

import 'package:digi_diagnos/screens/nav_route.dart';
import 'package:flutter/material.dart';
import '../model/user_model.dart';
import '../provider/auth_provider.dart';
import '../utils/utils.dart';
import '../widgets/custom_button.dart';
import 'package:provider/provider.dart';
// import 'package:image_picker/image_picker.dart';

  Widget textFeld({
    required String label,
    required String hintText,
    required IconData icon,
    required TextInputType inputType,
    required int maxLines,
    required TextEditingController controller,
    bool disabled = false
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        // handle the case when user click on field the existing text should be selected 
        onTap: () {
          controller.selection = TextSelection(
            baseOffset: 0,
            extentOffset: controller.value.text.length,
          );
        },

        cursorColor: Color(0xFF3E69FE),
        controller: controller,
        keyboardType: inputType,
        maxLines: maxLines,
        readOnly: disabled,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Container(
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Color.fromARGB(255, 243, 243, 245),
            ),
            child: Icon(
              icon,
              size: 20,
              color: const Color.fromARGB(255, 20, 20, 20),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
          hintText: hintText,
          alignLabelWithHint: true,
          border: InputBorder.none,
          fillColor: Color.fromARGB(255, 242, 242, 245),
          filled: true,
        ),
      ),
    );
  }

class AdminAddDoctorScreen extends StatefulWidget {
  const AdminAddDoctorScreen({super.key});

  @override
  State<AdminAddDoctorScreen> createState() => _AdminAddDoctorScreenState();
}

class _AdminAddDoctorScreenState extends State<AdminAddDoctorScreen> {
  final phoneController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final genderController = TextEditingController();
  String selectedGender = 'Male'; // Default
  File? image;
  final bioController = TextEditingController();
  final specilizationController = TextEditingController();
  final experienceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    phoneController.text = 'Doctor Phone';
    nameController.text = 'Doctor Name';
    emailController.text = 'Doctor Email';
    genderController.text = 'Male';
    bioController.text = 'Doctor Bio';
    specilizationController.text = 'Doctor Specilization';
    experienceController.text = 'Doctor Experience';
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    genderController.dispose();
    bioController.dispose();
    specilizationController.dispose();
    experienceController.dispose();
    phoneController.dispose();
  }

    // for selecting image
  void selectImage() async {
    image = await pickImage(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: true);
    final isLoading = authProvider.isLoading;
        // Provider.of<AuthProvider>(context, listen: true).isLoading;
    return Scaffold(
      body: SafeArea(
        child: isLoading == true
            ? const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF3E69FE),
          ),
        )
            : SingleChildScrollView(
          padding:
          const EdgeInsets.symmetric(vertical: 25.0, horizontal: 5.0),
          child: Center(
            child: Column(
              children: [
                InkWell(
                  onTap: () => selectImage(),
                  child: image == null
                      ? const CircleAvatar(
                    backgroundColor: Color(0xFF3E69FE),
                    radius: 50,
                    child: Icon(
                      Icons.account_circle,
                      size: 50,
                      color: Colors.white,
                    ),
                  )
                      : CircleAvatar(
                    backgroundImage: FileImage(image!),
                    radius: 50,
                  ),
                ),                
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(
                      vertical: 5, horizontal: 15),
                  margin: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      // name field
                      textFeld(
                        label: 'Name',
                        hintText: nameController.text,
                        icon: Icons.account_circle,
                        inputType: TextInputType.name,
                        maxLines: 1,
                        controller: nameController,
                      ),

                      // email
                      textFeld(
                        label: 'Email',
                        hintText: emailController.text,
                        icon: Icons.email,
                        inputType: TextInputType.emailAddress,
                        maxLines: 1,
                        controller: emailController,
                      ),
                      // email
                      textFeld(
                        label: 'Phone',
                        hintText: phoneController.text,
                        icon: Icons.email,
                        inputType: TextInputType.phone,
                        maxLines: 1,
                        controller: phoneController,
                      ),

                      SizedBox(height: 16),
                      const Text('Select Gender:'),
                      DropdownButton<String>(
                        // controller: genderController,
                        value : selectedGender,
                        onChanged: (value) {
                          setState(() {
                            genderController.text = value!;
                            selectedGender = value;
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
                      textFeld(
                          label: 'Specialization',
                          hintText: 'Your Specilization',
                          icon: Icons.edit,
                          inputType: TextInputType.name,
                          maxLines: 3,
                          controller: specilizationController,
                        ),
                      textFeld(
                          label: 'Experience',
                          hintText: 'Your Experience',
                          icon: Icons.edit,
                          inputType: TextInputType.name,
                          maxLines: 3,
                          controller: experienceController,
                        ),
                      textFeld(
                          label: 'Bio',
                          hintText: 'Your Bio',
                          icon: Icons.edit,
                          inputType: TextInputType.name,
                          maxLines: 3,
                          controller: bioController,
                        ),

                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50,
                      // width: MediaQuery.of(context).size.width * 0.90,
                      child: CustomButton(
                        text: "Save",
                        onPressed: () => storeDoctorData(),
                      ),
                    ),
                    SizedBox(width: 20),
                    SizedBox(
                        height: 50,
                        // width: MediaQuery.of(context).size.width * 0.90,
                        child: CustomButton(
                          text: "Cancel",
                          onPressed: () => Navigator.pop(context),
                        ),
                      )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // store user data to database
  void storeDoctorData() async {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    UserModel userModel = UserModel(
      phoneNumber: phoneController.text.trim(),
      uid: phoneController.text.trim(),
      password: "12345",// generate password,
      role: 'Doctor',
      resetPassword: true,
    );
    await ap.saveUserDataToFirebase(context: context, userModel: userModel);

    DoctorInfoModel doctorModel = DoctorInfoModel(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      userId: ap.uid,
      gender: genderController.text.trim(),
      id: '',
      bio: bioController.text.trim(),
      experience: experienceController.text.trim(),
      specialization: specilizationController.text.trim(),
      profilePicId: '',
      clinicId: '',
      currentStatus: 'Not Available',
    );
    doctorModel.id = await ap.getNewDoctorId();

    ap.saveDoctorDataToFirebaseAdmin(
      context: context,
      userModel: doctorModel,
      profilePic: image!,
      onSuccess: () {
        Navigator.pop(
                context);
      },
    );
  }
}


class AdminAddPatientScreen extends StatefulWidget {
  const AdminAddPatientScreen({super.key});

  @override
  State<AdminAddPatientScreen> createState() => _AdminAddPatientScreenState();
}

class _AdminAddPatientScreenState extends State<AdminAddPatientScreen> {
  final phoneController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final genderController = TextEditingController();
  String selectedGender = 'Male'; // Default
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    phoneController.text = 'Patient Phone';
    nameController.text = 'Patient Name';
    emailController.text = 'Patient Email';
    genderController.text = 'Male';
    _selectedDate = DateTime.now();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    genderController.dispose();
    phoneController.dispose();
  }

    Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: true);
    final isLoading = authProvider.isLoading;
        // Provider.of<AuthProvider>(context, listen: true).isLoading;
    return Scaffold(
      body: SafeArea(
        child: isLoading == true
            ? const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF3E69FE),
          ),
        )
            : SingleChildScrollView(
          padding:
          const EdgeInsets.symmetric(vertical: 25.0, horizontal: 5.0),
          child: Center(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(
                      vertical: 5, horizontal: 15),
                  margin: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      textFeld(
                        label: 'Phone',
                        hintText: phoneController.text,
                        icon: Icons.account_circle,
                        inputType: TextInputType.phone,
                        maxLines: 1,
                        controller: phoneController,
                      ),

                      // name field
                      textFeld(
                        label: 'Name',
                        hintText: nameController.text,
                        icon: Icons.account_circle,
                        inputType: TextInputType.name,
                        maxLines: 1,
                        controller: nameController,
                      ),

                      // email
                      textFeld(
                        label: 'Email',
                        hintText: emailController.text,
                        icon: Icons.email,
                        inputType: TextInputType.emailAddress,
                        maxLines: 1,
                        controller: emailController,
                      ),
                      // add a DateTime field for dob
                      ElevatedButton(
                          onPressed: () => _selectDate(context),
                          child: Text('Date of Birth: ${_selectedDate.toString()}')
                      ),

                      // gender
                      // textFeld(
                      //   hintText: "Male/Female/Other",
                      //   icon: Icons.male_sharp,
                      //   inputType: TextInputType.text,
                      //   maxLines: 1,
                      //   controller: genderController,
                      // ),
                      SizedBox(height: 16),
                      const Text('Select Gender:'),
                      DropdownButton<String>(
                        // controller: genderController,
                        value : selectedGender,
                        onChanged: (value) {
                          setState(() {
                            genderController.text = value!;
                            selectedGender = value;
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
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50,
                      // width: MediaQuery.of(context).size.width * 0.90,
                      child: CustomButton(
                        text: "Save",
                        onPressed: () => storePatientData(),
                      ),
                    ),
                    SizedBox(width: 20),
                    SizedBox(
                        height: 50,
                        // width: MediaQuery.of(context).size.width * 0.90,
                        child: CustomButton(
                          text: "Cancel",
                          onPressed: () => Navigator.pop(context),
                        ),
                      )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // store user data to database
  void storePatientData() async {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    UserModel userModel = UserModel(
      phoneNumber: phoneController.text.trim(),
      uid: phoneController.text.trim(),
      password: "12345",// generate password,
      role: 'Patient',
      resetPassword: true,
    );
    await ap.saveUserDataToFirebase(context: context, userModel: userModel);
    // save user data to firebase

    PatientInfoModel patientModel = PatientInfoModel(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      userId: userModel.uid,
      gender: genderController.text.trim(),
      id: '',
      dob: _selectedDate!,
    );
 
    patientModel.id = await ap.getNewPatientId();

    ap.savePatientDataToFirebaseAdmin(
      context: context,
      userModel: patientModel,
      onSuccess: () {
        Navigator.pop(context);
      },
    );
  }
}

class AddPatientScreen extends StatefulWidget {
  const AddPatientScreen({super.key});

  @override
  State<AddPatientScreen> createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final genderController = TextEditingController();
  String selectedGender = 'Male'; // Default
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    nameController.text = 'Your Name';
    emailController.text = 'Your Email';
    genderController.text = 'Male';
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    genderController.dispose();
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

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: true);
    final isLoading = authProvider.isLoading;
        // Provider.of<AuthProvider>(context, listen: true).isLoading;
    return Scaffold(
      body: SafeArea(
        child: isLoading == true
            ? const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF3E69FE),
          ),
        )
            : SingleChildScrollView(
          padding:
          const EdgeInsets.symmetric(vertical: 25.0, horizontal: 5.0),
          child: Center(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(
                      vertical: 5, horizontal: 15),
                  margin: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      // name field
                      textFeld(
                        label: 'Name',
                        hintText: 'Your Name',
                        icon: Icons.account_circle,
                        inputType: TextInputType.name,
                        maxLines: 1,
                        controller: nameController,
                      ),

                      // email
                      textFeld(
                        label: 'Email',
                        hintText: 'Your Email',
                        icon: Icons.email,
                        inputType: TextInputType.emailAddress,
                        maxLines: 1,
                        controller: emailController,
                      ),
                      ElevatedButton(
                          onPressed: () => _selectDate(context),
                          child: Text('Date of Birth: ${_selectedDate.toString()}'),
                        ),

                      // gender
                      // textFeld(
                      //   hintText: "Male/Female/Other",
                      //   icon: Icons.male_sharp,
                      //   inputType: TextInputType.text,
                      //   maxLines: 1,
                      //   controller: genderController,
                      // ),
                      SizedBox(height: 16),
                      const Text('Select Gender:'),
                      DropdownButton<String>(
                        // controller: genderController,
                        value : selectedGender,
                        onChanged: (value) {
                          setState(() {
                            genderController.text = value!;
                            selectedGender = value;
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
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50,
                      child: CustomButton(
                        text: "Save",
                        onPressed: () => storePatientData(),
                      ),
                    ),
                    SizedBox(width: 20),
                    SizedBox(
                        height: 50,
                        // width: MediaQuery.of(context).size.width * 0.90,
                        child: CustomButton(
                          text: "Cancel",
                          onPressed: () => Navigator.pop(context),
                        ),
                      )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // store user data to database
  void storePatientData() async {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    PatientInfoModel userModel = PatientInfoModel(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      userId: ap.uid,
      gender: genderController.text.trim(),
      id: '',
      dob: _selectedDate!,
    );
    userModel.userId = ap.uid;
    userModel.id = await ap.getNewPatientId();

    ap.savePatientDataToFirebase(
      context: context,
      userModel: userModel,
      onSuccess: () {
        Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) =>  NavBar(role: ap.role,),
                ),
                    (route) => false);
      },
    );
  }
}

class EditPatientScreen extends StatefulWidget {
  final PatientInfoModel patientInfoModel;

  const EditPatientScreen({super.key, required this.patientInfoModel});

  @override
  State<EditPatientScreen> createState() => _EditPatientScreenState();
}

class _EditPatientScreenState extends State<EditPatientScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final genderController = TextEditingController();
  String selectedGender = 'Male'; // Default
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.patientInfoModel.name;
    emailController.text = widget.patientInfoModel.email;
    genderController.text = widget.patientInfoModel.gender;
    _selectedDate = widget.patientInfoModel.dob;
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    genderController.dispose();
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

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: true);
    final isLoading = authProvider.isLoading;
        // Provider.of<AuthProvider>(context, listen: true).isLoading;
    return Scaffold(
      body: SafeArea(
        child: isLoading == true
            ? const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF3E69FE),
          ),
        )
            : SingleChildScrollView(
          padding:
          const EdgeInsets.symmetric(vertical: 25.0, horizontal: 5.0),
          child: Center(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(
                      vertical: 5, horizontal: 15),
                  margin: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      // name field
                      textFeld(
                        label: 'Name',
                        hintText: nameController.text,
                        icon: Icons.account_circle,
                        inputType: TextInputType.name,
                        maxLines: 1,
                        controller: nameController,
                      ),

                      // email
                      textFeld(
                        label: 'Email',
                        hintText: emailController.text,
                        icon: Icons.email,
                        inputType: TextInputType.emailAddress,
                        maxLines: 1,
                        controller: emailController,
                      ),
                      ElevatedButton(
                          onPressed: () => _selectDate(context),
                          child: Text('Date of Birth: ${_selectedDate.toString()}'),
                        ),

                      // gender
                      // textFeld(
                      //   hintText: "Male/Female/Other",
                      //   icon: Icons.male_sharp,
                      //   inputType: TextInputType.text,
                      //   maxLines: 1,
                      //   controller: genderController,
                      // ),
                      SizedBox(height: 16),
                      const Text('Select Gender:'),
                      DropdownButton<String>(
                        // controller: genderController,
                        value : selectedGender,
                        onChanged: (value) {
                          setState(() {
                            genderController.text = value!;
                            selectedGender = value;
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
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.90,
                  child: CustomButton(
                    text: "Save",
                    onPressed: () => storePatientData(),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // store user data to database
  void storePatientData() async {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    PatientInfoModel userModel = PatientInfoModel(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      userId: ap.uid,
      gender: genderController.text.trim(),
      id: widget.patientInfoModel.id,
      dob: _selectedDate,
    );

    ap.savePatientDataToFirebase(
      context: context,
      userModel: userModel,
      onSuccess: () {
        Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) =>  NavBar(role: ap.role),
                ),
                    (route) => false);
      },
    );
  }
}



class EditDoctorScreen extends StatefulWidget {
  final DoctorInfoModel doctorInfoModel;
  const EditDoctorScreen({super.key, required this.doctorInfoModel});

  @override
  State<EditDoctorScreen> createState() => _EditDoctorScreenState();
}

class _EditDoctorScreenState extends State<EditDoctorScreen> {
  File? image;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final genderController = TextEditingController();
  final bioController = TextEditingController();
  final specilizationController = TextEditingController();
  final experienceController = TextEditingController();

  String selectedGender = 'Male'; // Default
  bool imageSelected = false;
  @override
  void initState() {
    super.initState();
    nameController.text = widget.doctorInfoModel.name;
    emailController.text = widget.doctorInfoModel.email;
    genderController.text = widget.doctorInfoModel.gender;
    bioController.text = widget.doctorInfoModel.bio;
    specilizationController.text = widget.doctorInfoModel.specialization;
    experienceController.text = widget.doctorInfoModel.experience;
    image = widget.doctorInfoModel.profilePicId != '' ? File(widget.doctorInfoModel.profilePicId) : null;
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    genderController.dispose();
    bioController.dispose();
    specilizationController.dispose();
    experienceController.dispose();
  }

    // for selecting image
  void selectImage() async {
    image = await pickImage(context);
    setState(() { imageSelected = true; });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: true);
    final isLoading = authProvider.isLoading;
        // Provider.of<AuthProvider>(context, listen: true).isLoading;
    return Scaffold(
      body: SafeArea(
        child: isLoading == true
            ? const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF3E69FE),
          ),
        )
            : SingleChildScrollView(
          padding:
          const EdgeInsets.symmetric(vertical: 25.0, horizontal: 5.0),
          child: Center(
            child: Column(
              children: [
                InkWell(
                  onTap: () => selectImage(),
                  child: image == null
                      ? const CircleAvatar(
                    backgroundColor: Color(0xFF3E69FE),
                    radius: 50,
                    child: Icon(
                      Icons.account_circle,
                      size: 50,
                      color: Colors.white,
                    ),
                  )
                      : CircleAvatar(
                    backgroundImage: FileImage(image!),
                    radius: 50,
                  ),
                ),                
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(
                      vertical: 5, horizontal: 15),
                  margin: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      // name field
                      textFeld(
                        label: 'Name',
                        hintText: nameController.text,
                        icon: Icons.account_circle,
                        inputType: TextInputType.name,
                        maxLines: 1,
                        controller: nameController,
                      ),

                      // email
                      textFeld(
                        label: 'Email',
                        hintText: emailController.text,
                        icon: Icons.email,
                        inputType: TextInputType.emailAddress,
                        maxLines: 1,
                        controller: emailController,
                      ),

                      SizedBox(height: 16),
                      const Text('Select Gender:'),
                      DropdownButton<String>(
                        // controller: genderController,
                        value : selectedGender,
                        onChanged: (value) {
                          setState(() {
                            genderController.text = value!;
                            selectedGender = value;
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
                      textFeld(
                          label: 'Specialization',
                          hintText: specilizationController.text,
                          icon: Icons.edit,
                          inputType: TextInputType.name,
                          maxLines: 3,
                          controller: specilizationController,
                        ),
                      textFeld(
                          label: 'Experience',
                          hintText: experienceController.text,
                          icon: Icons.edit,
                          inputType: TextInputType.name,
                          maxLines: 3,
                          controller: experienceController,
                        ),
                      textFeld(
                          label: 'Bio',
                          hintText: bioController.text,
                          icon: Icons.edit,
                          inputType: TextInputType.name,
                          maxLines: 3,
                          controller: bioController,
                        ),

                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50,
                      // width: MediaQuery.of(context).size.width * 0.90,
                      child: CustomButton(
                        text: "Save",
                        onPressed: () => storeDoctorData(),
                      ),
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      height: 50,
                      // width: MediaQuery.of(context).size.width * 0.90,
                      child: CustomButton(
                        text: "Cancel",
                        onPressed: () => Navigator.pop(context),
                      ),
                    )
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
    // store user data to database
  void storeDoctorData() async {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    DoctorInfoModel userModel = DoctorInfoModel(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      userId: ap.uid,
      gender: genderController.text.trim(),
      id: widget.doctorInfoModel.id,
      bio: bioController.text.trim(),
      experience: experienceController.text.trim(),
      specialization: specilizationController.text.trim(),
      profilePicId: widget.doctorInfoModel.profilePicId,
      clinicId: widget.doctorInfoModel.clinicId,
      currentStatus: widget.doctorInfoModel.currentStatus,
    );

    ap.saveDoctorDataToFirebase(
      context: context,
      userModel: userModel,
      profilePic: image!,
      onSuccess: () {
        Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) =>  NavBar(role: ap.role),
                ),
                    (route) => false);
      },
      upload: imageSelected
    );
  }
}

// Only be called admin scrre
class EditDoctorStatusScreen extends StatefulWidget {
  final DoctorInfoModel doctorInfoModel;
  const EditDoctorStatusScreen({super.key, required this.doctorInfoModel});

  @override
  State<EditDoctorStatusScreen> createState() => _EditDoctorStatusScreenState();
}

class _EditDoctorStatusScreenState extends State<EditDoctorStatusScreen> {

  final clinicController = TextEditingController();
  final currentStatusController = TextEditingController();
  int selectedIndex = 0; // Default
  String selectedStatus = 'Available'; // Default
  List<String> statusList = ['Available', 'Not Available'];
  @override
  void initState() {
    super.initState();
    currentStatusController.text = widget.doctorInfoModel.currentStatus;
    clinicController.text = widget.doctorInfoModel.clinicId;
    selectedStatus = statusList.first;
  }

  @override
  void dispose() {
    super.dispose();
    clinicController.dispose();
    currentStatusController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: true);
    clinicController.text = authProvider.clinicsInfoModel[selectedIndex].id;
    final isLoading = authProvider.isLoading;
        // Provider.of<AuthProvider>(context, listen: true).isLoading;
    return Scaffold(
      body: SafeArea(
        child: isLoading == true
            ? const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF3E69FE),
          ),
        )
            : SingleChildScrollView(
          padding:
          const EdgeInsets.symmetric(vertical: 25.0, horizontal: 5.0),
          child: Center(
            child: Column(
              children: [             
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(
                      vertical: 5, horizontal: 15),
                  margin: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      SizedBox(height: 16),
                      const Text('Current Status:'),
                      DropdownButton<String>(
                        // controller: genderController,
                        value : selectedStatus,
                        onChanged: (value) {
                          setState(() {
                            currentStatusController.text = value!;
                            selectedStatus = value;
                          });
                        },
                        items: statusList.map<DropdownMenuItem<String>>(
                              (String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          },
                        ).toList(),
                      ),
                      SizedBox(height: 16),
                      const Text('Location:'),
                      DropdownButton<String>(
                        // controller: genderController,
                        value : authProvider.clinicsInfoModel[selectedIndex].id,
                        onChanged: (value) {
                          setState(() {
                            clinicController.text = value!;
                            selectedIndex = authProvider.clinicsInfoModel.indexWhere((element) => element.id == value);
                          });
                        },
                        // populate the menu items with the clinic names
                        items: authProvider.clinicsInfoModel.map<DropdownMenuItem<String>>(
                              (ClinicInfoModel value) {
                            return DropdownMenuItem<String>(
                              value: value.id,
                              child: Text(value.name),
                            );
                          },
                        ).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.90,
                  child: CustomButton(
                    text: "Save",
                    onPressed: () => updateDoctorStatus(),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
    // store user data to database
  void updateDoctorStatus() async {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    DoctorInfoModel userModel = DoctorInfoModel(
      name: widget.doctorInfoModel.name,
      email: widget.doctorInfoModel.email,
      userId: widget.doctorInfoModel.userId,
      gender: widget.doctorInfoModel.gender,
      id: widget.doctorInfoModel.id,
      bio: widget.doctorInfoModel.bio,
      experience: widget.doctorInfoModel.experience,
      specialization: widget.doctorInfoModel.specialization,
      profilePicId: widget.doctorInfoModel.profilePicId,
      clinicId: clinicController.text.trim(),
      currentStatus: currentStatusController.text.trim(),
    );

    ap.saveDoctorDataToFirebaseAdmin(
      context: context,
      userModel: userModel,
      profilePic: File(userModel.profilePicId),
      onSuccess: () {
        Navigator.pop(context);
      },
      upload: false,
    );
  }
}

class ADDDoctorScreen extends StatefulWidget {
  const ADDDoctorScreen({super.key});

  @override
  State<ADDDoctorScreen> createState() => _ADDDoctorScreen();
}

class _ADDDoctorScreen extends State<ADDDoctorScreen> {
  File? image;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final genderController = TextEditingController();
  final bioController = TextEditingController();
  final specilizationController = TextEditingController();
  final experienceController = TextEditingController();

  String selectedGender = 'Male'; // Default

  @override
  void initState() {
    super.initState();
    nameController.text = 'Your Name';
    emailController.text = 'Your Email';
    genderController.text = 'Male';
    bioController.text = 'Your Bio';
    specilizationController.text = 'Your Specilization';
    experienceController.text = 'Your Experience';
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    genderController.dispose();
    bioController.dispose();
    specilizationController.dispose();
    experienceController.dispose();
  }

    // for selecting image
  void selectImage() async {
    image = await pickImage(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: true);
    final isLoading = authProvider.isLoading;
        // Provider.of<AuthProvider>(context, listen: true).isLoading;
    return Scaffold(
      body: SafeArea(
        child: isLoading == true
            ? const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF3E69FE),
          ),
        )
            : SingleChildScrollView(
          padding:
          const EdgeInsets.symmetric(vertical: 25.0, horizontal: 5.0),
          child: Center(
            child: Column(
              children: [
                InkWell(
                  onTap: () => selectImage(),
                  child: image == null
                      ? const CircleAvatar(
                    backgroundColor: Color(0xFF3E69FE),
                    radius: 50,
                    child: Icon(
                      Icons.account_circle,
                      size: 50,
                      color: Colors.white,
                    ),
                  )
                      : CircleAvatar(
                    backgroundImage: FileImage(image!),
                    radius: 50,
                  ),
                ),                
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(
                      vertical: 5, horizontal: 15),
                  margin: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      // name field
                      textFeld(
                        label: 'Name',
                        hintText: 'Your Name',
                        icon: Icons.account_circle,
                        inputType: TextInputType.name,
                        maxLines: 1,
                        controller: nameController,
                      ),

                      // email
                      textFeld(
                        label: 'Email',
                        hintText: 'Your Email',
                        icon: Icons.email,
                        inputType: TextInputType.emailAddress,
                        maxLines: 1,
                        controller: emailController,
                      ),

                      SizedBox(height: 16),
                      const Text('Select Gender:'),
                      DropdownButton<String>(
                        // controller: genderController,
                        value : selectedGender,
                        onChanged: (value) {
                          setState(() {
                            genderController.text = value!;
                            selectedGender = value;
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
                      textFeld(
                          label: 'Specialization',
                          hintText: 'Your Specilization',
                          icon: Icons.edit,
                          inputType: TextInputType.name,
                          maxLines: 3,
                          controller: specilizationController,
                        ),
                      textFeld(
                          label: 'Experience',
                          hintText: 'Your Experience',
                          icon: Icons.edit,
                          inputType: TextInputType.name,
                          maxLines: 3,
                          controller: experienceController,
                        ),
                      textFeld(
                          label: 'Bio',
                          hintText: 'Your Bio',
                          icon: Icons.edit,
                          inputType: TextInputType.name,
                          maxLines: 3,
                          controller: bioController,
                        ),

                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50,
                      // width: MediaQuery.of(context).size.width * 0.90,
                      child: CustomButton(
                        text: "Save",
                        onPressed: () => storeDoctorData(),
                      ),
                    ),
                    SizedBox(width: 20),
                    SizedBox(
                        height: 50,
                        // width: MediaQuery.of(context).size.width * 0.90,
                        child: CustomButton(
                          text: "Cancel",
                          onPressed: () => Navigator.pop(context),
                        ),
                      )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // store user data to database
  void storeDoctorData() async {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    DoctorInfoModel userModel = DoctorInfoModel(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      userId: ap.uid,
      gender: genderController.text.trim(),
      id: '',
      bio: bioController.text.trim(),
      experience: experienceController.text.trim(),
      specialization: specilizationController.text.trim(),
      profilePicId: '',
      clinicId: '',
      currentStatus: 'Not Available',
    );
    userModel.userId = ap.uid;
    userModel.id = await ap.getNewDoctorId();

    ap.saveDoctorDataToFirebase(
      context: context,
      userModel: userModel,
      profilePic: image!,
      onSuccess: () {
        Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) =>  NavBar(role: ap.role),
                ),
                    (route) => false);
      },
    );
  }
}

// class UserInfromationScreen extends StatefulWidget {
//   const UserInfromationScreen({super.key});

//   @override
//   State<UserInfromationScreen> createState() => _UserInfromationScreenState();
// }

// class _UserInfromationScreenState extends State<UserInfromationScreen> {
//   final nameController = TextEditingController();
//   final emailController = TextEditingController();
//   final bioController = TextEditingController();
//   final roleController = TextEditingController();
//   final genderController = TextEditingController();
//   final specilizationController = TextEditingController();
//   String selectedGender = 'Male'; // Default

//   @override
//   void initState() {
//     super.initState();
//     final ap = Provider.of<AuthProvider>(context, listen: false);
//     nameController.text = ap.userModel.name;
//     emailController.text = ap.userModel.email;
//     bioController.text = ap.userModel.bio;
//     roleController.text = ap.userModel.role != '' ? ap.userModel.role: 'Patient';
//     genderController.text = 'Male';
//     specilizationController.text = ap.userModel.specialization;
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     nameController.dispose();
//     emailController.dispose();
//     bioController.dispose();
//     roleController.dispose();// ... (dispose other controllers)
//     genderController.dispose();
//     specilizationController.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context, listen: true);
//     final isLoading = authProvider.isLoading;
//         // Provider.of<AuthProvider>(context, listen: true).isLoading;
//     return Scaffold(
//       body: SafeArea(
//         child: isLoading == true
//             ? const Center(
//           child: CircularProgressIndicator(
//             color: Color(0xFF3E69FE),
//           ),
//         )
//             : SingleChildScrollView(
//           padding:
//           const EdgeInsets.symmetric(vertical: 25.0, horizontal: 5.0),
//           child: Center(
//             child: Column(
//               children: [
//                 Container(
//                   width: MediaQuery.of(context).size.width,
//                   padding: const EdgeInsets.symmetric(
//                       vertical: 5, horizontal: 15),
//                   margin: const EdgeInsets.only(top: 20),
//                   child: Column(
//                     children: [
//                       // name field
//                       textFeld(
//                         label: 'Name',
//                         hintText: authProvider.userModel.name,
//                         icon: Icons.account_circle,
//                         inputType: TextInputType.name,
//                         maxLines: 1,
//                         controller: nameController,
//                       ),

//                       // email
//                       textFeld(
//                         label: 'Email',
//                         hintText: authProvider.userModel.email,
//                         icon: Icons.email,
//                         inputType: TextInputType.emailAddress,
//                         maxLines: 1,
//                         controller: emailController,
//                       ),

//                       // gender
//                       // textFeld(
//                       //   hintText: "Male/Female/Other",
//                       //   icon: Icons.male_sharp,
//                       //   inputType: TextInputType.text,
//                       //   maxLines: 1,
//                       //   controller: genderController,
//                       // ),
//                       SizedBox(height: 16),
//                       const Text('Select Gender:'),
//                       DropdownButton<String>(
//                         // controller: genderController,
//                         value : selectedGender,
//                         onChanged: (value) {
//                           setState(() {
//                             genderController.text = value!;
//                             selectedGender = value;
//                           });
//                         },
//                         items: ['Male', 'Female', 'Others'].map<DropdownMenuItem<String>>(
//                               (String value) {
//                             return DropdownMenuItem<String>(
//                               value: value,
//                               child: Text(value),
//                             );
//                           },
//                         ).toList(),
//                       ),

//                       // specilization
//                       if (authProvider.userModel.role == 'doctor')
//                         textFeld(
//                           label: 'Specialization',
//                           hintText: authProvider.userModel.specialization,
//                           icon: Icons.data_exploration,
//                           inputType: TextInputType.multiline,
//                           maxLines: 2,
//                           controller: specilizationController,
//                           disabled: authProvider.userModel.role != 'doctor'
//                         ),
//                       // bio
//                       if (authProvider.userModel.role == 'doctor')
//                         textFeld(
//                           label: 'Bio',
//                           hintText: authProvider.userModel.bio,
//                           icon: Icons.edit,
//                           inputType: TextInputType.name,
//                           maxLines: 2,
//                           controller: bioController,
//                           disabled: authProvider.userModel.role != 'doctor'
//                         ),

//                       if (authProvider.userModel.role == 'admin')
//                         textFeld(
//                           label: 'Role',
//                           hintText: authProvider.userModel.role,
//                           icon: Icons.verified_user,
//                           inputType: TextInputType.text,
//                           maxLines: 1,
//                           controller: roleController,
//                           disabled: authProvider.userModel.role != 'admin'
//                         ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 SizedBox(
//                   height: 50,
//                   width: MediaQuery.of(context).size.width * 0.90,
//                   child: CustomButton(
//                     text: "Save",
//                     onPressed: () => storeData(),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget textFeld({
//     required String label,
//     required String hintText,
//     required IconData icon,
//     required TextInputType inputType,
//     required int maxLines,
//     required TextEditingController controller,
//     bool disabled = false
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10),
//       child: TextFormField(
//         cursorColor: Color(0xFF3E69FE),
//         controller: controller,
//         keyboardType: inputType,
//         maxLines: maxLines,
//         readOnly: disabled,
//         decoration: InputDecoration(
//           labelText: label,
//           prefixIcon: Container(
//             margin: const EdgeInsets.all(8.0),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(8),
//               color: Color.fromARGB(255, 243, 243, 245),
//             ),
//             child: Icon(
//               icon,
//               size: 20,
//               color: const Color.fromARGB(255, 20, 20, 20),
//             ),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: const BorderSide(
//               color: Colors.transparent,
//             ),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: const BorderSide(
//               color: Colors.transparent,
//             ),
//           ),
//           hintText: hintText,
//           alignLabelWithHint: true,
//           border: InputBorder.none,
//           fillColor: Color.fromARGB(255, 242, 242, 245),
//           filled: true,
//         ),
//       ),
//     );
//   }

//   // store user data to database
//   void storeData() async {
//     final ap = Provider.of<AuthProvider>(context, listen: false);
//     UserModel userModel = UserModel(
//       name: nameController.text.trim(),
//       email: emailController.text.trim(),
//       bio: bioController.text.trim(),
//       phoneNumber: ap.userModel.phoneNumber,
//       uid: ap.uid,
//       role:roleController.text.trim(),
//       gender: genderController.text.trim(),
//       specialization: specilizationController.text.trim(),
//       password: ap.userModel.password
//     );

//     ap.saveUserDataToFirebase(
//       context: context,
//       userModel: userModel,
//       onSuccess: () {
//         ap.saveUserDataToSP().then(
//               (value) => ap.setSignIn().then(
//                 (value) => Navigator.pushAndRemoveUntil(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const NavBar(),
//                 ),
//                     (route) => false),
//           ),
//         );
//       },
//     );
//   }
// }
