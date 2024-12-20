import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../components/restaurant_info_widget.dart';
import '../data/restaurant_types.dart';
import '../models/google_api_model.dart';
import '../services/restaurant/restaurant_data_service.dart';

class SearchSection extends StatefulWidget {
  @override
  _SearchSectionState createState() => _SearchSectionState();
}

class _SearchSectionState extends State<SearchSection> {
  String? selectedCuisine;
  List<Map<String, dynamic>> restaurants = [];
  List<Place> recommendedRestaurantsList = [];
  bool isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  Set<String> _favoriteRestaurantIds = {};

  final RestaurantDataService _restaurantDataService = RestaurantDataService();

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  // Ładowanie ulubionych restauracji z Firebase
  Future<void> _loadFavorites() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final userFavoritesRef = _database.child('usersFavorites/${user.uid}');
    final snapshot = await userFavoritesRef.get();

    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      setState(() {
        // Ustawiamy ulubione restauracje na podstawie ID z Firebase
        _favoriteRestaurantIds = data.keys.toSet();
      });
    }
  }

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
        recommendedRestaurantsList = restaurants.map((data) => Place.fromJson(data)).toList();
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              DropdownButton<String>(
                hint: Text('Select Type'),
                value: selectedCuisine,
                onChanged: (value) {
                  setState(() {
                    selectedCuisine = value;
                  });
                },
                items: cuisines.map((String cuisine) {
                  return DropdownMenuItem<String>(
                    value: cuisine,
                    child: Text(cuisine),
                  );
                }).toList(),
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: selectedCuisine != null
                    ? () => fetchRestaurantsByCuisine(selectedCuisine!) // Pass the selected type as a single string
                    : null,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        isLoading
            ? const Center(child: CircularProgressIndicator())
            : Expanded(
          child: ListView.builder(
            itemCount: recommendedRestaurantsList.length,
            itemBuilder: (context, index) {
              final place = recommendedRestaurantsList[index];
              return Column(
                children: [
                  RestaurantWidget(place: place, favoriteRestaurantIds: _favoriteRestaurantIds,),
                  const Divider(
                    height: 0,
                    thickness: 1,
                    color: Colors.amber,
                    indent: 0,
                    endIndent: 0,
                  )
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
