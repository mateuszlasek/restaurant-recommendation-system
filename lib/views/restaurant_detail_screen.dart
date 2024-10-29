// restaurant_detail_screen.dart
import 'package:flutter/material.dart';

class RestaurantDetailScreen extends StatelessWidget {
  final dynamic restaurant;

  RestaurantDetailScreen({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    final displayName = restaurant['displayName']['text'] ?? 'Unknown';
    final formattedAddress = restaurant['formattedAddress'] ?? 'No address available';
    final rating = restaurant['rating']?.toString() ?? 'N/A';
    final phoneNumber = restaurant['internationalPhoneNumber'] ?? 'N/A';
    final website = restaurant['websiteUri'] ?? '';
    final openingHours = restaurant['regularOpeningHours']?['weekdayDescriptions']?.join(', ') ?? 'No hours available';

    return Scaffold(
      appBar: AppBar(
        title: Text(displayName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Address: $formattedAddress',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Rating: $rating',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Phone: $phoneNumber',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            if (website.isNotEmpty)
              Text(
                'Website: $website',
                style: TextStyle(fontSize: 18),
              ),
            SizedBox(height: 10),
            Text(
              'Opening Hours: $openingHours',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
