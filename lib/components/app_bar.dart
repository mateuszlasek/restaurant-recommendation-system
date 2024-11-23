import 'package:flutter/material.dart';
import 'package:proj_inz/views/MapPickerActivity.dart';

AppBar buildAppBar(BuildContext context) {
  return AppBar(
    title: const Text(
      'Projekt Inżynierski',
      style: TextStyle(color: Colors.amber, fontFamily: "Comic Sans"),
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
        Icons.location_on,
        color: Colors.white,
      ),
    ),
    actions: [
      IconButton(onPressed: () {}, icon: const Icon(Icons.location_on_outlined, color: Colors.white,)) // wybieranie "lokalizacji" telefonu
    ],
    shadowColor: Colors.black12,
    surfaceTintColor: Colors.black12,
    backgroundColor: Colors.black12,
    foregroundColor: Colors.black12,
    centerTitle: true,
  );
}
