class ApiConstants {
  // Replace with your Mockaroo API URL
  static const String baseUrl = 'https://api.mockaroo.com/api/307607f0';
  static const String coffeeBaseUrl = 'https://api.mockaroo.com/api/ecc5e430';
  static const String apiKey = '9d3cb8e0';  // Replace with your API key

  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'X-API-Key': apiKey,
  };

  static String getCoffeeUrl({int count = 5}) {
    return '$coffeeBaseUrl?count=$count&key=$apiKey';
  }

}