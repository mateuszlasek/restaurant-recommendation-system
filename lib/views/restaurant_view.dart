import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:proj_inz/services/recomandation_algorithm/recommendation_service.dart'; // Serwis rekomendacji
import '../services/google_api/google_api_service.dart';
import 'restaurant_detail_screen.dart';
import '../../models/user_form_model.dart';

class RestaurantScreen extends StatefulWidget {
  @override
  _RestaurantScreenState createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final RestaurantService _restaurantService = RestaurantService(); // Serwis do restauracji
  List<Map<String, dynamic>> _restaurants = []; // Lista restauracji
  List<Map<String, dynamic>> _recommendedRestaurants = []; // Posortowane restauracje
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      String? uid = await getUserUID();
      if (uid != null) {
        UserFormModel? userForm = await getUserFormByUID(uid);
        if (userForm != null) {
          Map<String, bool> userPreferences = {
            'servesVegetarianFood': userForm.servesVegetarianFood,
            'menuForChildren': userForm.menuForChildren,
            'goodForChildren': userForm.goodForChildren,
            'allowsDogs': userForm.allowsDogs,
            'acceptsCreditCards': userForm.acceptsCreditCards,
            'acceptsDebitCards': userForm.acceptsDebitCards,
            'acceptsCashOnly': userForm.acceptsCashOnly,
            'acceptsNfc': userForm.acceptsNfc,
            'freeParkingLot': userForm.freeParkingLot,
            'paidParkingLot': userForm.paidParkingLot,
            'wheelchairAccessibleParking': userForm.wheelchairAccessibleParking,
            'wheelchairAccessibleEntrance': userForm.wheelchairAccessibleEntrance,
            'wheelchairAccessibleRestroom': userForm.wheelchairAccessibleRestroom,
          };

          Position position = await _determinePosition();
          final latitude = position.latitude;
          final longitude = position.longitude;
          final List<dynamic> response = await _restaurantService.fetchNearbyRestaurants(latitude, longitude);

          List<Map<String, dynamic>> restaurantList = List<Map<String, dynamic>>.from(response);

          RecommendationService recommendationService = RecommendationService(
            userPreferences: userPreferences,
            preferenceWeights: {
              'servesVegetarianFood': 2,
              'menuForChildren': 1,
              'goodForChildren': 1,
              'allowsDogs': 1,
              'acceptsCreditCards': 1,
              'acceptsDebitCards': 1,
              'acceptsCashOnly': 1,
              'acceptsNfc': 1,
              'freeParkingLot': 1,
              'paidParkingLot': 1,
              'wheelchairAccessibleParking': 1,
              'wheelchairAccessibleEntrance': 1,
              'wheelchairAccessibleRestroom': 1,
            },
          );

          List<Map<String, dynamic>> recommendedList = recommendationService.getRecommendations(restaurantList);

          if (recommendedList.isNotEmpty) {
            setState(() {
              _restaurants = recommendedList;
            });
          } else {
            setState(() {
              _restaurants = restaurantList;
            });
          }
        }
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  Future<String?> getUserUID() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      return null;
    }
  }

  Future<UserFormModel?> getUserFormByUID(String uid) async {
    try {
      DatabaseReference ref = _database.ref('user_forms/$uid');
      DataSnapshot snapshot = await ref.get();
      if (snapshot.exists) {
        Map<String, dynamic> data = Map<String, dynamic>.from(snapshot.value as Map);
        return UserFormModel.fromMap(data);
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching data: $e');
      return null;
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
