import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:proj_inz/components/restaurant_info_widget.dart';
import 'package:proj_inz/models/google_api_model.dart';

class FavoriteSection extends StatefulWidget {
  const FavoriteSection({super.key});

  @override
  State<FavoriteSection> createState() => _FavoriteSectionState();
}

class _FavoriteSectionState extends State<FavoriteSection> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  Set<String> _favoriteRestaurantIds = {}; // Zbiór ID ulubionych restauracji
  List<Place> _favoriteRestaurants = [];
  bool isLoading = true;

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
        _favoriteRestaurantIds = data.keys.toSet();

        _favoriteRestaurants = data.entries.map((entry) {
          return Place.fromJson(Map<dynamic, dynamic>.from(entry.value));
        }).toList();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
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
        'name': restaurant.displayName.text,
        'address': restaurant.shortFormattedAddress,
        'rating': restaurant.rating,
        'userRatingCount': restaurant.userRatingCount,
        'priceLevel': restaurant.priceLevel,
        'category': restaurant.primaryTypeDisplayName.text,
        'accessibilityOptions': restaurant.accessibilityOptions.wheelchairAccessibleEntrance,
        'servesLunch': restaurant.servesLunch,
        'servesWine': restaurant.servesWine,
        'paymentOptions': {
          'acceptsCreditCards': restaurant.paymentOptions.acceptsCreditCards,
          'acceptsDebitCards': restaurant.paymentOptions.acceptsDebitCards,
          'acceptsNfc': restaurant.paymentOptions.acceptsNfc,
        },
        'goodForWatchingSports': restaurant.goodForWatchingSports,
        'location': {
          'latitude': restaurant.location.latitude,
          'longitude': restaurant.location.longitude,
        },
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ulubione'),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.amber)
            : RefreshIndicator(
          onRefresh: _loadFavorites,
          color: Colors.amber,
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _favoriteRestaurants.length,
                  itemBuilder: (context, index) {
                    final place = _favoriteRestaurants[index];
                    final restaurantId = place.id;

                    return Column(
                      children: [
                        RestaurantWidget(place: place, favoriteRestaurantIds: _favoriteRestaurantIds,),
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
      ),
    );
  }
}

