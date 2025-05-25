import 'package:firebase_auth/firebase_auth.dart' as fb_auth; // Alias for Firebase Auth
import 'package:flutter/material.dart';
// import '../controllers/user_controller.dart'; // We'll use FirebaseAuth directly for now
// import '../models/user_model.dart'; // We'll use FirebaseUser directly
import '../utils/routes.dart'; // For navigation after logout

class UserProfileView extends StatefulWidget { // Changed to StatefulWidget
  const UserProfileView({super.key});

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> { // State class
  // final UserController _userController = UserController(); // Not using this for now
  final fb_auth.FirebaseAuth _firebaseAuth = fb_auth.FirebaseAuth.instance;
  fb_auth.User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = _firebaseAuth.currentUser;
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await _firebaseAuth.signOut();
      // Navigate back to the sign-in screen and remove all previous routes
      Navigator.of(context).pushNamedAndRemoveUntil(Routes.signin, (Route<dynamic> route) => false);
    } catch (e) {
      print("Error signing out: $e");
      // Optionally, show an error dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: const Text('Profile'),
        actions: [
          // Username text
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                _currentUser?.displayName ?? _currentUser?.email?.split('@')[0] ?? 'User',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          // Logout button
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => _signOut(context),
          ),
          // Add some padding at the end
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: _currentUser != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(
                    Icons.account_circle,
                    size: 100,
                    color: Colors.brown,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Welcome, ${_currentUser?.displayName ?? _currentUser?.email?.split('@')[0] ?? 'User'}!',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.brown,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Email: ${_currentUser!.email}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.brown[700],
                    ),
                  ),
                  if (_currentUser?.emailVerified == true)
                    const Chip(
                      label: Text('Email Verified'),
                      backgroundColor: Colors.green,
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                ],
              )
            : const Text('No user logged in.'), // Should not happen if routed correctly
      ),
    );
  }
}