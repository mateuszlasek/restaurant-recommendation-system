import 'package:flutter/material.dart';
import '../data/restaurant_types.dart';
import '../services/restaurant/restaurant_data_service.dart';

class SearchSection extends StatefulWidget {
  @override
  _SearchSectionState createState() => _SearchSectionState();
}

class _SearchSectionState extends State<SearchSection> {
  String? selectedCuisine;
  List<Map<String, dynamic>> restaurants = [];
  bool isLoading = false;

  final RestaurantDataService _restaurantDataService = RestaurantDataService();

  Future<void> fetchRestaurantsByCuisine(String cuisine) async {
    setState(() {
      isLoading = true;
    });

    try {
      // Pobierz typy restauracji powiązane z wybraną kuchnią
      List<String> typesToSearch = restaurantTypes[cuisine] ?? [];

      // Wywołanie API z listą typów restauracji
      List<Map<String, dynamic>> recommendedRestaurants = await _restaurantDataService.fetchRecommendedRestaurants(typesToSearch);

      setState(() {
        restaurants = recommendedRestaurants; // Aktualizacja stanu z wynikami
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
    List<String> cuisines = restaurantTypes.keys.toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Dropdown menu do wyboru kuchni
              DropdownButton<String>(
                hint: Text('Wybierz kuchnię'),
                value: selectedCuisine,
                onChanged: (value) {
                  setState(() {
                    selectedCuisine = value;
                  });
                },
                padding: const EdgeInsets.all(0),
                items: cuisines.map((String cuisine) {
                  return DropdownMenuItem<String>(
                    value: cuisine,
                    child: Text(cuisine),
                  );
                }).toList(),
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: selectedCuisine != null
                    ? () => fetchRestaurantsByCuisine(selectedCuisine!) // Przekaż wybraną kuchnię
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
                  title: Text(displayName), // Wyświetl nazwę restauracji
                  subtitle: Text(formattedAddress), // Wyświetl adres restauracji
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
