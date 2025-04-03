import 'package:flutter/material.dart';
import '../views/user_profile_view.dart';
// Import other views

class Routes {
  static const String userProfile = '/user-profile';
  // Add other routes

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      userProfile: (context) => UserProfileView(),
      // Add other routes
    };
  }
}