import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  // Funkcja do zapisywania lokalizacji w SharedPreferences
  Future<void> _saveLocation(LatLng position) async {
    print("Position ${position}");
    print("lat: ${position.latitude.toDouble()}");
    print("lang: ${position.longitude.toDouble()}");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('Position', [position.latitude.toString(), position.longitude.toString()]);
    Future.delayed(Duration(milliseconds: 1000));
  }

  @override
  Widget build(BuildContext context) {
    // Początkowa lokalizacja kamery
    final CameraPosition initialCameraPosition = CameraPosition(
      target: _selectedPosition ?? LatLng(widget.lat, widget.lng),
      zoom: 14.0,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wybrana lokalizacja'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              // Zapisuje wybraną pozycję w SharedPreferences
              if (_selectedPosition != null) {
                _saveLocation(_selectedPosition!);
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
              // Zapisuje nową pozycję po przesunięciu pinezki
              _saveLocation(newPosition);
            },
          ),
        }
            : {},
        onTap: (position) {
          setState(() {
            _selectedPosition = position;
          });
          // Zapisuje nową pozycję po tapnięciu na mapę
          _saveLocation(position);
        },
        mapType: MapType.normal,
      ),
    );
  }
}
