import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPickerActivity extends StatefulWidget {
  @override
  _MapPickerActivityState createState() => _MapPickerActivityState();
}

class _MapPickerActivityState extends State<MapPickerActivity> {
  // Kontroler mapy Google
  late GoogleMapController _mapController;

  // Współrzędne wybranej pozycji
  LatLng? _selectedPosition;

  // Początkowe położenie mapy (przykład: Warszawa)
  final LatLng _initialPosition = LatLng(52.2297, 21.0122);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pick a Location"),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 12,
            ),
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            onTap: (LatLng position) {
              setState(() {
                _selectedPosition = position;
              });
            },
            markers: _selectedPosition != null
                ? {
              Marker(
                markerId: MarkerId("selected_location"),
                position: _selectedPosition!,
              ),
            }
                : {},
          ),
          if (_selectedPosition != null)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Selected Location:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Latitude: ${_selectedPosition!.latitude}, "
                            "Longitude: ${_selectedPosition!.longitude}",
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          // Zapisz współrzędne lub prześlij dalej
                          Navigator.pop(context, _selectedPosition);
                        },
                        child: Text("Confirm Location"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
