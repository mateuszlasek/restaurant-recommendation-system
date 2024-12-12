import 'package:flutter/material.dart';
import 'package:proj_inz/services/google_api/google_api_service.dart';

class SearchSection extends StatefulWidget {
  @override
  _SearchSectionState createState() => _SearchSectionState();
}

class _SearchSectionState extends State<SearchSection> {
  final Map<String, List<String>> cuisineMap = {
    "Kuchnia bliskowschodnia": [
      "middle_eastern_restaurant",
      "afghani_restaurant",
      "turkish_restaurant",
      "lebanese_restaurant"
    ],
    "Kuchnia afrykańska": [
      "african_restaurant"
    ],
    "Kuchnia amerykańska": [
      "american_restaurant",
      "hamburger_restaurant",
      "steak_house"
    ],
    "Kuchnia azjatycka": [
      "asian_restaurant",
      "chinese_restaurant",
      "indonesian_restaurant",
      "thai_restaurant",
      "vietnamese_restaurant"
    ],
    "Grill": [
      "bar_and_grill",
      "barbecue_restaurant",
      "steak_house"
    ],
    "Fastfood": [
      "fast_food_restaurant",
      "american_restaurant",
      "hamburger_restaurant",
      "bar_and_grill",
      "barbecue_restaurant",
      "steak_house"
    ],
    "Kuchnia hinduska": [
      "indian_restaurant"
    ],
    "Kuchnia włoska": [
      "italian_restaurant",
      "pizza_restaurant"
    ],
    "Kuchnia Japońska": [
      "japanese_restaurant",
      "korean_restaurant",
      "ramen_restaurant",
      "sushi_restaurant"
    ],
    "Kuchnia Meksykańska": [
      "mexican_restaurant"
    ],
    "Owoce morza": [
      "seafood_restaurant"
    ],
    "Kuchnia wegańska": [
      "vegan_restaurant"
    ],
    "Kuchnia wegetariańska": [
      "vegetarian_restaurant"
    ],
    "Kuchnia francuska": [
      "french_restaurant"
    ],
    "Kuchnia grecka": [
      "greek_restaurant"
    ],
    "Kuchnia hiszpańska": [
      "spanish_restaurant"
    ],
    "Kuchnia śródziemnomorska": [
      "french_restaurant",
      "greek_restaurant",
      "mediterranean_restaurant",
      "spanish_restaurant",
      "seafood_restaurant",
      "italian_restaurant",
      "lebanese_restaurant",
      "turkish_restaurant"
    ],
    "Kuchnia brazylijska": [
      "brazilian_restaurant"
    ]
  };


  String? selectedCuisine;
  List<String>? selectedOptions;

  void handleSearch(List<String>? options) {
    // Add logic to handle search
    print("Selected options: $options");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButton<String>(
                  hint: Text('Wybierz kuchnię'),
                  value: selectedCuisine,
                  onChanged: (value) {
                    setState(() {
                      selectedCuisine = value;
                      selectedOptions = cuisineMap[value];
                    });
                  },
                  items: cuisineMap.keys.map((String key) {
                    return DropdownMenuItem<String>(
                      value: key,
                      child: Text(key),
                    );
                  }).toList(),
                ),
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  handleSearch(selectedOptions);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
