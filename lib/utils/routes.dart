import 'package:flutter/material.dart';
import '../views/user_profile_view.dart';
import '../views/make_coffee_view.dart';
import '../views/main_menu_view.dart';
// Import other views

class Routes {
  static const String mainMenu = '/';
  static const String userProfile = '/user-profile';
  static const String makeCoffee = '/make-coffee';
  static const String statistics = '/stat-coffee';
  // Add other routes

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      mainMenu: (context) => MainMenuView(),
      userProfile: (context) => UserProfileView(),
      makeCoffee: (context) => MakeCoffeeView(),// Add other routes
      //statistics: (context) => StatisticsView(),
    };
  }
}