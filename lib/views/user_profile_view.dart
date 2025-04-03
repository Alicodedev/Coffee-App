import 'package:flutter/material.dart';
import '../controllers/user_controller.dart';
import '../models/user_model.dart';

class UserProfileView extends StatelessWidget {
  final UserController _userController = UserController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: Center(
        child: FutureBuilder<User>(
          future: _userController.getUserById(1),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Error: ${snapshot.error}',
                  style: TextStyle(color: Colors.red),
                ),
              );
            } else if (snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Name: ${snapshot.data!.firstName} ${snapshot.data!.lastName}'),
                  Text('Email: ${snapshot.data!.email}'),
                  Text('Phone: ${snapshot.data!.phoneNumber}'),
                ],
              );
            }
            return Text('No data');
          },
        ),
      ),
    );
  }
}