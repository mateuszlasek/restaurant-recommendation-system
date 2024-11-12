import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class RestaurantService {
  static const String _apiKey = 'AIzaSyDr4f6_EGr7hJsYei32vhMoJlt6gSthQdw';  // Twój klucz API
  static const String _baseUrl = 'https://places.googleapis.com/v1/places:searchNearby';

  Future<List<dynamic>> fetchNearbyRestaurants(double latitude, double longitude) async {
    final url = Uri.parse(_baseUrl);

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
      'X-Goog-FieldMask': ''
          'places.name,'
          'places.id,'
          'places.types,'  // Wybór wyświetlanych pól
          'places.formattedAddress,'  // Wybór wyświetlanych pól
          'places.internationalPhoneNumber,'  // Wybór wyświetlanych pól
          'places.addressComponents,'  // Wybór wyświetlanych pól
          'places.location,'  // Wybór wyświetlanych pól
          'places.viewport,'  // Wybór wyświetlanych pól
          'places.rating,'  // Wybór wyświetlanych pól
          'places.googleMapsUri,'  // Wybór wyświetlanych pól
          'places.websiteUri,'  // Wybór wyświetlanych pól
          'places.regularOpeningHours,'  // Wybór wyświetlanych pól
          'places.businessStatus,'  // Wybór wyświetlanych pól
          'places.priceLevel,'  // Wybór wyświetlanych pól
          'places.userRatingCount,'  // Wybór wyświetlanych pól
          'places.displayName,'  // Wybór wyświetlanych pól
          'places.primaryTypeDisplayName,'  // Wybór wyświetlanych pól
          'places.takeout,'  // Wybór wyświetlanych pól
          'places.delivery,'  // Wybór wyświetlanych pól
          'places.dineIn,'  // Wybór wyświetlanych pól
          'places.curbsidePickup,'  // Wybór wyświetlanych pól
          'places.servesBreakfast,'  // Wybór wyświetlanych pól
          'places.servesLunch,'  // Wybór wyświetlanych pól
          'places.servesDinner,'  // Wybór wyświetlanych pól
          'places.servesBeer,'  // Wybór wyświetlanych pól
          'places.servesWine,'  // Wybór wyświetlanych pól
          'places.servesVegetarianFood,'  // Wybór wyświetlanych pól
          'places.primaryType,'  // Wybór wyświetlanych pól
          'places.shortFormattedAddress,'  // Wybór wyświetlanych pól
          'places.outdoorSeating,'  // Wybór wyświetlanych pól
          'places.liveMusic,'  // Wybór wyświetlanych pól
          'places.menuForChildren,'  // Wybór wyświetlanych pól
          'places.servesCocktails,'  // Wybór wyświetlanych pól
          'places.servesDessert,'  // Wybór wyświetlanych pól
          'places.servesCoffee,'  // Wybór wyświetlanych pól
          'places.goodForChildren,'  // Wybór wyświetlanych pól
          'places.allowsDogs,'  // Wybór wyświetlanych pól
          'places.restroom,'  // Wybór wyświetlanych pól
          'places.goodForWatchingSports,'  // Wybór wyświetlanych pól
          'places.paymentOptions,'  // Wybór wyświetlanych pól
          'places.parkingOptions,'  // Wybór wyświetlanych pól
          'places.accessibilityOptions,'  // Wybór wyświetlanych pól
    };

    final response = await http.post(url, headers: headers, body: json.encode(requestBody));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['places'];
    } else {
      log('Request failed with status: ${response.statusCode}');
      log('Response body: ${response.body}');
      throw Exception('Nie udało się pobrać danych z Google Places API. Status: ${response.statusCode}');
    }
  }
}
