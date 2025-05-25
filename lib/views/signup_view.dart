import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../models/signup_model.dart'; // Signup model (M)
import '../utils/routes.dart'; // deals with routing this View(V)
import '../controllers/Signup_controller.dart'; // Corrected import casing
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  
  @override
  _SignupViewState createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign up page'),
        backgroundColor: Colors.brown,
      ),
     
      body: Center(
        child: Builder(
          builder: (context) {
            return Column(
              children: [
                CreateUserForm(),
              ],
            );
          },
        ),
      ),
    );
  }
}

class CreateUserForm extends StatefulWidget {
  const CreateUserForm({super.key});

  // class for create user form validation
  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<CreateUserForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailFieldController = TextEditingController(); // email
  final _passwordFieldController = TextEditingController(); // password

  bool isValidEmail(String input) {
    final emailRegExp =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegExp.hasMatch(input);
  }

  bool isValidUsername(String input) {
    // Username should be 3-20 characters, alphanumeric and underscores only
    final usernameRegExp = RegExp(r'^[a-zA-Z0-9_]{3,20}$');
    return usernameRegExp.hasMatch(input);
  }

  bool isValidPassword(String input) {
    if (input.length < 6) {
      // Check for minimum length
      return false;
    }

    if (!RegExp(r'[A-Z]').hasMatch(input)) {
      // Check for at least one uppercase letter
      return false;
    }

    if (!RegExp(r'[a-z]').hasMatch(input)) {
      // Check for at least one lowercase letter
      return false;
    }

    if (!RegExp(r'[0-9]').hasMatch(input)) {
      // Check for at least one number
      return false;
    }

    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(input)) {
      // Check for at least one special character
      return false;
    }

    if (input.contains(' ')) {
      // Check for no spaces
      return false;
    }
    return true;
  }

  void _showAlert(
      BuildContext context, String title, String message, AlertType alertType) {
    Alert(
      context: context,
      type: alertType,
      title: title,
      desc: message,
      buttons: [
        DialogButton(
          onPressed: () => Navigator.pop(context),
          width: 120,
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        )
      ],
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Username field
            TextFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.person),
                hintText: 'Enter your username',
                labelText: 'Username',
              ),
              controller: _usernameController,
              validator: (val) {
                if (val == null || val.isEmpty) return 'Username is required';
                if (!isValidUsername(val)) return 'Username must be 3-20 characters, letters, numbers, and underscores only';
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.email),
                hintText: 'Enter your email',
                labelText: 'Email',
              ),
              controller: _emailFieldController,
              validator: (val) => isValidEmail(val!) ? null : 'Invalid email',
            ),
            TextFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.lock),
                hintText: 'Enter Password',
                labelText: 'Password',
              ),
              obscureText: true,
              controller: _passwordFieldController,
              validator: (val) {
                if (val == null || val.isEmpty) return 'Password is required';
                if (!isValidPassword(val)) return 'Password must be at least 6 characters with uppercase, lowercase, number, and special character';
                return null;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: Text(
                'Sign Up',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    final user = await SignupController().signUp(
                      _emailFieldController.text,
                      _passwordFieldController.text,
                    );

                    if (user != null) {
                      // Set the display name for the user
                      await user.updateDisplayName(_usernameController.text);
                      
                      _showAlert(
                        context,
                        'Success',
                        'Account created successfully!',
                        AlertType.success,
                      );
                      
                      // Navigate to sign in page after successful signup
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        Routes.signin,
                        (Route<dynamic> route) => false,
                      );
                    }
                  } catch (e) {
                    _showAlert(
                      context,
                      'Error',
                      'Signup failed: ${e.toString()}',
                      AlertType.error,
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
