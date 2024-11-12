import 'dart:math';

class RecommendationService {
  final Map<String, bool> userPreferences;
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
    List<int> userVector = userPreferences.keys.map((key) {
      return userPreferences[key]! ? preferenceWeights[key] ?? 0 : 0;
    }).toList();

    for (var restaurant in restaurants) {
      // Tworzymy wektor cech restauracji
      List<int> restaurantVector = userPreferences.keys.map((key) {
        return (restaurant[key] ?? false) ? preferenceWeights[key] ?? 0 : 0;
      }).toList();

      // Obliczamy podobieństwo cosinusowe między wektorem użytkownika a restauracji
      double similarity = _cosineSimilarity(userVector, restaurantVector);

      // Logowanie wyniku podobieństwa
      print("Restaurant: ${restaurant['displayName']}, Cosine Similarity: $similarity");

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
}
