// lib/views/main_menu_view.dart

import 'package:flutter/material.dart';
import '../controllers/coffee_controller.dart';
import '../models/coffee_model.dart';
import '../utils/routes.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

class MainMenuView extends StatefulWidget {
  const MainMenuView({super.key});

  @override
  _MainMenuViewState createState() => _MainMenuViewState();
}

class _MainMenuViewState extends State<MainMenuView> {
  final CoffeeController _controller = CoffeeController();
  final fb_auth.FirebaseAuth _firebaseAuth = fb_auth.FirebaseAuth.instance;
  fb_auth.User? _currentUser;
  bool showFavorites = false;

  @override
  void initState() {
    super.initState();
    _currentUser = _firebaseAuth.currentUser;
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await _firebaseAuth.signOut();
      Navigator.of(context).pushNamedAndRemoveUntil(Routes.signin, (Route<dynamic> route) => false);
    } catch (e) {
      print("Error signing out: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coffee App'),
        backgroundColor: Colors.brown,
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
          // Favorites toggle button
          IconButton(
            icon: Icon(
              showFavorites ? Icons.star : Icons.star_border,
              color: showFavorites ? Colors.amber : Colors.white,
            ),
            onPressed: () {
              setState(() {
                showFavorites = !showFavorites;
              });
            },
          ),
          // Logout button
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => _signOut(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Coffee List Section
          Container(
            height: 300, // Adjust height as needed
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  showFavorites ? 'Favorite Coffees' : 'Popular Coffees',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: FutureBuilder<List<Coffee>>(
                    future: showFavorites
                        ? _controller.getFavoriteCoffees()
                        : _controller.getAllCoffeeFlavors(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Text(
                              showFavorites
                                  ? 'No favorite coffees yet'
                                  : 'No coffees available'
                          ),
                        );
                      }

                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          Coffee coffee = snapshot.data![index];
                          return Card(
                            margin: EdgeInsets.only(right: 16),
                            child: Container(
                              width: 200,
                              padding: EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.coffee,
                                    size: 48,
                                    color: Colors.brown,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    coffee.flavorName,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Navigation Buttons
          Expanded(
            child: Container(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildNavigationButton(
                    context,
                    'Make Coffee',
                    Icons.coffee_maker,
                    Routes.makeCoffee,
                  ),
                  SizedBox(height: 16),
                  _buildNavigationButton(
                    context,
                    'Statistics',
                    Icons.bar_chart,
                    Routes.statistics,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButton(
      BuildContext context,
      String text,
      IconData icon,
      String route,
      ) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.brown,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: () {
          Navigator.pushNamed(context, route);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24,color: Colors.white60,),
            SizedBox(width: 12),
            Text(
              text,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}