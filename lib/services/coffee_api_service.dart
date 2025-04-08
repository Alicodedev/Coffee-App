// lib/services/coffee_api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/coffee_model.dart';
import '../utils/constants.dart';

class CoffeeApiService {
  static final CoffeeApiService _instance = CoffeeApiService._internal();
  factory CoffeeApiService() => _instance;
  CoffeeApiService._internal();

  Future<List<Coffee>> getCoffeeFlavors() async {
    try {
      // Using the helper method from ApiConstants
      final url = ApiConstants.getCoffeeUrl();
      print('Calling Coffee API: $url'); // For debugging

      final response = await http.get(
        Uri.parse(url),
        headers: ApiConstants.headers,
      );

      print('Response status: ${response.statusCode}'); // For debugging
      print('Response body: ${response.body}'); // For debugging

      if (response.statusCode == 200) {
        List jsonResponse = jsonDecode(response.body);
        return jsonResponse.map((data) => Coffee.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load coffee flavors: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('Error in getCoffeeFlavors: $e');
      print('Stack trace: $stackTrace');
      throw Exception('Failed to load coffee flavors: $e');
    }

  }

}