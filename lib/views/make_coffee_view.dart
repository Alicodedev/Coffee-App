// lib/views/make_coffee_view.dart

import 'package:flutter/material.dart';
import '../controllers/coffee_controller.dart';
import '../models/coffee_model.dart';

class MakeCoffeeView extends StatefulWidget {
  @override
  _MakeCoffeeViewState createState() => _MakeCoffeeViewState();
}

class _MakeCoffeeViewState extends State<MakeCoffeeView> {
  final CoffeeController _controller = CoffeeController();
  String selectedSize = 'Medium'; // Default size

  final List<String> sizes = ['Small', 'Medium', 'Large'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Coffee'),
        backgroundColor: Colors.brown,
      ),
      body: Column(
        children: [
          // Size selector at the top
          Container(
            padding: EdgeInsets.all(16.0),
            color: Colors.brown.shade50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Select Size: ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 16),
                DropdownButton<String>(
                  value: selectedSize,
                  items: sizes.map((String size) {
                    return DropdownMenuItem<String>(
                      value: size,
                      child: Text(
                        size,
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedSize = newValue!;
                    });
                  },
                ),
              ],
            ),
          ),
          // Coffee flavor list
          Expanded(
            child: FutureBuilder<List<Coffee>>(
              future: _controller.getAllCoffeeFlavors(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Coffee coffee = snapshot.data![index];
                      return Card(
                        margin: EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        elevation: 4.0,
                        child: ListTile(
                          leading: Icon(
                            Icons.coffee,
                            color: Colors.brown,
                            size: 32,
                          ),
                          title: Text(
                            coffee.flavorName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () {
                            _showOrderConfirmation(context, coffee);
                          },
                        ),
                      );
                    },
                  );
                }
                return Center(child: Text('No coffee flavors available'));
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showOrderConfirmation(BuildContext context, Coffee coffee) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Order'),
          content: Text(
              'Would you like to order a ${selectedSize.toLowerCase()} ${coffee.flavorName}?'
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
              ),
              child: Text('Order'),
              onPressed: () {
                // Handle the order
                _controller.selectCoffee(coffee);
                print('Ordered: ${selectedSize} ${coffee.flavorName}');
                Navigator.of(context).pop();

                // Show confirmation
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Ordered: ${selectedSize} ${coffee.flavorName}'
                    ),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}