// restaurant_service.dart
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class RestaurantService {
  static const String _apiKey = '';  // Twój klucz API
  static const String _baseUrl = 'https://places.googleapis.com/v1/places:searchNearby';

  Future<List<dynamic>> fetchNearbyRestaurants(double latitude, double longitude) async {
    final url = Uri.parse(_baseUrl);

    // Treść żądania JSON
    final requestBody = {
      "includedTypes": ["restaurant"],
      "maxResultCount": 10,
      "locationRestriction": {
        "circle": {
          "center": {
            "latitude": latitude,
            "longitude": longitude
          },
          "radius": 500.0  // Promień w metrach
        }
      }
    };

    // Nagłówki żądania
    final headers = {
      'Content-Type': 'application/json',
      'X-Goog-Api-Key': _apiKey,
      'X-Goog-FieldMask': 'places.displayName,places.location'  // Wybór wyświetlanych pól
    };

    // Wysłanie żądania POST
    final response = await http.post(url, headers: headers, body: json.encode(requestBody));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      log('data: $data');
      return data['places'];
    } else {
      // Wyświetlenie statusu i treści odpowiedzi w przypadku błędu
      log('Request failed with status: ${response.statusCode}');
      log('Response body: ${response.body}');
      throw Exception('Nie udało się pobrać danych z Google Places API. Status: ${response.statusCode}');
    }
  }
}
