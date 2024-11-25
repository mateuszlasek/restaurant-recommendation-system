import 'dart:math';

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
    // Tworzymy wektor preferencji użytkownika na podstawie cech
    List<int> userVector = _createPreferenceVector(userPreferences);
    print("User Vector: $userVector");

    List<Map<String, dynamic>> sortedRestaurants = restaurants.map((restaurant) {
      // Tworzymy wektor cech restauracji
      List<int> restaurantVector = _createPreferenceVector(restaurant);
      print("Restaurant Vector for ${restaurant['displayName']}: $restaurantVector");

      // Obliczamy podobieństwo kosinusowe
      double similarity = _cosineSimilarity(userVector, restaurantVector);
      print("Cosine Similarity for ${restaurant['displayName']}: $similarity");

      return {
        ...restaurant,
        'similarity': similarity,
      };
    }).toList();

    // Sortowanie po podobieństwie cosinusowym (od najwyższego do najniższego)
    sortedRestaurants.sort((a, b) => b['similarity'].compareTo(a['similarity']));

    return sortedRestaurants;
  }

  List<int> _createPreferenceVector(Map<String, dynamic> source) {
    return userPreferences.keys.expand((key) {
      if (userPreferences[key] is bool) {
        // Obsługa prostych wartości typu bool
        return [
          source[key] == true ? (preferenceWeights[key] ?? 0) : 0,
        ];
      } else if (userPreferences[key] is Map<String, dynamic>) {
        // Obsługa zagnieżdżonych wartości
        return (userPreferences[key] as Map<String, dynamic>).keys.map((subKey) {
          return source[key]?[subKey] == true ? (preferenceWeights[subKey] ?? 0) : 0;
        });
      }
      return [0];
    }).toList();
  }
}
