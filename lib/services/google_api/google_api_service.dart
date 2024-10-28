// restaurant_service.dart
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

class RestaurantService {
  static const String _apiKey = 'AIzaSyDr4f6_EGr7hJsYei32vhMoJlt6gSthQdw';  // Twój klucz API
  static const String _baseUrl = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json';

  Future<List<dynamic>> fetchNearbyRestaurants(double latitude, double longitude) async {
    final radius = 300; // Promień w metrach
    final type = 'restaurant'; // Typ miejsca

    // Tworzenie URL do zapytania
    final url =
        '$_baseUrl?location=$latitude,$longitude&radius=$radius&type=$type&key=$_apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      log('data: $data');
      return data['results'];
    } else {
      throw Exception('Nie udało się pobrać danych z Google Places API');
    }
  }
}
