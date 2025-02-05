import 'dart:convert';
import 'dart:developer';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RestaurantService {

  static const String _baseUrl = 'https://places.googleapis.com/v1/places:searchNearby';

  Future<List<dynamic>> fetchNearbyRestaurants(double latitude, double longitude, List<String> includedTypes) async {
    final url = Uri.parse(_baseUrl);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? position = prefs.getStringList("Position");
    // // double? lng = prefs.getDouble('longitude');
    // // if (lat != null && lng != null) {
    // //   setState(() {
    // //     _selectedPosition = LatLng(lat, lng);
    // //   });
    // // }
    // print("Lat lang");
    // print(position);

    final requestBody = {
      "includedTypes": includedTypes,
      "excludedTypes": ["hotel", "grocery_store", "gas_station"],
      "maxResultCount": 15,
      "locationRestriction": {
        "circle": {
          "center": {
            "latitude": position?.first,
            "longitude": position?.last
          },
          "radius": 500.0
        }
      }
    };

    final apiKey = dotenv.env['GOOGLE_API_KEY'];
    if (apiKey == null) {
      throw Exception('GOOGLE_API_KEY not found in .env file');
    }

    // Nagłówki żądania
    final headers = {
      'Content-Type': 'application/json',
      'X-Goog-Api-Key': apiKey,
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
