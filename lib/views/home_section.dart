import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:proj_inz/components/restaurant_info_widget.dart';
import 'package:proj_inz/models/google_api_model.dart';
import '../services/restaurant/restaurant_data_service.dart';

class HomeSection extends StatefulWidget {
  HomeSection({super.key});

  @override
  State<HomeSection> createState() => _HomeSectionState();
}

class _HomeSectionState extends State<HomeSection> {
  final RestaurantDataService _dataService = RestaurantDataService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  List<Place> recommendedRestaurants = [];
  Set<String> _favoriteRestaurantIds = {}; // Zbiór ID ulubionych restauracji
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRecommendations();
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

  // Funkcja do zmiany statusu ulubionych
  Future<void> _toggleFavorite(Place restaurant) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final userFavoritesRef = _database.child('usersFavorites/${user.uid}/${restaurant.id}');

    if (_favoriteRestaurantIds.contains(restaurant.id)) {
      // Usuń z ulubionych
      setState(() => _favoriteRestaurantIds.remove(restaurant.id));
      await userFavoritesRef.remove();
    } else {
      // Dodaj do ulubionych
      setState(() => _favoriteRestaurantIds.add(restaurant.id));
      await userFavoritesRef.set({
        'name': restaurant.name,
        'displayName': {
          'text': restaurant.displayName.text,
          'languageCode': restaurant.displayName.languageCode
        },
        'shortFormattedAddress': restaurant.shortFormattedAddress,
        'rating': restaurant.rating,
        'userRatingCount': restaurant.userRatingCount,
        'priceLevel': restaurant.priceLevel,
        'primaryTypeDisplayName': {
          'text': restaurant.primaryTypeDisplayName.text,
          'languageCode': restaurant.primaryTypeDisplayName.languageCode
        },
        'location': {
          'latitude': restaurant.location.latitude,
          'longitude': restaurant.location.longitude,
        },
      });
    }
  }

  Future<void> _fetchRecommendations() async {
    try {
      List<Map<String, dynamic>> restaurantData = await _dataService.fetchRecommendedRestaurants(["restaurant"]);
      setState(() {
        recommendedRestaurants = restaurantData.map((data) => Place.fromJson(data)).toList();
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching recommendations: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: isLoading
          ? const CircularProgressIndicator(color: Colors.amber)
          : RefreshIndicator(
        onRefresh: _fetchRecommendations,
        color: Colors.amber,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: recommendedRestaurants.length,
                itemBuilder: (context, index) {
                  final place = recommendedRestaurants[index];
                  final restaurantId = place.id;

                  return Column(
                    children: [
                      RestaurantWidget(place: place, favoriteRestaurantIds: _favoriteRestaurantIds,),
                      // ListTile(
                      //   title: RestaurantWidget(place: place), // Twoje detale restauracji
                      //   trailing: IconButton(
                      //     icon: Icon(
                      //       _favoriteRestaurantIds.contains(restaurantId)
                      //           ? Icons.star
                      //           : Icons.star_border,
                      //       color: _favoriteRestaurantIds.contains(restaurantId)
                      //           ? Colors.yellow
                      //           : Colors.grey,
                      //     ),
                      //     onPressed: () => _toggleFavorite(place),
                      //   ),
                      // ),
                      const Divider(
                        height: 0,
                        thickness: 1,
                        color: Colors.amber,
                        indent: 0,
                        endIndent: 0,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
