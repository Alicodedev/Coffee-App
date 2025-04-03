import 'package:flutter/material.dart';
import 'utils/routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MVC Example App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: Routes.getRoutes(),
      initialRoute: Routes.userProfile,
    );
  }
}