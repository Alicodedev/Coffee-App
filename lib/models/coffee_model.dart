// lib/models/coffee_model.dart

class Coffee {
  final int id;
  final String flavorName;

  Coffee({
    required this.id,
    required this.flavorName,
  });

  factory Coffee.fromJson(Map<String, dynamic> json) {
    try {
      return Coffee(
        id: json['id'] as int,
        flavorName: json['flavor_name'] as String,
      );
    } catch (e) {
      print('Error parsing JSON: $e');
      print('JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'flavor_name': flavorName,
    };
  }
}