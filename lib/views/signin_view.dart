import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../models/signin_model.dart'; // signin model (M)
import '../utils/routes.dart'; // deals with routing this View(V)
import '../controllers/signin_controller.dart'; // signin controller(C)

class SigninView extends StatefulWidget {
  const SigninView({super.key});

  
  @override
  _SigninViewState createState() => _SigninViewState();
}

class _SigninViewState extends State<SigninView> {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign in page'),
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
  // Controller fields
  final _emailFieldController = TextEditingController(); // email
  final _passwordFieldController = TextEditingController(); // password


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
            TextFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.email),
                hintText: 'Enter your email',
                labelText: 'Email',
              ),
              controller: _emailFieldController,
              validator: (val) {
                if (val == null || val.isEmpty) return 'Email is required';
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(val)) return 'Enter a valid email';
                return null;
              },
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
              child: Text('Login'),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    final user = await SigninController().signIn(
                      _emailFieldController.text,
                      _passwordFieldController.text,
                    );
                    if (user != null) {
                      _showAlert(
                        context,
                        'Success',
                        'Login successful!',
                        AlertType.success,
                      );    
                      
                      // Navigate to main menu
                    }
                  } catch (e) {
                    _showAlert(
                      context,
                      'Error',
                      'Please Enter a valid account credentials.',
                      AlertType.error,
                    );  
                    // Show error alert
                  }


                  
                }
              },
            ),
            SizedBox(height: 20),
            TextButton(
              child: Text(
                'Don\'t have an account? Sign Up',
                style: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.pushNamed(context, Routes.signup);
              },
            )
          ],
        ),
      ),
    );
  }
}
