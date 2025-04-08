// lib/views/main_menu_view.dart

import 'package:flutter/material.dart';
import '../controllers/coffee_controller.dart';
import '../models/coffee_model.dart';
import '../utils/routes.dart';

class MainMenuView extends StatefulWidget {
  @override
  _MainMenuViewState createState() => _MainMenuViewState();
}

class _MainMenuViewState extends State<MainMenuView> {
  final CoffeeController _controller = CoffeeController();
  bool showFavorites = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coffee App'),
        backgroundColor: Colors.brown,
        actions: [
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
    return Container(
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