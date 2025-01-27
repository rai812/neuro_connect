// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDcqmnk-VOpzCvO_-bJhv06NI4lXMHeuoo',
    appId: '1:50443503891:web:02c4539b073e435525f2e6',
    messagingSenderId: '50443503891',
    projectId: 'neuroconnect',
    authDomain: 'neuroconnect.firebaseapp.com',
    storageBucket: 'neuroconnect.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBnXy8vsbYH7VLSbUlh-X2ZLQ_43ysfOhQ',
    appId: '1:50443503891:android:784e4c46b88c72a325f2e6',
    messagingSenderId: '50443503891',
    projectId: 'neuroconnect',
    storageBucket: 'neuroconnect.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAMVMAS_Cpno8-PQ_AQhiA-8T4lUD0EKc0',
    appId: '1:50443503891:ios:07f4e2cdddd4d7b125f2e6',
    messagingSenderId: '50443503891',
    projectId: 'neuroconnect',
    storageBucket: 'neuroconnect.appspot.com',
    iosBundleId: 'com.example.digiDiagnos',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAMVMAS_Cpno8-PQ_AQhiA-8T4lUD0EKc0',
    appId: '1:50443503891:ios:07f4e2cdddd4d7b125f2e6',
    messagingSenderId: '50443503891',
    projectId: 'neuroconnect',
    storageBucket: 'neuroconnect.appspot.com',
    iosBundleId: 'com.example.digiDiagnos',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDcqmnk-VOpzCvO_-bJhv06NI4lXMHeuoo',
    appId: '1:50443503891:web:b91eac5b6f50e4cc25f2e6',
    messagingSenderId: '50443503891',
    projectId: 'neuroconnect',
    authDomain: 'neuroconnect.firebaseapp.com',
    storageBucket: 'neuroconnect.appspot.com',
  );
}
