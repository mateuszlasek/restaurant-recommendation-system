import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RestaurantLocationScreen extends StatelessWidget {
  final double latitude;
  final double longitude;
  final String placeName;

  const RestaurantLocationScreen({
    Key? key,
    required this.latitude,
    required this.longitude,
    required this.placeName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(placeName),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(latitude, longitude),
          zoom: 15,
        ),
        markers: {
          Marker(
            markerId: MarkerId(placeName),
            position: LatLng(latitude, longitude),
            infoWindow: InfoWindow(title: placeName),
          ),
        },
      ),
    );
  }
}
