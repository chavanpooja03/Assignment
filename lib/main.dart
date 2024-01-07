import 'package:assignment/Screen/Explore_Screen.dart';
import 'package:assignment/Screen/Home_page.dart';
import 'package:assignment/Screen/OTP_screen.dart';
import 'package:assignment/entry_screen.dart';
import 'package:assignment/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Screen/Login_screen.dart';
import 'Navigation.dart';
import 'package:assignment/Screen/OTP_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Assignment());
}

class Assignment extends StatefulWidget {
  const Assignment({super.key});

  @override
  State<Assignment> createState() => _AssignmentState();
}

class _AssignmentState extends State<Assignment> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
