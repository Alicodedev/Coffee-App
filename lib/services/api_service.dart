import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user_model.dart';
import '../utils/constants.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Get single user
  Future<User> getUser(int id) async {
    try {
      final url = '${ApiConstants.baseUrl}?count=1&key=${ApiConstants.apiKey}';
      print('Calling API: $url'); // Debug print

      final response = await http.get(
        Uri.parse(url),
        headers: ApiConstants.headers,
      );

      print('Response status: ${response.statusCode}'); // Debug print
      print('Response body: ${response.body}'); // Debug print

      if (response.statusCode == 200) {
        List jsonResponse = jsonDecode(response.body);
        return User.fromJson(jsonResponse.first);
      } else {
        throw Exception('Failed to load user: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getUser: $e'); // Debug print
      throw Exception('Failed to load user: $e');
    }
  }

  // Get list of users
  Future<List<User>> getUsers() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}?count=100&key=${ApiConstants.apiKey}'),
        headers: ApiConstants.headers,
      );

      if (response.statusCode == 200) {
        List jsonResponse = jsonDecode(response.body);
        return jsonResponse.map((data) => User.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load users: $e');
    }
  }
}