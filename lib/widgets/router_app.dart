import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:heart_connect_app/screen/auth_screen.dart';

class AppRouter {
  static const String auth = "/";

  static Map<String, WidgetBuilder> get routes {
    final FirebaseAuth authentification = FirebaseAuth.instance;
    
    return {auth: (context) => AuthScreen(auth: authentification)};
  }
}
