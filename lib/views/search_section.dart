import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SearchSection extends StatefulWidget {
  @override
  _SearchSectionState createState() => _SearchSectionState();
}

class _SearchSectionState extends State<SearchSection> {
  final List<String> types = [
    'italian_restaurant',
    'seafood_restaurant',
    'chinese_restaurant',
    'cafe',
    'bar'
  ]; // Typy restauracji
  String? selectedType;
  List<Map<String, dynamic>> restaurants = [];
  bool isLoading = false;

  final apiKey = dotenv.env['GOOGLE_API_KEY'];

  Future<void> fetchRestaurants(String type) async {
    setState(() {
      isLoading = true;
    });

    final url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=50.060562,19.937711&radius=1500&type=$type&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Filtrowanie wyników po stronie klienta
        setState(() {
          restaurants = List<Map<String, dynamic>>.from(data['results'])
              .where((place) => !_isExcluded(place))
              .toList();
        });
      } else {
        throw Exception('Failed to load restaurants');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Funkcja sprawdzająca, czy miejsce należy do wykluczonych typów
  bool _isExcluded(Map<String, dynamic> place) {
    const excludedTypes = ['hotel', 'lodging']; // Typy do wykluczenia
    if (place['types'] != null) {
      return (place['types'] as List<dynamic>)
          .any((type) => excludedTypes.contains(type));
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              DropdownButton<String>(
                hint: Text('Select Type'),
                value: selectedType,
                onChanged: (value) {
                  setState(() {
                    selectedType = value;
                  });
                },
                items: types.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: selectedType != null
                    ? () => fetchRestaurants(selectedType!)
                    : null,
              ),
            ],
          ),
          const SizedBox(height: 16),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Expanded(
            child: ListView.builder(
              itemCount: restaurants.length,
              itemBuilder: (context, index) {
                final restaurant = restaurants[index];
                return ListTile(
                  title: Text(restaurant['name']),
                  subtitle: Text(restaurant['vicinity'] ?? 'No address'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
