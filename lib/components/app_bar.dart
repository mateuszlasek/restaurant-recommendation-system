import 'package:flutter/material.dart';

AppBar buildAppBar() {
  return AppBar(
    title: const Text(
      'Projekt Inżynierski',
      style: TextStyle(color: Colors.amber, fontFamily: "Comic Sans"),
    ),
    actions: [
      IconButton(onPressed: () {}, icon: const Icon(Icons.location_on_outlined)) // wybieranie "lokalizacji" telefonu
    ],
    shadowColor: Colors.black12,
    surfaceTintColor: Colors.black12,
    backgroundColor: Colors.black12,
    foregroundColor: Colors.black12,
    centerTitle: true,
  );
}
