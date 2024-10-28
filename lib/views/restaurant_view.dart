import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RestaurantScreen extends StatefulWidget {
  @override
  _RestaurantScreenState createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  List<dynamic> _restaurants = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadRestaurants();
  }

  // Funkcja pobierająca listę restauracji
  Future<void> _loadRestaurants() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Stałe współrzędne dla Warszawy
      double latitude = 52.2297;
      double longitude = 21.0122;

      // Wywołanie funkcji pobierającej dane
      final restaurants = await fetchNearbyRestaurants(latitude, longitude);
      setState(() {
        _restaurants = restaurants;
      });
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Funkcja wysyłająca zapytanie do Google Places API
  Future<List<dynamic>> fetchNearbyRestaurants(double latitude, double longitude) async {
    const apiKey = 'AIzaSyDr4f6_EGr7hJsYei32vhMoJlt6gSthQdw';  // Twój klucz API
    final radius = 300; // Promień w metrach
    final type = 'restaurant'; // Typ miejsca

    // Tworzenie URL do zapytania
    final url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&radius=$radius&type=$type&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      log('data: $data');
      return data['results'];
    } else {
      throw Exception('Nie udało się pobrać danych z Google Places API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nearby Restaurants'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _restaurants.length,
        itemBuilder: (context, index) {
          final restaurant = _restaurants[index];
          return ListTile(
            title: Text(restaurant['name']),
            subtitle: Text(restaurant['vicinity']),
          );
        },
      ),
    );
  }
}