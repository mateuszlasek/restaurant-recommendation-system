import 'package:flutter/material.dart';
import 'package:proj_inz/views/map_picker_activity.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Position> _determinePosition() async {
  if (!await Geolocator.isLocationServiceEnabled()) {
    await Geolocator.openLocationSettings();
    throw Exception('Location services are disabled.');
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) permission = await Geolocator.requestPermission();
  if (permission == LocationPermission.deniedForever || permission == LocationPermission.denied) {
    throw Exception('Location permissions are denied');
  }
  return await Geolocator.getCurrentPosition();
}

Future<void> _saveLocation(Position position) async {
  print("Position ${position}");
  print("lat: ${position.latitude.toDouble()}");
  print("lang: ${position.longitude.toDouble()}");
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setStringList('Position',
      [position.latitude.toString(), position.longitude.toString()]);
  Future.delayed(const Duration(milliseconds: 1000));
}

AppBar buildAppBar(BuildContext context) {
  return AppBar(
    title: const Text(
      'LocEat',
      style: TextStyle(color: Colors.amber),
    ),
    leading: IconButton(
      onPressed: () {
        // Użyj Navigator.push, aby przejść do MapPickerActivity
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MapPickerActivity(lat:50.06159761834602, lng: 19.93765353577862),
          ),
        );
      },
      icon: const Icon(
        Icons.edit_location_alt_outlined,
        color: Colors.white,
      ),
    ),
    actions: [
      IconButton(onPressed: () async {
        Position position = await _determinePosition();
        await _saveLocation(position);

      }
      , icon: const Icon(Icons.my_location, color: Colors.white,)) // wybieranie "lokalizacji" telefonu
    ],
    shadowColor: Colors.black12,
    surfaceTintColor: Colors.black12,
    backgroundColor: Colors.black12,
    foregroundColor: Colors.black12,
    centerTitle: true,
  );
}
