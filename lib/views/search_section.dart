import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../services/google_api/google_api_service.dart';
import 'dart:developer';

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

  final RestaurantService _restaurantService = RestaurantService();

  Future<void> fetchRestaurants(String type) async {
    setState(() {
      isLoading = true;
    });

    try {
      // Pass only the selected type as a single value (not as a list)
      List<dynamic> response = await _restaurantService.fetchNearbyRestaurants(50.060562, 19.937711, [type]);

      setState(() {
        // Update the state with the fetched restaurants
        // Assuming the 'places' field in the response contains the list of restaurants
        restaurants = List<Map<String, dynamic>>.from(response);
      });

    } catch (e) {
      print('Error: $e');
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

                // Ensure you're accessing the correct fields in the response
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
