import 'package:flutter/material.dart';
import 'package:proj_inz/components/restaurant_info_widget.dart';
import 'package:proj_inz/models/google_api_model.dart';

import '../services/restaurant/restaurant_data_service.dart';

class HomeSection extends StatefulWidget {
  HomeSection({super.key});

  @override
  State<HomeSection> createState() => _HomeSectionState();
}

class _HomeSectionState extends State<HomeSection> {
  final RestaurantDataService _dataService = RestaurantDataService();
  List<Place> recommendedRestaurants = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRecommendations();
  }

  Future<void> _fetchRecommendations() async {
    try {
      List<Map<String, dynamic>> restaurantData =
          await _dataService.fetchRecommendedRestaurants();
      setState(() {
        recommendedRestaurants =
            restaurantData.map((data) => Place.fromJson(data)).toList();
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching recommendations: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: isLoading
            ? const CircularProgressIndicator(
                color: Colors.amber,
              )
            : RefreshIndicator(
                onRefresh: _fetchRecommendations,
                color: Colors.amber,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: recommendedRestaurants.length,
                        itemBuilder: (context, index) {
                          final place = recommendedRestaurants[index];
                          return Column(
                            children: [
                              RestaurantWidget(place: place),
                              const Divider(
                                height: 0,
                                thickness: 1,
                                color: Colors.amber,
                                indent: 10,
                                endIndent: 10,
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ));
  }
}
