class RecommendationService {
  // Konfiguracja z preferencjami użytkownika (Boolean) i mapą wag
  final Map<String, bool> userPreferences;
  final Map<String, int> preferenceWeights;

  // Konstruktor
  RecommendationService({
    required this.userPreferences,
    required this.preferenceWeights,
  });

  // Funkcja sortująca listę według dopasowania
  List<Map<String, dynamic>> getRecommendations(
      List<Map<String, dynamic>> items,
      {Map<String, bool>? additionalCriteria, Map<String, int>? additionalWeights}) {

    // Łączenie preferencji użytkownika z dodatkowymi kryteriami
    final combinedPreferences = {...userPreferences, if (additionalCriteria != null) ...additionalCriteria};
    final combinedWeights = {...preferenceWeights, if (additionalWeights != null) ...additionalWeights};

    // Obliczanie dopasowania każdego elementu
    items.sort((a, b) {
      int scoreA = _calculateScore(a, combinedPreferences, combinedWeights);
      int scoreB = _calculateScore(b, combinedPreferences, combinedWeights);
      return scoreB.compareTo(scoreA); // Sortowanie malejąco po dopasowaniu
    });

    return items;
  }

  // Funkcja obliczająca score dopasowania dla pojedynczego elementu
  int _calculateScore(Map<String, dynamic> item, Map<String, bool> preferences, Map<String, int> weights) {
    int score = 0;

    preferences.forEach((key, value) {
      // Pobieramy wagę lub domyślnie ustawiamy 1, jeśli brak jej w mapie wag
      int weight = weights[key] ?? 1;
      if (value == true && item[key] == true) {
        score += weight; // Dodajemy wagę, jeśli preferencja jest spełniona
      }
    });

    return score;
  }
}
