// lib/services/local_storage_service.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/coffee_model.dart';

class LocalStorageService {
  static const String _favoritesKey = 'favorite_coffees';

  // Get all favorite coffees
  Future<List<Coffee>> getFavoriteCoffees() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList(_favoritesKey) ?? [];

    return favorites.map((String jsonString) {
      Map<String, dynamic> json = jsonDecode(jsonString);
      return Coffee.fromJson(json);
    }).toList();
  }
}