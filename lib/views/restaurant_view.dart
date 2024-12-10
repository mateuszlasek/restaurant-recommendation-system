import 'package:flutter/material.dart';
import '../services/restaurant/restaurant_data_service.dart';
import 'restaurant_detail_screen.dart';

class RestaurantScreen extends StatefulWidget {
  @override
  _RestaurantScreenState createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  final RestaurantDataService _restaurantDataService = RestaurantDataService();
  List<Map<String, dynamic>> _restaurants = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchRestaurants();
  }

  Future<void> _fetchRestaurants() async {
    setState(() => _isLoading = true);
    try {
      _restaurants = await _restaurantDataService.fetchRecommendedRestaurants(["restaurant"]);
    } catch (e) {
      print('Error in fetching restaurants: $e');
    } finally {
      setState(() => _isLoading = false);
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
          final displayName = restaurant['displayName']?['text'] ?? 'Unknown name';
          final formattedAddress = restaurant['formattedAddress'] ?? 'No address available';
          final rating = restaurant['rating']?.toString() ?? 'N/A';

          return ListTile(
            title: Text(displayName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(formattedAddress),
                Text('Rating: $rating', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RestaurantDetailScreen(restaurant: restaurant),
              ),
            ),
          );
        },
      ),
    );
  }
}
