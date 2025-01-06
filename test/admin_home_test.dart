import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:neurocare/screens/admin_home.dart';
import 'package:neurocare/provider/auth_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:neurocare/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
  group('AdminHomeScreen Tests', ()  {
    testWidgets('Initial state of AdminHomeScreen', (WidgetTester tester) async {
      

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
          ],
          child: MaterialApp(home: AdminHomeScreen()),
        ),
      );

      // Verify initial state
      expect(find.text('Pending Help Requests'), findsOneWidget);
      expect(find.text('Pending Bookings'), findsOneWidget);
      expect(find.text('Scheduled Bookings'), findsOneWidget);
      expect(find.text('Completed Bookings'), findsOneWidget);
    });

    testWidgets('Tab navigation works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
          ],
          child: MaterialApp(home: AdminHomeScreen()),
        ),
      );

      // Verify initial tab
      expect(find.text('Pending Help Requests'), findsOneWidget);

      // Tap on the second tab
      await tester.tap(find.text('Pending Bookings'));
      await tester.pump();

      // Verify second tab content
      expect(find.text('Pending Bookings'), findsOneWidget);
    });

    testWidgets('Date picker works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
          ],
          child: MaterialApp(home: AdminHomeScreen()),
        ),
      );

      // Tap on the third tab
      await tester.tap(find.text('Scheduled Bookings'));
      await tester.pump();

      // Tap on the 'Select Date' button
      await tester.tap(find.text('Select Date'));
      await tester.pumpAndSettle();

      // Select a date from the date picker
      await tester.tap(find.text('15'));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Verify the selected date is displayed
      expect(find.text('Showing Appointments for 15/'), findsOneWidget);
    });

    testWidgets('Fetching booking details works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
          ],
          child: MaterialApp(home: AdminHomeScreen()),
        ),
      );

      // Tap on the second tab
      await tester.tap(find.text('Pending Bookings'));
      await tester.pump();

      // Verify the loading indicator is displayed
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Simulate fetching data
      await tester.pump(Duration(seconds: 2));

      // Verify the data is displayed
      expect(find.text('No Pending booking request.'), findsOneWidget);
    });
  });
}