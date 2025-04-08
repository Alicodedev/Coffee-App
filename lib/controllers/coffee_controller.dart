// lib/controllers/coffee_controller.dart

import '../models/coffee_model.dart';
import '../services/coffee_api_service.dart';
import '../services/local_storage_service.dart';

class CoffeeController {
  final CoffeeApiService _apiService = CoffeeApiService();
  final LocalStorageService _localStorage = LocalStorageService();

  Future<List<Coffee>> getAllCoffeeFlavors() async {
    try {
      return await _apiService.getCoffeeFlavors();
    } catch (e) {
      print('Error in CoffeeController: $e');
      throw Exception('Error in CoffeeController: $e');
    }
  }

  Future<void> selectCoffee(Coffee coffee) async {
    try {
      print('Coffee selected: ${coffee.flavorName}');

    } catch (e) {
      print('Error adding to favorites: $e');
      throw Exception('Error adding to favorites: $e');
    }
  }

  // get Favorite Coffee
  Future<List<Coffee>> getFavoriteCoffees() async {
    try {
      return await _localStorage.getFavoriteCoffees();
    } catch (e) {
      print('Error getting favorites: $e');
      return []; // Return empty list if there's an error
    }
  }
}