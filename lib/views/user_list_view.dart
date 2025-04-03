import 'package:flutter/material.dart';
import '../controllers/user_controller.dart';
import '../models/user_model.dart';

class UserListView extends StatelessWidget {
  final UserController _userController = UserController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: FutureBuilder<List<User>>(
        future: _userController.getAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                User user = snapshot.data![index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(user.firstName[0]),
                  ),
                  title: Text('${user.firstName} ${user.lastName}'),
                  subtitle: Text(user.email),
                  trailing: Text(user.phoneNumber),
                  onTap: () {
                    // Handle tap
                  },
                );
              },
            );
          }
          return Center(child: Text('No data'));
        },
      ),
    );
  }
}