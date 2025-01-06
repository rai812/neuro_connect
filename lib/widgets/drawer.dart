import 'package:neurocare/screens/dashboard.dart';
import 'package:neurocare/screens/referrals.dart';
import 'package:neurocare/screens/user_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:neurocare/provider/auth_provider.dart';
import 'package:neurocare/screens/home.dart';
import 'package:neurocare/screens/profile.dart';
import 'package:neurocare/screens/phone.dart';
import 'package:neurocare/screens/admin_home.dart';
import 'package:neurocare/screens/referrals.dart';
import 'package:neurocare/screens/admin_load.dart';
import 'package:neurocare/screens/dashboard.dart';
import '../screens/data_upload.py';
class DrawerWidget extends StatelessWidget {
  const DrawerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add your side menu content here
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xFF3E69FE),
                  shape: BoxShape.rectangle,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 4),
                        Text(
                          authProvider.isSignedIn ? authProvider.userModel.phoneNumber ?? "" : "",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 4),
                        if (authProvider.role == 'Doctor')
                        Text(
                          "${authProvider.doctorsInfoModel[authProvider.activeDoctorIndex].name}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          )),                      
                          ],
                    ),
                  ],
                ),
              ),
              ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.home),
                      SizedBox(width: 8,),
                      Text('Referrals',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),),
                    ],
                  ),
                  onTap: () {
                    // Add action for menu item 1
                    Navigator.pop(context); // Close the drawer
                    // go to home screen
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ReferralList()));
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                  },
                ),
                Divider(
                  thickness: 2,
                  indent: 40,
                ),
                if (authProvider.userModel.role == 'admin')
                ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.home),
                      SizedBox(width: 8,),
                      Text('Admin Dashboard',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),),
                    ],
                  ),
                  onTap: () {
                    // Add action for menu item 1
                    Navigator.pop(context); // Close the drawer
                    // go to home screen
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard()));
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                  },
                ),
              if (authProvider.userModel.role == 'admin')
                Divider(
                  thickness: 2,
                  indent: 40,
                ),
              if (authProvider.userModel.role == 'admin')
                ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.home),
                      SizedBox(width: 8,),
                      Text('Reset Password',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),),
                    ],
                  ),
                  onTap: () {
                    // Add action for menu item 1
                    Navigator.pop(context); // Close the drawer
                    // go to home screen
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPasswordScreen()));
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                  },
                ),
              if (authProvider.userModel.role == 'admin' )
                Divider(
                  thickness: 2,
                  indent: 40,
                ),  
              // check if user is admin and testing is set in env
              if (authProvider.userModel.role == 'admin' && authProvider.testing)
                ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.home),
                      SizedBox(width: 8,),
                      Text('Admin Test Load',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),),
                    ],
                  ),
                  onTap: () {
                    // Add action for menu item 1
                    Navigator.pop(context); // Close the drawer
                    // go to home screen
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AdminLoadScreen()));
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                  },
                ),
              if (authProvider.userModel.role == 'admin' && authProvider.testing)
                Divider(
                  thickness: 2,
                  indent: 40,
                ),
              if (authProvider.userModel.role == 'admin')
                ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.home),
                      SizedBox(width: 8,),
                      Text('Add Patient (bulk)',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),),
                    ],
                  ),
                  onTap: () {
                    // Add action for menu item 1
                    Navigator.pop(context); // Close the drawer
                    // go to home screen
                      Navigator.push(context, MaterialPageRoute(builder: (context) => DataLoadingScreen()));
                  },
                ),
              if (authProvider.userModel.role == 'admin')  
                Divider(
                  thickness: 2,
                  indent: 40,
                ),                
              // ... Rest of your Drawer items
              if (authProvider.userModel.role == 'admin')
                ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.home),
                      SizedBox(width: 8,),
                      Text('Add Doctor',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),),
                    ],
                  ),
                  onTap: () {
                    // Add action for menu item 1
                    Navigator.pop(context); // Close the drawer
                    // go to home screen
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AdminAddDoctorScreen()));
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                  },
                ),
              if (authProvider.userModel.role == 'admin')  
                Divider(
                  thickness: 2,
                  indent: 40,
                ),
              // if (authProvider.userModel.role != 'Patient')
              //   ListTile(
              //     title: Row(
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       children: [
              //         Icon(Icons.search_rounded),
              //         SizedBox(width: 8,),
              //         Text('Search',
              //           style: TextStyle(
              //             fontSize: 18,
              //             fontWeight: FontWeight.bold,
              //           ),),
              //       ],
              //     ),
              //     onTap: () {
              //       // Add action for menu item 2
              //       Navigator.pop(context); // Close the drawer
              //       // TODO add when seach screen is ready
              //     },
              //   ),
            // if (authProvider.userModel.role != 'Patient')  
            //   Divider(
            //     thickness: 2,
            //     indent: 40,
            //   ),
            //   // Divider(
            //   //   thickness: 2,
            //   //   indent: 40,
            //   // ),
            //   ListTile(
            //     title: Row(
            //       mainAxisAlignment: MainAxisAlignment.start,
            //       children: [
            //         Icon(Icons.person),
            //         SizedBox(width: 8,),
            //         Text('Profile',
            //           style: TextStyle(
            //             fontSize: 18,
            //             fontWeight: FontWeight.bold,
            //           ),),
            //       ],
            //     ),
            //     onTap: () {
            //       // Add action for menu item 2
            //       Navigator.pop(context); // Close the drawer
            //       // add the profile screen here 
            //       Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
            //     },
            //   ),
              // Divider(
              //   thickness: 2,
              //   indent: 40,
              // ),
              ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.logout),
                      SizedBox(width: 8,),
                      Text('Log Out',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),),
                    ],
                  ),
                  onTap: () {
                    // Add your settings logic here
                    // Call the AuthProvider method for user sign out
                    AuthProvider().userSignOut();
                    Navigator.of(context).pushReplacement(MaterialPageRoute (
                      builder: (BuildContext context) => const RegisterScreen(),
                    ),); // Navigate to login screen
                  },
                ),
    
              ],
          );
        },
      ),
    );
  }
}
