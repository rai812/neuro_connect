import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import '../provider/auth_provider.dart';
import '../widgets/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();

  Country selectedCountry = Country(
    phoneCode: "91",
    countryCode: "IN",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "India",
    example: "India",
    displayName: "India",
    displayNameNoCountryCode: "IN",
    e164Key: "",
  );

  @override
  Widget build(BuildContext context) {
    phoneController.selection = TextSelection.fromPosition(
      TextPosition(
        offset: phoneController.text.length,
      ),
    );
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
              child: Column(
                children: [
                  Container(
                    width: 300,
                    height: 300,
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      "assets/images/doctors.png",
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Add your phone number. We will create an account for you if not already created.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black38,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                    TextFormField(
                    cursorColor: Colors.black,
                    controller: phoneController,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    onChanged: (value) {
                      setState(() {
                      phoneController.text = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Enter phone number",
                      hintStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Colors.grey.shade600,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black12),
                      ),
                      focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black12),
                      ),
                      prefixIcon: Container(
                      padding: const EdgeInsets.all(13.0),
                      child: InkWell(
                        onTap: () {
                        showCountryPicker(
                          context: context,
                          countryListTheme: const CountryListThemeData(
                          bottomSheetHeight: 500,
                          ),
                          onSelect: (value) {
                          setState(() {
                            selectedCountry = value;
                          });
                          },
                        );
                        },
                        child: Text(
                        "${selectedCountry.flagEmoji} + ${selectedCountry.phoneCode}",
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        ),
                      ),
                      ),
                      suffixIcon: phoneController.text.length > 9
                        ? Container(
                      height: 30,
                      width: 30,
                      margin: const EdgeInsets.all(5.0),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                      ),
                      child: const Icon(
                        Icons.done,
                        color: Colors.white,
                        size: 20,
                      ),
                      )
                        : null,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                      } else if (value.length < 10) {
                      return 'Please enter a valid phone number';
                      }
                      // Allow only numbers
                      else if (!RegExp(r'^-?[0-9]+$').hasMatch(value)) {
                        return 'Please enter a valid phone number';
                      }
                      
                      return null;
                    },
                    ),

                  const Text(
                    "Password.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black38,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  // Password field widget here
                    TextFormField(
                    cursorColor: Colors.black,
                    controller: passwordController,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    onFieldSubmitted: (value) {
                      setState(() {
                      passwordController.text = value;
                      });
                    },
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                        _obscureText = !_obscureText;
                        });
                      },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                       return 'Please enter your password';
                       }
                       return null;
                     },
                    ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: CustomButton(
                        text: "Login", onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            sendPhoneNumber();
                          }
                        }),
                  ),
                ],
              ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void sendPhoneNumber() {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    String phoneNumber = phoneController.text.trim();
    String password = passwordController.text.trim();
    String passwordHash = md5.convert(utf8.encode(password)).toString();


    // create the hash of password


    ap.signInWithPhoneAndPassword(context, phoneNumber, passwordHash);
  }
}
