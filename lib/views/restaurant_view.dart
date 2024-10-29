import 'package:flutter/material.dart';
import '../services/google_api/google_api_service.dart';
import 'restaurant_detail_screen.dart';

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

  Future<void> _loadRestaurants() async {
    setState(() {
      _isLoading = true;
    });

    try {
      double latitude = 50.0737696;
      double longitude = 19.9058631;

      final List<dynamic> response = await _restaurantService.fetchNearbyRestaurants(latitude, longitude);
      setState(() {
        _restaurants = response;
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

          if (restaurant == null || !restaurant.containsKey('displayName')) {
            return ListTile(
              title: Text('Unknown restaurant'),
            );
          }

          final displayName = restaurant['displayName']?['text'] ?? 'Unknown name';
          final formattedAddress = restaurant['formattedAddress'] ?? 'No address available';
          final rating = restaurant['rating']?.toString() ?? 'N/A';
          final location = restaurant['location'];
          final latitude = location?['latitude']?.toString() ?? 'N/A';
          final longitude = location?['longitude']?.toString() ?? 'N/A';

          return ListTile(
            title: Text(displayName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(formattedAddress),
                Text(
                  'Rating: $rating',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Lat: $latitude, Long: $longitude',
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RestaurantDetailScreen(restaurant: restaurant),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
