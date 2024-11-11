import 'dart:math';

class RecommendationService {
  final Map<String, bool> userPreferences;
  final Map<String, int> preferenceWeights;

  RecommendationService({
    required this.userPreferences,
    required this.preferenceWeights,
  });

  List<Map<String, dynamic>> getRecommendations(List<Map<String, dynamic>> restaurants) {
    List<Map<String, dynamic>> sortedRestaurants = [];

    for (var restaurant in restaurants) {
      int score = 0;

      // Sprawdzamy, które preferencje pasują do restauracji i dodajemy punkty
      userPreferences.forEach((key, value) {
        if (restaurant.containsKey(key)) {
          bool restaurantFeature = restaurant[key] ?? false;

          // Jeśli restauracja spełnia preferencję użytkownika, dodajemy odpowiednią wagę
          if (restaurantFeature == value) {
            score += preferenceWeights[key] ?? 0;
          }
        }
      });

      // Logowanie restauracji oraz przyznanych punktów
      print("Restaurant: ${restaurant['displayName']}, Score: $score");

      // Dodajemy restaurację do listy z jej wynikiem
      sortedRestaurants.add({
        ...restaurant,
        'score': score,
      });
    }

    // Sortowanie po wyniku
    sortedRestaurants.sort((a, b) => b['score'].compareTo(a['score']));

    return sortedRestaurants;
  }
}
