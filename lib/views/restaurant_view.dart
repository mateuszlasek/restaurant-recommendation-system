// restaurant_screen.dart
import 'package:flutter/material.dart';
import '../services/google_api/google_api_service.dart';

class RestaurantScreen extends StatefulWidget {
  @override
  _RestaurantScreenState createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  final RestaurantService _restaurantService = RestaurantService();
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
      double latitude = 50.0737696;
      double longitude = 19.9058631;

      // Wywołanie funkcji pobierającej dane z serwisu
      final restaurants = await _restaurantService.fetchNearbyRestaurants(latitude, longitude);
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
