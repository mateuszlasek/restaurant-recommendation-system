import 'dart:math';

class RecommendationService {
  // Konfiguracja z preferencjami użytkownika i wagami
  final Map<String, bool> userPreferences;
  final Map<String, int> preferenceWeights;

  // Konstruktor
  RecommendationService({
    required this.userPreferences,
    required this.preferenceWeights,
  });

  // Funkcja sortująca listę według podobieństwa cosinusowego
  List<Map<String, dynamic>> getRecommendations(
      List<Map<String, dynamic>> items,
      {Map<String, bool>? additionalCriteria, Map<String, int>? additionalWeights}) {

    // Łączenie preferencji użytkownika z dodatkowymi kryteriami
    final combinedPreferences = {...userPreferences, if (additionalCriteria != null) ...additionalCriteria};
    final combinedWeights = {...preferenceWeights, if (additionalWeights != null) ...additionalWeights};

    // Obliczanie dopasowania każdego elementu
    items.sort((a, b) {
      double scoreA = _calculateCosineSimilarity(a, combinedPreferences, combinedWeights);
      double scoreB = _calculateCosineSimilarity(b, combinedPreferences, combinedWeights);
      return scoreB.compareTo(scoreA); // Sortowanie malejąco po dopasowaniu
    });

    return items;
  }

  // Funkcja obliczająca podobieństwo cosinusowe między preferencjami użytkownika a elementem
  double _calculateCosineSimilarity(
      Map<String, dynamic> item, Map<String, bool> preferences, Map<String, int> weights) {

    double dotProduct = 0;
    double userMagnitude = 0;
    double itemMagnitude = 0;

    preferences.forEach((key, value) {
      int weight = weights[key] ?? 1; // Domyślna waga 1

      // Wektor użytkownika: 1 (ważony przez wagę), jeśli preferencja jest `true`; inaczej 0
      double userValue = value ? weight.toDouble() : 0;
      // Wektor elementu: 1 (ważony przez wagę), jeśli element spełnia kryterium; inaczej 0
      double itemValue = (item[key] == true) ? weight.toDouble() : 0;

      // Liczenie iloczynu skalarny (dot product)
      dotProduct += userValue * itemValue;
      // Liczenie długości wektora użytkownika
      userMagnitude += pow(userValue, 2);
      // Liczenie długości wektora elementu
      itemMagnitude += pow(itemValue, 2);
    });

    // Obliczenie końcowego wyniku podobieństwa cosinusowego
    if (userMagnitude == 0 || itemMagnitude == 0) {
      return 0; // Jeśli jeden z wektorów jest zerowy, zwróć 0, brak podobieństwa
    } else {
      return dotProduct / (sqrt(userMagnitude) * sqrt(itemMagnitude));
    }
  }
}
