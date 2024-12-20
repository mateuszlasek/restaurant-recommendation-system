import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:proj_inz/data/restaurant_emojis.dart';
import 'package:proj_inz/models/google_api_model.dart';

import '../views/restaurant_location_screen.dart';

class RestaurantWidget extends StatefulWidget {
  final Place place;
  final Set<String> favoriteRestaurantIds;

  const RestaurantWidget({super.key, required this.place, required this.favoriteRestaurantIds});

  @override
  _RestaurantWidgetState createState() => _RestaurantWidgetState();
}

class _RestaurantWidgetState extends State<RestaurantWidget> {
  final emojisList = restaurantTypesEmojis;

  bool showOptions = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  late Set<String> _favoriteRestaurantIds = widget.favoriteRestaurantIds;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

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


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          showOptions = !showOptions;
        });
      },
      child: Column(
        children: [
          // Main restaurant details container
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Placeholder for restaurant image
                Container(
                  width: 60,
                  height: 60,
                  child: Text(
                    emojisList[widget.place.types[0]] ?? "🍴",
                    style: const TextStyle(
                      fontSize: 40,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Restaurant information
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.place.displayName.text,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.place.primaryTypeDisplayName.text,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            widget.place.rating.toString(),
                            style: const TextStyle(color: Colors.amber),
                          ),
                          if (showOptions)
                            Text(
                              " (${widget.place.userRatingCount})",
                              style: const TextStyle(color: Colors.grey),
                            ),
                          const SizedBox(width: 8),
                          const Icon(Icons.location_on, size: 16),
                          Flexible(
                            child: Text(
                              widget.place.shortFormattedAddress,
                              softWrap: true,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RestaurantLocationScreen(
                              latitude: widget.place.location.latitude,
                              longitude: widget.place.location.longitude,
                              placeName: widget.place.displayName.text,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.map, size: 24),
                    ), // wyświetlanie lokalizacji restauracji
                    _buildPrice(widget.place.priceLevel)
                    /*
                    const Text(
                      '500m', // Update with real distance if available
                      style: TextStyle(color: Colors.grey),
                    ),
                     */
                  ],
                )
                // Distance (if available)

              ],
            ),
          ),
          // Options bar shown on tap
          if (showOptions)
            Container(
              decoration: const BoxDecoration(
                color: Colors.black26
              ),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildIcon(Icons.local_parking, 'Parking', widget.place.parkingOptions.freeParkingLot ? Colors.green : Colors.red),
                  _buildIcon(Icons.accessible, 'Accessible', widget.place.accessibilityOptions.wheelchairAccessibleEntrance ? Colors.green : Colors.red),
                  _buildIcon(Icons.eco, 'Vegetarian', widget.place.servesLunch ? Colors.green : Colors.white10),
                  _buildIcon(Icons.pets, 'Pets', widget.place.servesWine ? Colors.green : Colors.white10),
                  _buildIcon(Icons.credit_card, 'Credit', widget.place.paymentOptions.acceptsCreditCards || widget.place.paymentOptions.acceptsDebitCards ? Colors.green : Colors.red),
                  _buildIcon(Icons.nfc_rounded, 'NFC', widget.place.paymentOptions.acceptsNfc ? Colors.green : Colors.white10),
                  _buildIcon(Icons.live_tv_outlined, 'Sports', widget.place.goodForWatchingSports ? Colors.green : Colors.white10),
                  // _buildIcon(Icons.takeout_dining, 'Takeout', widget.place.takeout ? Colors.green : Colors.red),
                  IconButton(
                      onPressed: () {_toggleFavorite(widget.place);},
                      icon: Icon(
                        _favoriteRestaurantIds.contains(widget.place.id) ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                      )
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }

  // Helper method to build icons
  Widget _buildIcon(IconData icon, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color),
        // Text(label, style: TextStyle(fontSize: 10)),
      ],
    );
  }

  Widget _buildPrice(String priceLevel) {
    int level = 0;
    switch(priceLevel){
      case "PRICE_LEVEL_INEXPENSIVE":
        level = 1;
        break;
      case "PRICE_LEVEL_MODERATE":
        level = 2;
        break;
      case "PRICE_LEVEL_EXPENSIVE":
        level = 3;
        break;
      case "PRICE_LEVEL_VERY_EXPENSIVE":
        level = 4;
        break;
      default:
        level = 0;
        break;
    }

    List<Widget> dollarIcons = List.generate(
        level,
        (index) => const Text(
          "\$",
          style: TextStyle(
            color: Colors.green,
            fontSize: 15
          ),
        ),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: dollarIcons,
    );
  }
}
