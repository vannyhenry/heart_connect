import 'package:flutter/material.dart';
import 'package:heart_connect_app/screen/auth_screen.dart';
import 'package:heart_connect_app/screen/displayAssignments/display_assignment.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        
      ),
      home: AuthScreen(),
    );
  }
}

