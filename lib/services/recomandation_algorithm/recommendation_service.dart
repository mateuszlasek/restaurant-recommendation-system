class RecommendationService {
  // Konfiguracja z preferencjami użytkownika
  final Map<String, bool> userPreferences;

  // Konstruktor
  RecommendationService({
    required this.userPreferences,
  });

  // Funkcja sortująca listę według dopasowania
  List<Map<String, dynamic>> getRecommendations(
      List<Map<String, dynamic>> items,
      {Map<String, bool>? additionalCriteria}) {

    // Łączenie preferencji użytkownika z dodatkowymi kryteriami
    final combinedPreferences = {...userPreferences, if (additionalCriteria != null) ...additionalCriteria};

    // Obliczanie dopasowania każdego elementu
    items.sort((a, b) {
      int scoreA = _calculateScore(a, combinedPreferences);
      int scoreB = _calculateScore(b, combinedPreferences);
      return scoreB.compareTo(scoreA); // Sortowanie malejąco po dopasowaniu
    });

    return items;
  }

  // Funkcja obliczająca score dopasowania dla pojedynczego elementu
  int _calculateScore(Map<String, dynamic> item, Map<String, bool> preferences) {
    int score = 0;

    preferences.forEach((key, value) {
      if (value == true && item[key] == true) {
        score += 1; // Dodajemy punkt, jeśli preferencja jest spełniona
      }
    });

    return score;
  }
}
