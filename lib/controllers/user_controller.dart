import '../models/user_model.dart';
import '../services/api_service.dart';

class UserController {
  final ApiService _apiService = ApiService();

  Future<List<User>> getAllUsers() async {
    try {
      return await _apiService.getUsers();
    } catch (e) {
      throw Exception('Error in UserController: $e');
    }
  }

  Future<User> getUserById(int id) async {
    try {
      return await _apiService.getUser(id);
    } catch (e) {
      throw Exception('Error in UserController: $e');
    }
  }
}