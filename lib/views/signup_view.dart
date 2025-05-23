import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../models/signup_model.dart'; // Signup model (M)
import '../utils/routes.dart'; // deals with routing this View(V)
import '../controllers/Signup_controller.dart'; // Corrected import casing

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
  //final _nameFieldController = TextEditingController(); // username
  final _emailFieldController = TextEditingController(); // email
 // final _phoneFieldController = TextEditingController(); // phone number
  final _passwordFieldController = TextEditingController(); // password
 // final _ConfirmPassFieldController = TextEditingController(); // confirm password


bool isValidEmail(String input) {
  final emailRegExp =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  return emailRegExp.hasMatch(input);
}

//   bool isValidPhoneNumber(String input) {
//     final phoneRegExp = RegExp(r'^\d{10}$');
//     return phoneRegExp.hasMatch(input);
// }

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
            // TextFormField(
            //   decoration: InputDecoration(
            //     icon: Icon(Icons.person),
            //     hintText: 'Enter your name',
            //     labelText: 'Name',
            //   ),
            //   controller: _nameFieldController,
            //   validator: (val) {
            //     if (val == null || val.isEmpty) return 'Name is required';
            //     return null;
            //   },
            // ),
            TextFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.email),
                hintText: 'Enter your email',
                labelText: 'Email',
              ),
              controller: _emailFieldController,
              validator: (val) => isValidEmail(val!) ? null : 'Invalid email',
            ),
            // TextFormField(
            //   decoration: InputDecoration(
            //     icon: Icon(Icons.phone),
            //     hintText: 'Enter Phone number',
            //     labelText: 'Phone number',
            //   ),
            //   controller: _phoneFieldController,
            //   validator: (val) {
            //     if (val == null || val.isEmpty) return 'Phone number is required';
            //     if (!isValidPhoneNumber(val)) return 'Phone number must be 10 digits';
            //     return null;
            //   },
            // ),
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
            // TextFormField(
            //   decoration: InputDecoration(
            //     icon: Icon(Icons.lock),
            //     hintText: 'Confirm password',
            //     labelText: 'Enter password again',
            //   ),
            //   obscureText: true,
            //   controller: _ConfirmPassFieldController,
            //   validator: (val) {
            //     if (val == null || val.isEmpty) return 'Confirm password is required';
            //     if (val != _passwordFieldController.text) return 'Passwords do not match';
            //     return null;
            //   },
            // ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Submit'),
              onPressed: () async { // Make onPressed async
                if (_formKey.currentState!.validate()) {
                  try {
                    final user = await SignupController().signUp(
                      _emailFieldController.text,
                      _passwordFieldController.text,
                    );

                    if (user != null) {
                      // User created successfully in Firebase Auth
                      // Now, you would typically save additional user details
                      // For example: await _signupController.saveUserDetails(user.uid, _nameFieldController.text, _phoneFieldController.text);
                      _showAlert(
                        context,
                        'Success',
                        'Account created successfully!',
                        AlertType.success,
                      );
                      // TODO: Navigate to another screen, e.g., Main Menu or Signin
                    } else {
                      // This case should ideally be caught by the catch block if signUp throws an error
                      _showAlert(
                        context,
                        'Error',
                        'Could not create account. Please try again.',
                        AlertType.error,
                      );
                    }
                  } catch (e) {
                    // Handle errors from Firebase (e.g., email already in use, weak password)
                    _showAlert(
                      context,
                      'Error',
                      'Signup failed: ${e.toString()}',
                      AlertType.error,
                    );
                  }
                } else {
                  _showAlert(
                    context,
                    'Error',
                    'Please fix the errors in the form.',
                    AlertType.error,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
