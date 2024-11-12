import 'package:flutter/material.dart';
import 'package:proj_inz/models/google_api_model.dart';

class RestaurantWidget extends StatefulWidget {
  final Place place;

  const RestaurantWidget({super.key, required this.place});

  @override
  _RestaurantWidgetState createState() => _RestaurantWidgetState();
}

class _RestaurantWidgetState extends State<RestaurantWidget> {
  bool showOptions = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          showOptions = !showOptions;
        });
      },
      child: Column(
        children: [
          // Main restaurant details container
          Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Placeholder for restaurant image
                Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey,
                  child: const Icon(Icons.image, size: 40),
                ),
                SizedBox(width: 10),
                // Restaurant information
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.place.name,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.place.primaryTypeDisplayName.text,
                        style: TextStyle(color: Colors.grey),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            widget.place.rating.toString(),
                            style: const TextStyle(color: Colors.amber),
                          ),
                          if (showOptions)
                            Text(
                              " (${widget.place.userRatingCount})",
                              style: const TextStyle(color: Colors.grey),
                            ),
                          const SizedBox(width: 8),
                          const Icon(Icons.location_on, size: 16),
                          Text(
                            widget.place.shortFormattedAddress,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    IconButton(onPressed: () {}, icon: const Icon(Icons.map, size: 24)),
                    const Text(
                      '500m', // Update with real distance if available
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                )
                // Distance (if available)

              ],
            ),
          ),
          // Options bar shown on tap
          if (showOptions)
            Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildIcon(Icons.local_parking, 'Parking', widget.place.parkingOptions.freeParkingLot ? Colors.green : Colors.red),
                  _buildIcon(Icons.sports_soccer, 'Sports', widget.place.goodForWatchingSports ? Colors.green : Colors.red),
                  _buildIcon(Icons.accessible, 'Accessible', widget.place.accessibilityOptions.wheelchairAccessibleEntrance ? Colors.green : Colors.red),
                  _buildIcon(Icons.eco, 'Vegetarian', widget.place.servesLunch ? Colors.green : Colors.red),
                  _buildIcon(Icons.credit_card, 'Credit', widget.place.paymentOptions.acceptsCreditCards || widget.place.paymentOptions.acceptsDebitCards ? Colors.green : Colors.red),
                  _buildIcon(Icons.nfc, 'NFC', widget.place.paymentOptions.acceptsNfc ? Colors.green : Colors.red),
                  _buildIcon(Icons.takeout_dining, 'Takeout', widget.place.takeout ? Colors.green : Colors.red),
                  _buildIcon(Icons.pets, 'Pets', widget.place.servesWine ? Colors.green : Colors.red),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // Helper method to build icons
  Widget _buildIcon(IconData icon, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color),
        Text(label, style: TextStyle(fontSize: 10)),
      ],
    );
  }
}
