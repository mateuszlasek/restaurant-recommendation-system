import 'package:geolocator/geolocator.dart';
import 'package:proj_inz/services/recomandation_algorithm/recommendation_service.dart';
import '../../models/user_form_model.dart';
import '../firebase_database/firebase_service.dart';
import '../google_api/google_api_service.dart';

class RestaurantDataService {
  final FirebaseService _firebaseService = FirebaseService();
  final RestaurantService _restaurantService = RestaurantService();

  Future<List<Map<String, dynamic>>> fetchRecommendedRestaurants() async {
    try {
      String? uid = await _firebaseService.getUserUID();
      if (uid != null) {
        UserFormModel? userForm = await _firebaseService.getUserFormByUID(uid);
        if (userForm != null) {
          Position position = await _determinePosition();
          return await _getRecommendedList(position.latitude, position.longitude, userForm);
        }
      }
    } catch (e) {
      print('Error in fetching recommended restaurants: $e');
    }
    return [];
  }

  Future<Position> _determinePosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      await Geolocator.openLocationSettings();
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.deniedForever || permission == LocationPermission.denied) {
      throw Exception('Location permissions are denied');
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<List<Map<String, dynamic>>> _getRecommendedList(
      double latitude, double longitude, UserFormModel userForm) async {
    List<dynamic> response = await _restaurantService.fetchNearbyRestaurants(latitude, longitude);
    List<Map<String, dynamic>> restaurantList = List<Map<String, dynamic>>.from(response);

    Map<String, dynamic> userPreferences = {
      'servesVegetarianFood': userForm.servesVegetarianFood,
      'menuForChildren': userForm.menuForChildren,
      'goodForChildren': userForm.goodForChildren,
      'allowsDogs': userForm.allowsDogs,

      // Zagnieżdżony obiekt paymentOptions
      'paymentOptions': {
        'acceptsCreditCards': userForm.acceptsCreditCards,
        'acceptsDebitCards': userForm.acceptsDebitCards,
        'acceptsCashOnly': userForm.acceptsCashOnly,
        'acceptsNfc': userForm.acceptsNfc,
      },

      // Zagnieżdżony obiekt parkingOptions
      'parkingOptions': {
        'freeParkingLot': userForm.freeParkingLot,
        'paidParkingLot': userForm.paidParkingLot,
      },

      // Zagnieżdżony obiekt accessibilityOptions
      'accessibilityOptions': {
        'wheelchairAccessibleParking': userForm.wheelchairAccessibleParking,
        'wheelchairAccessibleEntrance': userForm.wheelchairAccessibleEntrance,
        'wheelchairAccessibleRestroom': userForm.wheelchairAccessibleRestroom,
      },
    };


    RecommendationService recommendationService = RecommendationService(
      userPreferences: userPreferences,
      preferenceWeights: _getPreferenceWeights(),
    );

    return recommendationService.getRecommendations(restaurantList);
  }

  Map<String, int> _getPreferenceWeights() {
    return {
      'servesVegetarianFood': 1,
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
    };
  }
}

