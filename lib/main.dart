import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:heart_connect_app/firebase_options.dart';
import 'package:heart_connect_app/widgets/router_app.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Heart Connect',
      initialRoute: AppRouter.auth,
      routes: AppRouter.routes,
    );
  }
}
