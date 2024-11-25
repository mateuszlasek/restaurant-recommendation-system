import 'dart:convert';
import 'dart:math';
import 'dart:developer' as dev;

class RecommendationService {
  final Map<String, dynamic> userPreferences;
  final Map<String, int> preferenceWeights;

  RecommendationService({
    required this.userPreferences,
    required this.preferenceWeights,
  });

  double _cosineSimilarity(List<int> vecA, List<int> vecB) {
    int dotProduct = 0;
    int magnitudeA = 0;
    int magnitudeB = 0;

    for (int i = 0; i < vecA.length; i++) {
      dotProduct += vecA[i] * vecB[i];
      magnitudeA += vecA[i] * vecA[i];
      magnitudeB += vecB[i] * vecB[i];
    }

    double magnitude = sqrt(magnitudeA.toDouble()) * sqrt(magnitudeB.toDouble());
    return magnitude == 0 ? 0.0 : dotProduct / magnitude;
  }

  List<Map<String, dynamic>> getRecommendations(List<Map<String, dynamic>> restaurants) {
    List<Map<String, dynamic>> sortedRestaurants = [];

    // Tworzymy wektor preferencji użytkownika na podstawie cech
    List<int> userVector = _createPreferenceVector(userPreferences);

    // Logowanie wektora preferencji użytkownika
    print("User Vector: $userVector");

    for (var restaurant in restaurants) {
      // Logowanie wszystkich pól restauracji, w tym tych odpowiadających preferencjom
      print("Restaurant fields for ${restaurant['displayName']}:");

      // Tworzymy wektor cech restauracji
      List<int> restaurantVector = _createPreferenceVectorFromRestaurant(userPreferences, restaurant);

      // Logowanie wektora restauracji
      print("Restaurant Vector: $restaurantVector");

      // Obliczamy podobieństwo cosinusowe między wektorem użytkownika a restauracji
      double similarity = _cosineSimilarity(userVector, restaurantVector);

      // Logowanie wyniku podobieństwa
      print("Cosine Similarity for ${restaurant['displayName']}: $similarity");

      // Dodajemy restaurację do listy z wynikiem podobieństwa
      sortedRestaurants.add({
        ...restaurant,
        'similarity': similarity,
      });
    }

    // Sortowanie po podobieństwie cosinusowym (od najwyższego do najniższego)
    sortedRestaurants.sort((a, b) => b['similarity'].compareTo(a['similarity']));

    return sortedRestaurants;
  }

  // Funkcja do tworzenia wektora preferencji użytkownika, obsługująca zagnieżdżone dane
  List<int> _createPreferenceVector(Map<String, dynamic> preferences) {
    List<int> vector = [];

    preferences.forEach((key, value) {
      if (value is bool) {
        // Jeśli to wartość typu bool, dodajemy odpowiednią wagę
        vector.add(value ? (preferenceWeights[key] ?? 0) : 0);
      } else if (value is Map<String, dynamic>) {
        // Jeśli to mapa, iterujemy po jej elementach
        value.forEach((subKey, subValue) {
          if (subValue is bool) {
            vector.add(subValue ? (preferenceWeights[subKey] ?? 0) : 0);
          }
        });
      }
    });

    return vector;
  }

  // Funkcja do tworzenia wektora cech restauracji, obsługująca zagnieżdżone dane
  List<int> _createPreferenceVectorFromRestaurant(Map<String, dynamic> preferences, Map<String, dynamic> restaurant) {
    List<int> vector = [];

    preferences.forEach((key, value) {
      if (value is bool) {
        // Jeśli to wartość typu bool, sprawdzamy w restauracji
        vector.add((restaurant[key] ?? false) ? (preferenceWeights[key] ?? 0) : 0);
      } else if (value is Map<String, dynamic>) {
        // Jeśli to mapa, iterujemy po jej elementach
        value.forEach((subKey, subValue) {
          vector.add((restaurant[key]?[subKey] ?? false) ? (preferenceWeights[subKey] ?? 0) : 0);
        });
      }
    });

    return vector;
  }
}
