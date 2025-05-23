// lib/main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'utils/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCJ2zqXbwaf1peJQ7IK9lvYpPCcc-m8sVo",
      authDomain: "coffee-base-ede98.firebaseapp.com",
      projectId: "coffee-base-ede98",
      storageBucket: "coffee-base-ede98.firebasestorage.app",
      messagingSenderId: "602775338141",
      appId: "1:602775338141:web:ba8f512762b58ebdc4a874"
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coffee App',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        scaffoldBackgroundColor: Colors.brown[50],
      ),
      routes: Routes.getRoutes(),
      initialRoute: Routes.signin,
    );
  }
}