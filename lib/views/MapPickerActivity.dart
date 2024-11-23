import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPickerActivity extends StatefulWidget {
  final double lat;
  final double lng;

  // Konstruktor przyjmujący współrzędne startowe
  const MapPickerActivity({
    Key? key,
    required this.lat,
    required this.lng,
  }) : super(key: key);

  @override
  State<MapPickerActivity> createState() => _MapActivityState();
}

class _MapActivityState extends State<MapPickerActivity> {
  late GoogleMapController _mapController;

  // Aktualnie wybrana pozycja pinezki
  LatLng? _selectedPosition;

  @override
  void initState() {
    super.initState();
    _selectedPosition = LatLng(widget.lat, widget.lng); // Ustawienie domyślnej pozycji
  }

  @override
  Widget build(BuildContext context) {
    // Początkowa lokalizacja kamery
    final CameraPosition initialCameraPosition = CameraPosition(
      target: LatLng(widget.lat, widget.lng),
      zoom: 14.0,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              // Zwraca wybraną pozycję do poprzedniego ekranu
              if (_selectedPosition != null) {
                Navigator.pop(context, _selectedPosition);
              }
            },
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: initialCameraPosition,
        onMapCreated: (controller) {
          _mapController = controller;
        },
        markers: _selectedPosition != null
            ? {
          Marker(
            markerId: const MarkerId('selected_position'),
            position: _selectedPosition!,
            draggable: true,
            onDragEnd: (newPosition) {
              setState(() {
                _selectedPosition = newPosition;
              });
            },
          ),
        }
            : {},
        onTap: (position) {
          setState(() {
            _selectedPosition = position;
          });
        },
        mapType: MapType.normal,
      ),
    );
  }
}
