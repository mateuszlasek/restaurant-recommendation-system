import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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
      Position position = await _determinePosition();
      final latitude = position.latitude;
      final longitude = position.longitude;

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

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
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
