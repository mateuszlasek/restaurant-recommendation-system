import 'package:flutter/material.dart';

import '../services/restaurant/restaurant_data_service.dart';

class SearchSection extends StatefulWidget {
  @override
  _SearchSectionState createState() => _SearchSectionState();
}

class _SearchSectionState extends State<SearchSection> {
  final List<String> types = [
    'italian_restaurant',
    'seafood_restaurant',
    'chinese_restaurant',
    'cafe',
    'bar'
  ];
  String? selectedType;
  List<Map<String, dynamic>> restaurants = [];
  bool isLoading = false;

  final RestaurantDataService _restaurantDataService = RestaurantDataService();

  Future<void> fetchRestaurants(String type) async {
    setState(() {
      isLoading = true;
    });

    try {
      // Use the RestaurantDataService to fetch recommended restaurants
      List<Map<String, dynamic>> recommendedRestaurants = await _restaurantDataService.fetchRecommendedRestaurants([type]);

      setState(() {
        restaurants = recommendedRestaurants; // Update the state with the recommended restaurants
      });
    } catch (e) {
      print('Error fetching restaurants: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Dropdown menu for selecting the type of restaurant
              DropdownButton<String>(
                hint: Text('Select Type'),
                value: selectedType,
                onChanged: (value) {
                  setState(() {
                    selectedType = value;
                  });
                },
                items: types.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: selectedType != null
                    ? () => fetchRestaurants(selectedType!) // Pass the selected type as a single string
                    : null,
              ),
            ],
          ),
          const SizedBox(height: 16),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Expanded(
            child: ListView.builder(
              itemCount: restaurants.length,
              itemBuilder: (context, index) {
                final restaurant = restaurants[index];
                final displayName = restaurant['displayName']?['text'] ?? 'Unknown name';
                final formattedAddress = restaurant['formattedAddress'] ?? 'No address available';

                return ListTile(
                  title: Text(displayName), // Use the correct field for name
                  subtitle: Text(formattedAddress), // Use the correct field for address
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
